import 'package:drift/native.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/l10n/app_localizations.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/repositories/plant_repository.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/domain/notification_service.dart';

Setting _s({
  int hour = 9,
  int minute = 0,
  List<int> skip = const [],
  bool dayBefore = false,
  DateTime? pausedUntil,
}) => Setting(
  id: 1,
  notifyHour: hour,
  notifyMinute: minute,
  skipWeekdays: skip,
  backupUserId: null,
  onboardingDone: true,
  plantnetDay: 0,
  plantnetCount: 0,
  homeGrid: true,
  notifyDayBefore: dayBefore,
  themeVariant: 0,
  notifyPausedUntil: pausedUntil,
);

final ko = lookupAppLocalizations(const Locale('ko'));
final en = lookupAppLocalizations(const Locale('en'));

void main() {
  group('nextFireTime', () {
    test('알림 시각 전이면 오늘', () {
      final r = NotificationService.nextFireTime(
        _s(),
        DateTime(2026, 9, 16, 8, 59),
      );
      expect(r, DateTime(2026, 9, 16, 9));
    });
    test('알림 시각 지났으면 내일', () {
      final r = NotificationService.nextFireTime(
        _s(),
        DateTime(2026, 9, 16, 9),
      );
      expect(r, DateTime(2026, 9, 17, 9));
    });
    test('제외 요일 건너뜀 (2026-09-16 수요일, 목·금 제외 → 토)', () {
      final r = NotificationService.nextFireTime(
        _s(skip: [DateTime.thursday, DateTime.friday]),
        DateTime(2026, 9, 16, 10),
      );
      expect(r, DateTime(2026, 9, 19, 9));
      expect(r!.weekday, DateTime.saturday);
    });
    test('모든 요일 제외면 null', () {
      final r = NotificationService.nextFireTime(
        _s(skip: [1, 2, 3, 4, 5, 6, 7]),
        DateTime(2026, 9, 16),
      );
      expect(r, isNull);
    });
    test('월말 넘어감', () {
      final r = NotificationService.nextFireTime(
        _s(),
        DateTime(2026, 9, 30, 12),
      );
      expect(r, DateTime(2026, 10, 1, 9));
    });
  });

  group('하루 전 알림', () {
    test('targetDay: 당일이면 그날, 하루 전이면 다음 날', () {
      final at = DateTime(2026, 9, 30, 9);
      expect(NotificationService.targetDay(at, dayBefore: false), at);
      expect(
        NotificationService.targetDay(at, dayBefore: true),
        DateTime(2026, 10, 1, 9),
      );
    });
  });

  group('fireTimes', () {
    test('7일치, 주말 제외', () {
      final times = NotificationService.fireTimes(
        _s(skip: [DateTime.saturday, DateTime.sunday]),
        DateTime(2026, 9, 16, 12), // 수
      );
      expect(times.length, 7);
      expect(times.every((t) => t.weekday <= 5), isTrue);
      expect(times.first, DateTime(2026, 9, 17, 9));
      expect(times.last, DateTime(2026, 9, 25, 9));
    });
    test('모든 요일 제외면 빈 목록', () {
      expect(
        NotificationService.fireTimes(
          _s(skip: [1, 2, 3, 4, 5, 6, 7]),
          DateTime(2026, 9, 16),
        ),
        isEmpty,
      );
    });
  });

  group('식물 이름 알림', () {
    test('문구: 1개 / 3개 / 4개 이상 / 하루 전', () {
      expect(
        NotificationService.bodyForNames(['몬스테라'], dayBefore: false, l: ko),
        '몬스테라 물 줄 날이에요',
      );
      expect(
        NotificationService.bodyForNames(
          ['A', 'B', 'C'],
          dayBefore: false,
          l: ko,
        ),
        'A·B·C 물 줄 날이에요',
      );
      expect(
        NotificationService.bodyForNames(
          ['A', 'B', 'C', 'D'],
          dayBefore: false,
          l: ko,
        ),
        'A·B 외 2개 물 줄 날이에요',
      );
      expect(
        NotificationService.bodyForNames(['금전수'], dayBefore: true, l: ko),
        '내일은 금전수 물 줄 날이에요',
      );
    });

    test('영어 문구: 단수·복수·하루 전', () {
      expect(
        NotificationService.bodyForNames(['Monstera'], dayBefore: false, l: en),
        'Monstera needs water today',
      );
      expect(
        NotificationService.bodyForNames(['A', 'B'], dayBefore: false, l: en),
        'A, B need water today',
      );
      expect(
        NotificationService.bodyForNames(
          ['A', 'B', 'C', 'D'],
          dayBefore: true,
          l: en,
        ),
        'A, B and 2 more need water tomorrow',
      );
    });

    test('payload 왕복·잘못된 값', () {
      expect(plantIdsFromPayload('{"ids":[3,5]}'), [3, 5]);
      expect(plantIdsFromPayload(null), isEmpty);
      expect(plantIdsFromPayload('broken'), isEmpty);
    });
  });

  group('알림 계획과 버튼 처리 (DB)', () {
    late AppDatabase db;
    late PlantRepository repo;
    final now = DateTime(2026, 9, 17, 8); // 목요일 08:00, 알림 09:00

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = PlantRepository(db, clock: () => now);
    });
    tearDown(() => db.close());

    Future<int> add(String name, DateTime lastWatered) => repo.create(
      nickname: name,
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: lastWatered,
      manualDays: 7,
    );

    test('당일 알림: 그날 물 줄 식물 이름과 id 가 들어간다', () async {
      final a = await add('몬스테라', DateTime(2026, 9, 10)); // 9/17 due
      await add('금전수', DateTime(2026, 9, 15)); // 9/22 due
      final plans = NotificationService.plan(
        settings: _s(),
        plants: await repo.getAll(),
        now: now,
        l: ko,
      );
      final today = plans.first;
      expect(today.fireAt, DateTime(2026, 9, 17, 9));
      expect(today.body, '몬스테라 물 줄 날이에요');
      expect(today.plantIds, [a]);
      expect(today.dayBefore, isFalse);
      // 9/22 에는 금전수 (+ 밀린 몬스테라)
      final d22 = plans.firstWhere((p) => p.fireAt.day == 22);
      expect(d22.body, contains('금전수'));
    });

    test('하루 전 알림: 내일 대상 이름으로 "내일은 …"', () async {
      await add('행운목', DateTime(2026, 9, 11)); // 9/18 due
      final plans = NotificationService.plan(
        settings: _s(dayBefore: true),
        plants: await repo.getAll(),
        now: now,
        l: ko,
      );
      expect(plans.first.fireAt, DateTime(2026, 9, 17, 9));
      expect(plans.first.body, '내일은 행운목 물 줄 날이에요');
      expect(plans.first.dayBefore, isTrue);
    });

    test('"물 줬어요" 버튼: 기록되고 다음 날짜가 밀린다, 두 번 눌러도 1건', () async {
      final a = await add('몬스테라', DateTime(2026, 9, 10));
      await applyNotificationAction(
        repo: repo,
        actionId: kActionWatered,
        plantIds: [a],
        now: now,
      );
      await applyNotificationAction(
        repo: repo,
        actionId: kActionWatered,
        plantIds: [a],
        now: now,
      );
      final e = (await repo.getById(a))!;
      expect(e.isDue(now), isFalse);
      expect(await repo.hasWaterEventOn(a, now), isTrue);
      final waters = (await repo.watchCareEvents(a).first).where(
        (x) => x.type == CareType.water,
      );
      expect(waters.length, 1);
    });

    test('"내일 할게요" 버튼: 오늘 대상만 내일로, 주기·기록은 그대로', () async {
      final a = await add('몬스테라', DateTime(2026, 9, 10)); // due
      final b = await add('금전수', DateTime(2026, 9, 15)); // not due
      final before = (await repo.getById(a))!;
      final n = await applyNotificationAction(
        repo: repo,
        actionId: kActionSnooze,
        plantIds: [a, b],
        now: now,
      );
      expect(n, 1);
      final after = (await repo.getById(a))!;
      expect(after.plant.nextCheckAt, DateTime(2026, 9, 18));
      expect(after.plant.waterIntervalDays, before.plant.waterIntervalDays);
      expect(after.plant.feedbackCoef, before.plant.feedbackCoef);
      expect(await repo.watchCareEvents(a).first, isEmpty);
      expect((await repo.getById(b))!.plant.nextCheckAt, DateTime(2026, 9, 22));
    });

    test('멈춤 기간의 알림은 계획에서 빠진다', () async {
      await add('몬스테라', DateTime(2026, 9, 10)); // 9/17부터 계속 대상
      final plans = NotificationService.plan(
        settings: _s(pausedUntil: DateTime(2026, 9, 19)),
        plants: await repo.getAll(),
        now: now,
        l: ko,
      );
      expect(plans, isNotEmpty);
      expect(plans.first.fireAt, DateTime(2026, 9, 20, 9));
      expect(
        plans.every((p) => p.fireAt.isAfter(DateTime(2026, 9, 20))),
        isTrue,
      );
    });

    test('삭제된 식물 id 는 무시', () async {
      final n = await applyNotificationAction(
        repo: repo,
        actionId: kActionWatered,
        plantIds: [999],
        now: now,
      );
      expect(n, 0);
    });
  });

  group('알림 잠시 멈추기', () {
    test('멈춤 마지막 날까지는 예약하지 않고 다음 날부터 다시 예약', () {
      final now = DateTime(2026, 9, 17, 8);
      final times = NotificationService.fireTimes(_s(), now);
      expect(times.first, DateTime(2026, 9, 17, 9));
      // 계획은 식물 없이도 시각 필터만 검증: 멈춤 설정 시 9/19 이전 시각 제외
      final s = _s(pausedUntil: DateTime(2026, 9, 19));
      expect(isNotifyPaused(s, DateTime(2026, 9, 19, 23)), isTrue);
      expect(isNotifyPaused(s, DateTime(2026, 9, 20)), isFalse);
      expect(isNotifyPaused(_s(), now), isFalse);
    });
  });
}
