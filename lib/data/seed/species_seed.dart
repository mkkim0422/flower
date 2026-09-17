// assets/species_ko.json → species 테이블 시드 (첫 실행 시 1회)
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

const kSpeciesSeedAsset = 'assets/species_ko.json';

class SpeciesSeedLoader {
  SpeciesSeedLoader(this.db);

  final AppDatabase db;

  /// 시드를 학명 기준으로 upsert 한다. 앱 시작마다 실행되어
  /// 새 버전의 JSON에 추가·수정된 품종이 기존 설치에도 반영된다. 처리한 행 수 반환.
  Future<int> seedIfEmpty({
    String asset = kSpeciesSeedAsset,
    String? jsonOverride,
  }) async {
    final raw = jsonOverride ?? await rootBundle.loadString(asset);
    final companions = parseSeed(raw);
    await db.batch((b) {
      for (final c in companions) {
        b.insert(
          db.species,
          c,
          onConflict: DoUpdate((_) => c, target: [db.species.scientificName]),
        );
      }
    });
    return companions.length;
  }

  /// JSON 문자열 → Companion 목록. 형식 오류는 예외.
  static List<SpeciesCompanion> parseSeed(String raw) {
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final list = (root['species'] as List).cast<Map<String, dynamic>>();
    return list.map(_toCompanion).toList();
  }

  static SpeciesCompanion _toCompanion(Map<String, dynamic> m) {
    final koNames = (m['ko_names'] as List).cast<String>();
    final sci = m['scientific_name'] as String;
    return SpeciesCompanion.insert(
      scientificName: sci,
      koNames: koNames,
      family: Value(m['family'] as String?),
      baseWaterDays: m['base_water_days'] as int,
      lightPref: LightPref.values.byName(m['light_pref'] as String),
      toxicPet: m['toxic_pet'] as bool,
      toxicChild: m['toxic_child'] as bool,
      tempMin: Value(m['temp_min'] as int?),
      tempMax: Value(m['temp_max'] as int?),
      fertDays: Value(m['fert_days'] as int?),
      repotMonths: Value(m['repot_months'] as int?),
      commonIssues: Value(
        ((m['common_issues'] as List?) ?? const []).cast<String>(),
      ),
      category: Value((m['category'] as String?) ?? 'foliage'),
      toxicityNote: Value((m['toxicity_note'] as String?) ?? ''),
      tempOptMin: Value(m['temp_opt_min'] as int?),
      tempOptMax: Value(m['temp_opt_max'] as int?),
      toxicChildLevel: Value(switch (m['toxic_child_level'] as String?) {
        'toxic' => ChildToxicity.toxic,
        'irritant' => ChildToxicity.irritant,
        'none' => ChildToxicity.none,
        _ =>
          (m['toxic_child'] as bool) ? ChildToxicity.toxic : ChildToxicity.none,
      }),
      searchText: Value(buildSearchText(sci, koNames)),
    );
  }

  /// 검색용 문자열: 학명 + 국내명 전부, 소문자, 공백 제거본도 포함
  static String buildSearchText(String scientificName, List<String> koNames) {
    final parts = <String>[scientificName, ...koNames];
    final normalized = parts.map((p) => p.toLowerCase()).toList();
    final compact = normalized.map((p) => p.replaceAll(' ', ''));
    return {...normalized, ...compact}.join(' ');
  }
}

/// 앱 시작 시 1회 실행. 완료 전에는 검색 화면이 대기.
final speciesSeedProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  return SpeciesSeedLoader(db).seedIfEmpty();
});
