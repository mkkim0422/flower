import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/repositories/plant_repository.dart';
import 'package:plant_app/data/repositories/space_repository.dart';
import 'package:plant_app/data/seed/species_seed.dart';
import 'package:plant_app/domain/watering_rules.dart';

const _seedJson = '''
{"version":1,"species":[
 {"scientific_name":"Epipremnum aureum","ko_names":["스킨답서스","에피프레넘"],"family":"Araceae","category":"foliage",
  "base_water_days":7,"light_pref":"med","toxic_pet":true,"toxic_child":true,"temp_min":15,"temp_max":28,
  "fert_days":30,"repot_months":12,"common_issues":["잎 노랗게 → 과습"]},
 {"scientific_name":"Echeveria elegans","ko_names":["에케베리아"],"family":"Crassulaceae","category":"succulent",
  "base_water_days":20,"light_pref":"high","toxic_pet":false,"toxic_child":false,"temp_min":5,"temp_max":30,
  "fert_days":null,"repot_months":24,"common_issues":["웃자람 → 빛 부족"]}
]}
''';

void main() {
  late AppDatabase db;
  late PlantRepository plants;
  late SpaceRepository spaces;
  // 2026-04-15 (봄, season 1.0)
  final fixedNow = DateTime(2026, 4, 15, 10);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: _seedJson);
    plants = PlantRepository(db, clock: () => fixedNow);
    spaces = SpaceRepository(db);
  });

  tearDown(() => db.close());

  test('시드는 비어 있을 때만 들어가고, 검색 텍스트가 만들어진다', () async {
    final again = await SpeciesSeedLoader(db).seedIfEmpty(jsonOverride: _seedJson);
    expect(again, 0);
    final row = await (db.select(db.species)).get();
    expect(row.length, 2);
    expect(row.first.searchText, contains('스킨답서스'));
    expect(row.first.searchText, contains('epipremnum aureum'));
  });

  test('등록: 남향 창가 + M + 배수구 → 7×0.8 = 5.6 → 6일, next = last + 6', () async {
    final spaceId = await spaces.create(
      name: '거실',
      windowDir: WindowDir.s,
      windowDist: WindowDist.near,
    );
    final species = await (db.select(db.species)).get();
    final id = await plants.create(
      nickname: '초록이',
      speciesId: species.first.id,
      spaceId: spaceId,
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 13),
    );
    final e = (await plants.getById(id))!;
    expect(e.plant.waterIntervalDays, 6);
    expect(e.plant.nextCheckAt, DateTime(2026, 4, 19));
    expect(e.isDue(fixedNow), isFalse);
    expect(e.dDay(fixedNow), 4);
    expect(e.statusLabel(fixedNow), 'D-4');

    final events = await plants.watchCareEvents(id).first;
    expect(events.single.type, CareType.water);
  });

  test('품종 미지정·공간 없음 → base 7, 상태 unknown', () async {
    final id = await plants.create(
      nickname: '이름만',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 15),
    );
    final e = (await plants.getById(id))!;
    expect(e.plant.waterIntervalDays, 7);
    expect(e.displaySpeciesName, '품종 미지정');
    expect(e.statusLabel(fixedNow), 'D-7 · 미지정');
  });

  test('흙 확인 E2E: 오늘 확인 → 촉촉 → 재확인일·계수 보정 → 말랐음 2회 → 계수 0.9', () async {
    final id = await plants.create(
      nickname: '초록이',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 8), // 7일 전 → 오늘 확인
    );
    var e = (await plants.getById(id))!;
    expect(e.isDue(fixedNow), isTrue);
    expect(e.statusLabel(fixedNow), '오늘 확인');

    // 아직 촉촉해요
    await plants.recordSoilCheck(id, SoilCheckResult.wet);
    e = (await plants.getById(id))!;
    expect(e.plant.feedbackCoef, closeTo(1.15, 1e-9));
    expect(e.plant.waterIntervalDays, 8); // 7×1.15 = 8.05
    expect(e.plant.lastWateredAt, DateTime(2026, 4, 8)); // 물 안 줌
    expect(e.plant.nextCheckAt, DateTime(2026, 4, 17)); // 2일 후 재확인
    expect(e.isDue(fixedNow), isFalse);

    // 말랐어요 1회 → 물 줌, streak 1
    await plants.recordSoilCheck(id, SoilCheckResult.dry);
    e = (await plants.getById(id))!;
    expect(e.plant.dryStreak, 1);
    expect(e.plant.feedbackCoef, closeTo(1.15, 1e-9));
    expect(e.plant.lastWateredAt, fixedNow);
    expect(e.plant.nextCheckAt, DateTime(2026, 4, 23)); // 15 + 8

    // 말랐어요 2회 연속 → ×0.9
    await plants.recordSoilCheck(id, SoilCheckResult.dry);
    e = (await plants.getById(id))!;
    expect(e.plant.dryStreak, 0);
    expect(e.plant.feedbackCoef, closeTo(1.035, 1e-9));
    expect(e.plant.waterIntervalDays, 7); // 7×1.035 = 7.245

    final events = await plants.watchCareEvents(id).first;
    expect(events.map((x) => x.type).toList(), [
      CareType.water,
      CareType.checkDry,
      CareType.water,
      CareType.checkDry,
      CareType.checkWet,
      CareType.water,
    ]);
  });

  test('수동 주기 설정 후 흙 확인해도 수동값 유지, 해제 시 자동 복귀', () async {
    final id = await plants.create(
      nickname: '수동이',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 15),
    );
    await plants.setManualInterval(id, 3);
    var e = (await plants.getById(id))!;
    expect(e.plant.manualOverride, isTrue);
    expect(e.plant.waterIntervalDays, 3);
    expect(e.plant.nextCheckAt, DateTime(2026, 4, 18));

    await plants.recordSoilCheck(id, SoilCheckResult.wet);
    e = (await plants.getById(id))!;
    expect(e.plant.waterIntervalDays, 3);

    await plants.setManualInterval(id, null);
    e = (await plants.getById(id))!;
    expect(e.plant.manualOverride, isFalse);
    expect(e.plant.waterIntervalDays, 8); // 7 × 1.15
  });

  test('다중 선택 일괄 완료', () async {
    final a = await plants.create(
      nickname: 'A',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 1),
    );
    final b = await plants.create(
      nickname: 'B',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 1),
    );
    await plants.recordSoilCheckBatch([a, b], SoilCheckResult.dry);
    final all = await plants.watchAll().first;
    expect(all.every((e) => e.plant.lastWateredAt == fixedNow), isTrue);
    expect(all.every((e) => !e.isDue(fixedNow)), isTrue);
  });

  test('공간 변경 시 재계산, 공간 삭제 시 space_id null', () async {
    final s = await spaces.create(
      name: '베란다',
      windowDir: WindowDir.none,
      windowDist: WindowDist.far,
    );
    final id = await plants.create(
      nickname: 'C',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: DateTime(2026, 4, 15),
    );
    expect((await plants.getById(id))!.plant.waterIntervalDays, 7);
    await plants.updateBasic(id: id, spaceId: Value(s));
    expect((await plants.getById(id))!.plant.waterIntervalDays, 9); // 7×1.3 = 9.1
    await spaces.delete(s);
    final e = (await plants.getById(id))!;
    expect(e.plant.spaceId, isNull);
    expect(e.space, isNull);
  });
}
