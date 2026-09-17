// DoD: species_ko.json 300종 이상, 독성 정보 누락 0건, 학명 중복 0건, 파서 통과
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/repositories/species_repository.dart';
import 'package:plant_app/data/seed/species_seed.dart';

void main() {
  late String raw;

  setUpAll(() {
    raw = File('assets/species_ko.json').readAsStringSync();
  });

  test('300종 이상, 학명 중복 없음, 독성 필드 누락 0건', () {
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final list = (root['species'] as List).cast<Map<String, dynamic>>();
    expect(list.length, greaterThanOrEqualTo(300));

    final names = list.map(
      (m) => (m['scientific_name'] as String).toLowerCase(),
    );
    expect(names.toSet().length, list.length, reason: '학명 중복');

    for (final m in list) {
      expect(
        m['toxic_pet'],
        isA<bool>(),
        reason: '${m['scientific_name']} toxic_pet',
      );
      expect(
        m['toxic_child'],
        isA<bool>(),
        reason: '${m['scientific_name']} toxic_child',
      );
      expect(
        (m['ko_names'] as List),
        isNotEmpty,
        reason: '${m['scientific_name']} ko_names',
      );
      expect(m['base_water_days'], inInclusiveRange(2, 45));
      // v3: 적정 온도·아이 독성 3단계·독성 설명
      final level = m['toxic_child_level'];
      expect(['none', 'irritant', 'toxic'], contains(level));
      expect(m['toxic_child'], level == 'toxic');
      expect((m['toxicity_note'] as String).trim(), isNotEmpty);
      expect(m['temp_min'] as int, lessThanOrEqualTo(m['temp_opt_min'] as int));
      expect(m['temp_opt_min'] as int, lessThan(m['temp_opt_max'] as int));
      expect(m['temp_opt_max'] as int, lessThanOrEqualTo(m['temp_max'] as int));
      expect(['low', 'med', 'high'], contains(m['light_pref']));
    }
  });

  test('파서로 전부 Companion 변환되고 DB에 시드된다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final inserted = await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: raw);
    expect(inserted, greaterThanOrEqualTo(300));
    expect(await SpeciesRepository(db).count(), inserted);
  });

  test('대표 품종이 국내명·학명으로 검색된다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: raw);
    final repo = SpeciesRepository(db);

    final monstera = await repo.search('몬스테라');
    expect(monstera, isNotEmpty);
    expect(monstera.first.koNames.first, contains('몬스테라'));

    final byLatin = await repo.search('monstera');
    expect(byLatin, isNotEmpty);

    final skin = await repo.search('스킨답서스');
    expect(skin, isNotEmpty);
    expect(skin.first.toxicPet, isTrue); // Epipremnum aureum 은 반려동물 독성

    // 경고 대상은 위험한 식물만
    final dracaena = await repo.search('행운목');
    expect(dracaena.first.toxicSevere, isFalse);
    final oleander = await repo.search('협죽도');
    expect(oleander.first.toxicSevere, isTrue);

    // 백합: 고양이 치명, 사람(아이) 독성 없음 → 경고 대상
    final lily = await repo.search('백합');
    expect(lily.first.toxicPet, isTrue);
    expect(lily.first.toxicChildLevel, ChildToxicity.none);
    expect(lily.first.toxicSevere, isTrue);
  });

  test('모든 품종에 영어 이름이 있고, 사진은 출처·라이선스가 붙어 있다', () {
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final list = (root['species'] as List).cast<Map<String, dynamic>>();
    var photos = 0;
    for (final m in list) {
      final sci = m['scientific_name'];
      expect((m['names_en'] as List?) ?? const [], isNotEmpty, reason: '$sci');
      final url = m['image_url'] as String?;
      if (url == null) continue;
      photos++;
      expect(url, startsWith('https://upload.wikimedia.org/'), reason: '$sci');
      expect(m['image_license'], isNotNull, reason: '$sci');
      expect(
        m['image_page'],
        startsWith('https://commons.wikimedia.org/'),
        reason: '$sci',
      );
    }
    expect(photos, greaterThan(300));
  });

  test('영어 검색도 된다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: raw);
    final repo = SpeciesRepository(db);
    expect(await repo.search('snake plant'), isNotEmpty);
    expect(await repo.search('ZZ plant'), isNotEmpty);
  });
}
