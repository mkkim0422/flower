// MY-01 통계 (F11): 이번 달 물 준 횟수 / 새잎 태그 수 / 연속 관리일
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums.dart';
import '../data/db/app_database.dart';
import '../data/db/database_provider.dart';
import '../data/repositories/diary_repository.dart';

class Stats {
  const Stats({
    required this.wateringsThisMonth,
    required this.diaryCount,
    required this.streakDays,
  });

  final int wateringsThisMonth;
  final int diaryCount;
  final int streakDays;
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// 이번 달 물 준 횟수 (care_events type=water, 같은 달)
int countWateringsInMonth(Iterable<CareEvent> events, DateTime now) => events
    .where(
      (e) =>
          e.type == CareType.water &&
          e.at.year == now.year &&
          e.at.month == now.month,
    )
    .length;

/// 일기 수 (전체). 상태 태그는 UI에서 빠져 "새잎" 대신 일기 수를 보여준다 (2026-09-16)
int countDiaries(Iterable<DiaryEntry> entries) => entries.length;

/// 연속 관리일: 오늘(또는 어제)부터 거슬러 하루도 빠짐없이 물 주기·일기 중 하나라도 있는 날 수.
/// 오늘 아직 안 했으면 어제까지의 연속을 유지한다.
int streakDays(
  Iterable<CareEvent> events,
  Iterable<DiaryEntry> entries,
  DateTime now,
) {
  final days = <DateTime>{
    for (final e in events)
      if (e.type == CareType.water) _day(e.at),
    for (final d in entries) _day(d.at),
  };
  if (days.isEmpty) return 0;
  var cursor = _day(now);
  if (!days.contains(cursor)) {
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    if (!days.contains(cursor)) return 0;
  }
  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return streak;
}

Stats computeStats({
  required Iterable<CareEvent> events,
  required Iterable<DiaryEntry> entries,
  required DateTime now,
}) => Stats(
  wateringsThisMonth: countWateringsInMonth(events, now),
  diaryCount: countDiaries(entries),
  streakDays: streakDays(events, entries, now),
);

/// DB 스트림 기반 통계 (care_events·diary 변경 시 갱신)
final statsProvider = StreamProvider<Stats>((ref) {
  final db = ref.watch(databaseProvider);
  final events = db.select(db.careEvents).watch();
  final diary = ref.watch(diaryRepositoryProvider);
  return events.asyncMap(
    (ev) async => computeStats(
      events: ev,
      entries: await diary.getAll(),
      now: DateTime.now(),
    ),
  );
});
