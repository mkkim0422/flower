import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/repositories/diary_repository.dart';
import 'package:plant_app/data/repositories/plant_repository.dart';
import 'package:plant_app/data/repositories/settings_repository.dart';
import 'package:plant_app/data/repositories/space_repository.dart';
import 'package:plant_app/data/seed/species_seed.dart';
import 'package:plant_app/domain/backup_service.dart';
import 'package:plant_app/domain/watering_rules.dart';

const _seed = '''
{"species":[{"scientific_name":"Monstera deliciosa","ko_names":["몬스테라"],"family":"Araceae","category":"foliage",
 "base_water_days":7,"light_pref":"med","toxic_pet":true,"toxic_child":true,"temp_min":12,"temp_max":30,
 "fert_days":30,"repot_months":18,"common_issues":[]}]}''';

void main() {
  final now = DateTime(2026, 9, 17, 10);

  Future<AppDatabase> seeded() async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: _seed);
    return db;
  }

  test('내보내기 → 새 DB로 가져오기: 식물·공간·기록·일기·설정·품종 매칭 유지', () async {
    final src = await seeded();
    addTearDown(src.close);
    final plants = PlantRepository(src, clock: () => now);
    final spaces = SpaceRepository(src);
    final diary = DiaryRepository(src, clock: () => now);
    final settings = SettingsRepository(src);
    final species = (await src.select(src.species).get()).single;

    final spaceId = await spaces.create(
      name: '거실',
      windowDir: WindowDir.s,
      windowDist: WindowDist.near,
    );
    final p1 = await plants.create(
      nickname: '몬스',
      speciesId: species.id,
      spaceId: spaceId,
      potSize: PotSize.l,
      hasDrainage: false,
      lastWateredAt: DateTime(2026, 9, 10),
      photoPath: '/old/photos/a.jpg',
      memo: '창가',
    );
    await plants.create(
      nickname: '이름만',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 9, 15),
      manualDays: 3,
    );
    await plants.recordSoilCheck(
      p1,
      SoilCheckResult.dry,
      at: DateTime(2026, 9, 16, 9),
    );
    await diary.add(
      plantId: p1,
      memo: '새잎',
      photoPath: '/old/photos/b.jpg',
      at: DateTime(2026, 9, 16),
    );
    await settings.setNotifyTime(20, 30);
    await settings.setNotifyDayBefore(true);

    final json = await BackupService(src, clock: () => now).exportJson();
    expect(json['app'], 'jaljarara');
    expect((json['plants'] as List).length, 2);
    expect(
      (json['plants'] as List).first['species_scientific_name'],
      'Monstera deliciosa',
    );
    expect((json['plants'] as List).first['photo'], 'a.jpg');

    // 새 기기: 시드만 있고(품종 id 가 다를 수 있음) 기록 없음
    final dst = await seeded();
    addTearDown(dst.close);
    await BackupService(dst).importJson(
      json,
      photoPathByName: {'a.jpg': '/new/a.jpg', 'b.jpg': '/new/b.jpg'},
    );

    final restored = await PlantRepository(dst, clock: () => now).getAll();
    expect(restored.length, 2);
    final mons = restored.firstWhere((e) => e.plant.nickname == '몬스');
    expect(mons.species?.scientificName, 'Monstera deliciosa');
    expect(mons.space?.name, '거실');
    expect(mons.plant.photoPath, '/new/a.jpg');
    expect(mons.plant.memo, '창가');
    expect(mons.plant.potSize, PotSize.l);
    expect(mons.plant.hasDrainage, isFalse);
    expect(mons.plant.lastWateredAt, DateTime(2026, 9, 16, 9));
    final manual = restored.firstWhere((e) => e.plant.nickname == '이름만');
    expect(manual.plant.manualOverride, isTrue);
    expect(manual.plant.waterIntervalDays, 3);

    final events = await PlantRepository(
      dst,
    ).watchCareEvents(mons.plant.id).first;
    expect(
      events.map((e) => e.type),
      containsAll([CareType.checkDry, CareType.water]),
    );
    final diaries = await DiaryRepository(
      dst,
    ).watchByPlant(mons.plant.id).first;
    expect(diaries.single.memo, '새잎');
    expect(diaries.single.photoPath, '/new/b.jpg');

    final st = await dst.getSettings();
    expect(st.notifyHour, 20);
    expect(st.notifyMinute, 30);
    expect(st.notifyDayBefore, isTrue);
  });

  test('가져오기는 기존 기록을 전부 교체한다', () async {
    final db = await seeded();
    addTearDown(db.close);
    final plants = PlantRepository(db, clock: () => now);
    await plants.create(
      nickname: '기존',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: now,
    );
    final json = await BackupService(db, clock: () => now).exportJson();
    await plants.create(
      nickname: '나중',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: now,
    );
    expect((await plants.getAll()).length, 2);
    await BackupService(db).importJson(json);
    final all = await plants.getAll();
    expect(all.map((e) => e.plant.nickname), ['기존']);
  });

  test('zip 왕복: backup.json + photos/, inspectZip 요약, 사진 복원', () async {
    final db = await seeded();
    addTearDown(db.close);
    final tmp = await Directory.systemTemp.createTemp('jaljarara_test');
    addTearDown(() => tmp.delete(recursive: true));
    final photo = File('${tmp.path}${Platform.pathSeparator}p.jpg');
    await photo.writeAsBytes([0xFF, 0xD8, 0xFF, 0xD9]);

    final plants = PlantRepository(db, clock: () => now);
    await plants.create(
      nickname: 'Z',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: now,
      photoPath: photo.path,
    );
    final svc = BackupService(db, clock: () => now);
    final zip = await svc.exportZip();
    expect(svc.suggestedFileName(), 'jaljarara-backup-20260917.zip');

    final archive = ZipDecoder().decodeBytes(zip);
    expect(archive.findFile('backup.json'), isNotNull);
    expect(archive.findFile('photos/p.jpg'), isNotNull);

    final summary = BackupService.inspectZip(zip)!;
    expect(summary.plants, 1);
    expect(summary.photos, 1);
    expect(summary.exportedAt, now);
    expect(
      BackupService.inspectZip(utf8.encode('not a zip') as dynamic),
      isNull,
    );

    final dst = await seeded();
    addTearDown(dst.close);
    final photoDir = Directory('${tmp.path}${Platform.pathSeparator}restored');
    await BackupService(dst).importZip(zip, photoDir: photoDir);
    final restored = await PlantRepository(dst).getAll();
    expect(File(restored.single.plant.photoPath!).existsSync(), isTrue);
    expect(restored.single.plant.photoPath, startsWith(photoDir.path));
  });
}
