import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/domain/notification_service.dart';

Setting _s({int hour = 9, int minute = 0, List<int> skip = const []}) =>
    Setting(
      id: 1,
      notifyHour: hour,
      notifyMinute: minute,
      skipWeekdays: skip,
      backupUserId: null,
      onboardingDone: true,
      plantnetDay: 0,
      plantnetCount: 0,
      homeGrid: true,
      notifyDayBefore: false,
    );

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
    test('문구', () {
      expect(
        NotificationService.bodyFor(2, dayBefore: false),
        '오늘 물 줄 식물이 2개 있어요',
      );
      expect(
        NotificationService.bodyFor(2, dayBefore: true),
        '내일 물 줄 식물이 2개 있어요',
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
}
