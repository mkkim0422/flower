import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('스키마 생성 시 settings 단일 행이 기본값으로 존재한다', () async {
    final s = await db.getSettings();
    expect(s.id, 1);
    expect(s.notifyHour, 9);
    expect(s.notifyMinute, 0);
    expect(s.skipWeekdays, isEmpty);
    expect(s.backupUserId, isNull);
    expect(s.onboardingDone, isFalse);
  });

  test('species → plant → care_event 삽입 및 리스트 컨버터 왕복', () async {
    final speciesId = await db
        .into(db.species)
        .insert(
          SpeciesCompanion.insert(
            scientificName: 'Epipremnum aureum',
            koNames: const ['스킨답서스', '에피프레넘'],
            baseWaterDays: 7,
            lightPref: LightPref.med,
            toxicPet: true,
            toxicChild: true,
            commonIssues: const Value(['과습 시 잎 노랗게']),
          ),
        );
    final spaceId = await db
        .into(db.spaces)
        .insert(
          SpacesCompanion.insert(
            name: '거실',
            windowDir: WindowDir.s,
            windowDist: WindowDist.near,
          ),
        );
    final now = DateTime(2026, 9, 16);
    final plantId = await db
        .into(db.plants)
        .insert(
          PlantsCompanion.insert(
            speciesId: Value(speciesId),
            nickname: '초록이',
            spaceId: Value(spaceId),
            potSize: PotSize.m,
            waterIntervalDays: 7,
            lastWateredAt: now,
            nextCheckAt: now.add(const Duration(days: 7)),
            createdAt: now,
          ),
        );
    await db
        .into(db.careEvents)
        .insert(
          CareEventsCompanion.insert(
            plantId: plantId,
            type: CareType.water,
            at: now,
          ),
        );

    final species = await db.select(db.species).getSingle();
    expect(species.koNames, ['스킨답서스', '에피프레넘']);
    expect(species.commonIssues, ['과습 시 잎 노랗게']);

    final plant = await db.select(db.plants).getSingle();
    expect(plant.feedbackCoef, 1.0);
    expect(plant.manualOverride, isFalse);
    expect(plant.hasDrainage, isTrue);

    final events = await db.select(db.careEvents).get();
    expect(events.single.type, CareType.water);
  });

  test('plant 삭제 시 care_events·diary_entries가 cascade 삭제된다', () async {
    final now = DateTime(2026, 9, 16);
    final plantId = await db
        .into(db.plants)
        .insert(
          PlantsCompanion.insert(
            nickname: '이름만',
            potSize: PotSize.s,
            waterIntervalDays: 7,
            lastWateredAt: now,
            nextCheckAt: now,
            createdAt: now,
          ),
        );
    await db
        .into(db.careEvents)
        .insert(
          CareEventsCompanion.insert(
            plantId: plantId,
            type: CareType.checkDry,
            at: now,
          ),
        );
    await db
        .into(db.diaryEntries)
        .insert(
          DiaryEntriesCompanion.insert(
            plantId: plantId,
            at: now,
            tags: const Value([DiaryTag.newLeaf, DiaryTag.flower]),
          ),
        );

    final diary = await db.select(db.diaryEntries).getSingle();
    expect(diary.tags, [DiaryTag.newLeaf, DiaryTag.flower]);

    await (db.delete(db.plants)..where((t) => t.id.equals(plantId))).go();

    expect(await db.select(db.careEvents).get(), isEmpty);
    expect(await db.select(db.diaryEntries).get(), isEmpty);
  });
}
