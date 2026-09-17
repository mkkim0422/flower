import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/status_dot.dart' show PlantStatus;
import '../../core/enums.dart';
import '../../domain/watering_rules.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

/// 식물 + 품종 + 공간 조인 결과
class PlantEntry {
  const PlantEntry({required this.plant, this.species, this.space});

  final Plant plant;
  final SpeciesRow? species;
  final Space? space;

  String get displaySpeciesName =>
      species == null ? '품종 미지정' : species!.koNames.first;

  bool isDue(DateTime now) => isDueToday(plant.nextCheckAt, now);

  int dDay(DateTime now) => daysUntil(plant.nextCheckAt, now);

  PlantStatus status(DateTime now) {
    if (isDue(now)) return PlantStatus.needCheck;
    if (species == null) return PlantStatus.unknown;
    return PlantStatus.ok;
  }

  /// 상태 라벨: "D+3" (지남) / "오늘 물 주기" / "D-3"
  String statusLabel(DateTime now) {
    final d = dDay(now);
    if (d < 0) return 'D+${-d}';
    if (d == 0) return '오늘 물 주기';
    return 'D-$d';
  }
}

class PlantRepository {
  PlantRepository(this.db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final DateTime Function() _now;

  // ---------- 조회 ----------

  Stream<List<PlantEntry>> watchAll() {
    final q =
        db.select(db.plants).join([
          leftOuterJoin(
            db.species,
            db.species.id.equalsExp(db.plants.speciesId),
          ),
          leftOuterJoin(db.spaces, db.spaces.id.equalsExp(db.plants.spaceId)),
        ])..orderBy([
          OrderingTerm.asc(db.plants.nextCheckAt),
          OrderingTerm.asc(db.plants.id),
        ]);
    return q.watch().map(
      (rows) => rows
          .map(
            (r) => PlantEntry(
              plant: r.readTable(db.plants),
              species: r.readTableOrNull(db.species),
              space: r.readTableOrNull(db.spaces),
            ),
          )
          .toList(),
    );
  }

  Stream<PlantEntry?> watchById(int id) {
    final q = db.select(db.plants).join([
      leftOuterJoin(db.species, db.species.id.equalsExp(db.plants.speciesId)),
      leftOuterJoin(db.spaces, db.spaces.id.equalsExp(db.plants.spaceId)),
    ])..where(db.plants.id.equals(id));
    return q.watchSingleOrNull().map(
      (r) => r == null
          ? null
          : PlantEntry(
              plant: r.readTable(db.plants),
              species: r.readTableOrNull(db.species),
              space: r.readTableOrNull(db.spaces),
            ),
    );
  }

  Future<PlantEntry?> getById(int id) async {
    final q = db.select(db.plants).join([
      leftOuterJoin(db.species, db.species.id.equalsExp(db.plants.speciesId)),
      leftOuterJoin(db.spaces, db.spaces.id.equalsExp(db.plants.spaceId)),
    ])..where(db.plants.id.equals(id));
    final r = await q.getSingleOrNull();
    if (r == null) return null;
    return PlantEntry(
      plant: r.readTable(db.plants),
      species: r.readTableOrNull(db.species),
      space: r.readTableOrNull(db.spaces),
    );
  }

  Future<List<PlantEntry>> getAll() async {
    final q =
        db.select(db.plants).join([
          leftOuterJoin(
            db.species,
            db.species.id.equalsExp(db.plants.speciesId),
          ),
          leftOuterJoin(db.spaces, db.spaces.id.equalsExp(db.plants.spaceId)),
        ])..orderBy([
          OrderingTerm.asc(db.plants.nextCheckAt),
          OrderingTerm.asc(db.plants.id),
        ]);
    final rows = await q.get();
    return rows
        .map(
          (r) => PlantEntry(
            plant: r.readTable(db.plants),
            species: r.readTableOrNull(db.species),
            space: r.readTableOrNull(db.spaces),
          ),
        )
        .toList();
  }

  /// 해당 날짜에 앱에서 "물 줬어요"를 눌렀는지 (care_events water 기준).
  /// 등록 시 입력한 last_watered_at 은 기록이 아니므로 여기서 세지 않는다.
  static bool wateredOn(Iterable<CareEvent> events, DateTime day) => events.any(
    (e) =>
        e.type == CareType.water &&
        e.at.year == day.year &&
        e.at.month == day.month &&
        e.at.day == day.day,
  );

  /// DB 조회 버전
  Future<bool> hasWaterEventOn(int plantId, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    final rows =
        await (db.select(db.careEvents)
              ..where(
                (t) =>
                    t.plantId.equals(plantId) &
                    t.type.equalsValue(CareType.water) &
                    t.at.isBiggerOrEqualValue(start) &
                    t.at.isSmallerThanValue(end),
              )
              ..limit(1))
            .get();
    return rows.isNotEmpty;
  }

  /// 주기 변경 시 다음 확인일은 "리셋"이 아니라 차이만큼 "이동"한다.
  /// (촉촉 재확인일 등 이미 앞당겨진 날짜를 보존)
  static DateTime shiftedNextCheck(Plant p, int newDays) => DateTime(
    p.nextCheckAt.year,
    p.nextCheckAt.month,
    p.nextCheckAt.day + (newDays - p.waterIntervalDays),
  );

  Stream<List<CareEvent>> watchCareEvents(int plantId, {int limit = 50}) =>
      (db.select(db.careEvents)
            ..where((t) => t.plantId.equals(plantId))
            ..orderBy([
              (t) => OrderingTerm.desc(t.at),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(limit))
          .watch();

  // ---------- 계산 ----------

  WateringResult computeFor({
    required SpeciesRow? species,
    required Space? space,
    required PotSize potSize,
    required bool hasDrainage,
    double feedbackCoef = 1.0,
    bool manualOverride = false,
    int? manualDays,
    DateTime? at,
  }) {
    final now = at ?? _now();
    return computeWatering(
      WateringInput(
        baseWaterDays: species?.baseWaterDays,
        month: now.month,
        windowDir: space?.windowDir,
        windowDist: space?.windowDist,
        potSize: potSize,
        hasDrainage: hasDrainage,
        feedbackCoef: feedbackCoef,
        manualOverride: manualOverride,
        manualDays: manualDays,
      ),
    );
  }

  WateringResult computeForEntry(PlantEntry e, {DateTime? at}) => computeFor(
    species: e.species,
    space: e.space,
    potSize: e.plant.potSize,
    hasDrainage: e.plant.hasDrainage,
    feedbackCoef: e.plant.feedbackCoef,
    manualOverride: e.plant.manualOverride,
    manualDays: e.plant.manualOverride ? e.plant.waterIntervalDays : null,
    at: at,
  );

  // ---------- 등록 / 수정 ----------

  /// ADD-04 완료 → 식물 생성. id 반환.
  Future<int> create({
    required String nickname,
    int? speciesId,
    int? spaceId,
    required PotSize potSize,
    required bool hasDrainage,
    required DateTime lastWateredAt,
    String? photoPath,
    String? memo,
    int? manualDays,
  }) async {
    final species = speciesId == null
        ? null
        : await (db.select(
            db.species,
          )..where((t) => t.id.equals(speciesId))).getSingleOrNull();
    final space = spaceId == null
        ? null
        : await (db.select(
            db.spaces,
          )..where((t) => t.id.equals(spaceId))).getSingleOrNull();
    final now = _now();
    final result = computeFor(
      species: species,
      space: space,
      potSize: potSize,
      hasDrainage: hasDrainage,
      manualOverride: manualDays != null,
      manualDays: manualDays,
      at: now,
    );

    return db.transaction(() async {
      final id = await db
          .into(db.plants)
          .insert(
            PlantsCompanion.insert(
              nickname: nickname.trim(),
              speciesId: Value(speciesId),
              spaceId: Value(spaceId),
              potSize: potSize,
              hasDrainage: Value(hasDrainage),
              photoPath: Value(photoPath),
              waterIntervalDays: result.days,
              manualOverride: Value(manualDays != null),
              lastWateredAt: lastWateredAt,
              nextCheckAt: nextCheckAt(lastWateredAt, result.days),
              fertIntervalDays: Value(species?.fertDays),
              createdAt: now,
              memo: Value(
                memo == null || memo.trim().isEmpty ? null : memo.trim(),
              ),
            ),
          );
      // 등록 시 입력한 "마지막 물 준 날"은 다음 D-day 계산에만 쓰고 물 준 기록으로 남기지 않는다
      return id;
    });
  }

  Future<void> updateBasic({
    required int id,
    String? nickname,
    Value<int?> spaceId = const Value.absent(),
    Value<int?> speciesId = const Value.absent(),
    PotSize? potSize,
    bool? hasDrainage,
    Value<String?> photoPath = const Value.absent(),
  }) async {
    await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
      PlantsCompanion(
        nickname: nickname == null
            ? const Value.absent()
            : Value(nickname.trim()),
        spaceId: spaceId,
        speciesId: speciesId,
        potSize: potSize == null ? const Value.absent() : Value(potSize),
        hasDrainage: hasDrainage == null
            ? const Value.absent()
            : Value(hasDrainage),
        photoPath: photoPath,
        fertIntervalDays: speciesId.present
            ? Value(
                speciesId.value == null
                    ? null
                    : (await (db.select(db.species)
                                ..where((t) => t.id.equals(speciesId.value!)))
                              .getSingleOrNull())
                          ?.fertDays,
              )
            : const Value.absent(),
      ),
    );
    await recalc(id);
  }

  Future<void> setMemo(int id, String? memo) => (db.update(
    db.plants,
  )..where((t) => t.id.equals(id))).write(PlantsCompanion(memo: Value(memo)));

  /// PLT-02: 수동 주기 설정. days == null 이면 자동 계산으로 복귀.
  Future<void> setManualInterval(int id, int? days) async {
    final e = await getById(id);
    if (e == null) return;
    final manual = days != null;
    final result = computeFor(
      species: e.species,
      space: e.space,
      potSize: e.plant.potSize,
      hasDrainage: e.plant.hasDrainage,
      feedbackCoef: e.plant.feedbackCoef,
      manualOverride: manual,
      manualDays: days,
    );
    await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
      PlantsCompanion(
        manualOverride: Value(manual),
        waterIntervalDays: Value(result.days),
        nextCheckAt: Value(shiftedNextCheck(e.plant, result.days)),
      ),
    );
  }

  /// 계절·공간 변경 등으로 주기 재계산 (수동 식물은 유지)
  Future<void> recalc(int id) async {
    final e = await getById(id);
    if (e == null || e.plant.manualOverride) return;
    final result = computeForEntry(e);
    if (result.days == e.plant.waterIntervalDays) return;
    await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
      PlantsCompanion(
        waterIntervalDays: Value(result.days),
        nextCheckAt: Value(shiftedNextCheck(e.plant, result.days)),
      ),
    );
  }

  /// 앱 포그라운드 진입 시 전체 재계산 (5-3)
  Future<void> recalcAll() async {
    final all = await getAll();
    for (final e in all) {
      if (e.plant.manualOverride) continue;
      final result = computeForEntry(e);
      if (result.days == e.plant.waterIntervalDays) continue;
      await (db.update(db.plants)..where((t) => t.id.equals(e.plant.id))).write(
        PlantsCompanion(
          waterIntervalDays: Value(result.days),
          nextCheckAt: Value(shiftedNextCheck(e.plant, result.days)),
        ),
      );
    }
  }

  // ---------- 흙 확인 (HOME-02) ----------

  /// 흙 확인 결과 반영. dry = "말랐어요, 물 줬어요" / wet = "아직 촉촉해요"
  Future<void> recordSoilCheck(
    int id,
    SoilCheckResult result, {
    DateTime? at,
  }) async {
    final e = await getById(id);
    if (e == null) return;
    final now = at ?? _now();
    // 오늘 이미 물을 줬으면 다시 눌러도 기록·날짜를 바꾸지 않는다
    if (result == SoilCheckResult.dry && await hasWaterEventOn(id, now)) {
      return;
    }
    // 수동 주기 식물은 흙 확인으로 계수를 보정하지 않는다 (PLT-02 문구와 일치)
    final fb = e.plant.manualOverride
        ? (feedbackCoef: e.plant.feedbackCoef, dryStreak: 0)
        : applyFeedback(
            feedbackCoef: e.plant.feedbackCoef,
            dryStreak: e.plant.dryStreak,
            result: result,
          );
    final interval = computeFor(
      species: e.species,
      space: e.space,
      potSize: e.plant.potSize,
      hasDrainage: e.plant.hasDrainage,
      feedbackCoef: fb.feedbackCoef,
      manualOverride: e.plant.manualOverride,
      manualDays: e.plant.manualOverride ? e.plant.waterIntervalDays : null,
      at: now,
    ).days;

    await db.transaction(() async {
      switch (result) {
        case SoilCheckResult.dry:
          await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
            PlantsCompanion(
              feedbackCoef: Value(fb.feedbackCoef),
              dryStreak: Value(fb.dryStreak),
              waterIntervalDays: Value(interval),
              lastWateredAt: Value(now),
              nextCheckAt: Value(nextCheckAt(now, interval)),
            ),
          );
          await db.batch((b) {
            b.insertAll(db.careEvents, [
              CareEventsCompanion.insert(
                plantId: id,
                type: CareType.checkDry,
                at: now,
              ),
              CareEventsCompanion.insert(
                plantId: id,
                type: CareType.water,
                at: now,
              ),
            ]);
          });
        case SoilCheckResult.wet:
          await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
            PlantsCompanion(
              feedbackCoef: Value(fb.feedbackCoef),
              dryStreak: Value(fb.dryStreak),
              waterIntervalDays: Value(interval),
              nextCheckAt: Value(
                nextCheckAt(now, recheckDaysAfterWet(interval)),
              ),
            ),
          );
          await db
              .into(db.careEvents)
              .insert(
                CareEventsCompanion.insert(
                  plantId: id,
                  type: CareType.checkWet,
                  at: now,
                ),
              );
      }
    });
  }

  /// 알림 "내일 할게요": 주기·계수는 그대로 두고 다음 날짜만 내일로
  Future<void> snoozeToTomorrow(int id, {DateTime? at}) async {
    final now = at ?? _now();
    await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
      PlantsCompanion(
        nextCheckAt: Value(DateTime(now.year, now.month, now.day + 1)),
      ),
    );
  }

  /// 다중 선택 일괄 완료
  Future<void> recordSoilCheckBatch(
    Iterable<int> ids,
    SoilCheckResult result,
  ) async {
    for (final id in ids) {
      await recordSoilCheck(id, result);
    }
  }

  /// 기타 관리 이벤트 (비료/분갈이/잎닦기)
  Future<void> addCareEvent(
    int id,
    CareType type, {
    String? note,
    DateTime? at,
  }) async {
    final now = at ?? _now();
    await db
        .into(db.careEvents)
        .insert(
          CareEventsCompanion.insert(
            plantId: id,
            type: type,
            at: now,
            note: Value(note),
          ),
        );
    if (type == CareType.fert) {
      await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
        PlantsCompanion(lastFertAt: Value(now)),
      );
    } else if (type == CareType.repot) {
      await (db.update(db.plants)..where((t) => t.id.equals(id))).write(
        PlantsCompanion(repotAt: Value(now)),
      );
    }
  }

  Future<void> delete(int id) =>
      (db.delete(db.plants)..where((t) => t.id.equals(id))).go();
}

final plantRepositoryProvider = Provider<PlantRepository>(
  (ref) => PlantRepository(ref.watch(databaseProvider)),
);

final plantsProvider = StreamProvider<List<PlantEntry>>(
  (ref) => ref.watch(plantRepositoryProvider).watchAll(),
);

final plantByIdProvider = StreamProvider.autoDispose.family<PlantEntry?, int>(
  (ref, id) => ref.watch(plantRepositoryProvider).watchById(id),
);

final careEventsProvider = StreamProvider.autoDispose
    .family<List<CareEvent>, int>(
      (ref, id) => ref.watch(plantRepositoryProvider).watchCareEvents(id),
    );
