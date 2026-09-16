import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/domain/stats_service.dart';

CareEvent _water(DateTime at) =>
    CareEvent(id: 0, plantId: 1, type: CareType.water, at: at, note: null);
CareEvent _check(DateTime at) =>
    CareEvent(id: 0, plantId: 1, type: CareType.checkWet, at: at, note: null);
DiaryEntry _diary(DateTime at, {List<DiaryTag> tags = const []}) => DiaryEntry(
  id: 0,
  plantId: 1,
  photoPath: null,
  memo: null,
  tags: tags,
  at: at,
);

void main() {
  final now = DateTime(2026, 9, 16, 15);

  test('이번 달 물 준 횟수: water만, 같은 달만', () {
    final events = [
      _water(DateTime(2026, 9, 1)),
      _water(DateTime(2026, 9, 10)),
      _water(DateTime(2026, 8, 31)),
      _check(DateTime(2026, 9, 12)),
    ];
    expect(countWateringsInMonth(events, now), 2);
  });

  test('일기 수: 전체 개수', () {
    final entries = [
      _diary(DateTime(2026, 9, 1), tags: [DiaryTag.newLeaf]),
      _diary(DateTime(2026, 9, 2)),
      _diary(DateTime(2026, 9, 3)),
    ];
    expect(countDiaries(entries), 3);
  });

  group('연속 관리일', () {
    test('기록 없음 → 0', () {
      expect(streakDays([], [], now), 0);
    });
    test('오늘부터 3일 연속 (물·일기 혼합)', () {
      final ev = [
        _water(DateTime(2026, 9, 16, 9)),
        _water(DateTime(2026, 9, 14)),
      ];
      final di = [_diary(DateTime(2026, 9, 15, 20))];
      expect(streakDays(ev, di, now), 3);
    });
    test('오늘 아직 안 했으면 어제까지 연속 유지', () {
      final ev = [_water(DateTime(2026, 9, 15)), _water(DateTime(2026, 9, 14))];
      expect(streakDays(ev, [], now), 2);
    });
    test('어제도 오늘도 없으면 0 (그 전 기록 무시)', () {
      final ev = [_water(DateTime(2026, 9, 13)), _water(DateTime(2026, 9, 12))];
      expect(streakDays(ev, [], now), 0);
    });
    test('중간에 빠진 날이 있으면 거기서 끊김', () {
      final ev = [
        _water(DateTime(2026, 9, 16)),
        _water(DateTime(2026, 9, 15)),
        _water(DateTime(2026, 9, 13)),
      ];
      expect(streakDays(ev, [], now), 2);
    });
    test('월 경계를 넘어도 이어짐', () {
      final ev = [
        _water(DateTime(2026, 9, 1)),
        _water(DateTime(2026, 8, 31)),
        _water(DateTime(2026, 8, 30)),
      ];
      expect(streakDays(ev, [], DateTime(2026, 9, 1, 10)), 3);
    });
  });

  test('computeStats 종합', () {
    final s = computeStats(
      events: [_water(DateTime(2026, 9, 16))],
      entries: [
        _diary(DateTime(2026, 9, 16), tags: [DiaryTag.newLeaf]),
      ],
      now: now,
    );
    expect(s.wateringsThisMonth, 1);
    expect(s.diaryCount, 1);
    expect(s.streakDays, 1);
  });
}
