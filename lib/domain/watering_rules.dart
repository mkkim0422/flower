// 물주기 주기 계산 (HANDOFF 5-1). 계수는 모두 이 파일의 상수. 단위 테스트 필수.
import 'dart:math' as math;

import '../core/enums.dart';

/// 품종 미지정(직접 입력) 기본 물주기 일수
const int kDefaultBaseWaterDays = 7;

/// feedback_coef 범위
const double kFeedbackMin = 0.5;
const double kFeedbackMax = 2.0;

/// "아직 촉촉해요" 입력 시 곱하는 계수
const double kFeedbackWetMultiplier = 1.15;

/// "말랐어요" 2회 연속 시 곱하는 계수
const double kFeedbackDryMultiplier = 0.9;

/// "말랐어요"가 연속 몇 번이면 보정할지
const int kDryStreakThreshold = 2;

/// 흙 확인 결과 (HOME-02)
enum SoilCheckResult { dry, wet }

/// 계절 계수: 3~5월 1.0 / 6~8월 0.8 / 9~10월 1.0 / 11~2월 1.4
double seasonCoef(int month) {
  assert(month >= 1 && month <= 12);
  if (month >= 6 && month <= 8) return 0.8;
  if (month >= 11 || month <= 2) return 1.4;
  return 1.0;
}

/// 빛 계수: 남향·창가 0.8 / 동·서 창가 0.9 / 북향 또는 멀리 1.2 / 창 없음 1.3
/// 공간 미지정(null)은 1.0. 1m 이내(oneMeter)는 명세에 없어 1.0으로 둔다(PROGRESS 기록).
double lightCoef(WindowDir? dir, WindowDist? dist) {
  if (dir == null || dist == null) return 1.0;
  if (dir == WindowDir.none) return 1.3;
  if (dir == WindowDir.n || dist == WindowDist.far) return 1.2;
  if (dist == WindowDist.near) {
    return dir == WindowDir.s ? 0.8 : 0.9;
  }
  return 1.0; // oneMeter, 동·서·남
}

/// 화분 계수: S 0.85 / M 1.0 / L 1.2, 배수구 없음 ×1.2
double potCoef(PotSize size, {required bool hasDrainage}) {
  final base = switch (size) {
    PotSize.s => 0.85,
    PotSize.m => 1.0,
    PotSize.l => 1.2,
  };
  return hasDrainage ? base : base * 1.2;
}

double clampFeedback(double v) => v.clamp(kFeedbackMin, kFeedbackMax);

/// 흙 확인 결과를 feedback_coef / dry_streak 에 반영한다.
({double feedbackCoef, int dryStreak}) applyFeedback({
  required double feedbackCoef,
  required int dryStreak,
  required SoilCheckResult result,
}) {
  switch (result) {
    case SoilCheckResult.wet:
      return (
        feedbackCoef: clampFeedback(feedbackCoef * kFeedbackWetMultiplier),
        dryStreak: 0,
      );
    case SoilCheckResult.dry:
      final streak = dryStreak + 1;
      if (streak >= kDryStreakThreshold) {
        return (
          feedbackCoef: clampFeedback(feedbackCoef * kFeedbackDryMultiplier),
          dryStreak: 0,
        );
      }
      return (feedbackCoef: feedbackCoef, dryStreak: streak);
  }
}

/// 계산 입력
class WateringInput {
  const WateringInput({
    required this.baseWaterDays,
    required this.month,
    required this.windowDir,
    required this.windowDist,
    required this.potSize,
    required this.hasDrainage,
    this.feedbackCoef = 1.0,
    this.manualOverride = false,
    this.manualDays,
  });

  /// 품종 기본 물주기. null이면 [kDefaultBaseWaterDays].
  final int? baseWaterDays;
  final int month;
  final WindowDir? windowDir;
  final WindowDist? windowDist;
  final PotSize potSize;
  final bool hasDrainage;
  final double feedbackCoef;
  final bool manualOverride;
  final int? manualDays;
}

/// 계산 결과 + 근거(PLT-02 표시용)
class WateringResult {
  const WateringResult({
    required this.days,
    required this.base,
    required this.season,
    required this.light,
    required this.pot,
    required this.feedback,
    required this.isManual,
  });

  final int days;
  final int base;
  final double season;
  final double light;
  final double pot;
  final double feedback;
  final bool isManual;

  double get raw => base * season * light * pot * feedback;
}

/// interval = base × season × light × pot × feedback, 반올림, 최소 1일.
/// manual_override 이면 계산 무시하고 manualDays 사용.
WateringResult computeWatering(WateringInput i) {
  final base = i.baseWaterDays ?? kDefaultBaseWaterDays;
  final season = seasonCoef(i.month);
  final light = lightCoef(i.windowDir, i.windowDist);
  final pot = potCoef(i.potSize, hasDrainage: i.hasDrainage);
  final feedback = clampFeedback(i.feedbackCoef);

  if (i.manualOverride && i.manualDays != null) {
    return WateringResult(
      days: math.max(1, i.manualDays!),
      base: base,
      season: season,
      light: light,
      pot: pot,
      feedback: feedback,
      isManual: true,
    );
  }

  final raw = base * season * light * pot * feedback;
  return WateringResult(
    days: math.max(1, raw.round()),
    base: base,
    season: season,
    light: light,
    pot: pot,
    feedback: feedback,
    isManual: false,
  );
}

/// next_check_at = last_watered_at + round(interval). 시각은 자정으로 정규화.
DateTime nextCheckAt(DateTime lastWateredAt, int intervalDays) {
  // Duration 덧셈 대신 날짜 성분 산술 (DST 안전)
  return DateTime(
    lastWateredAt.year,
    lastWateredAt.month,
    lastWateredAt.day + math.max(1, intervalDays),
  );
}

/// "아직 촉촉해요" 이후 재확인일: interval의 25%, 1~3일 (명세 미기재 → PROGRESS 기록)
int recheckDaysAfterWet(int intervalDays) =>
    (intervalDays * 0.25).round().clamp(1, 3);

/// 오늘 확인 대상인지 (next_check_at ≤ today)
bool isDueToday(DateTime nextCheckAt, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(nextCheckAt.year, nextCheckAt.month, nextCheckAt.day);
  return !due.isAfter(today);
}

/// D-day (양수: 남은 일, 0: 오늘, 음수: 지남)
int daysUntil(DateTime nextCheckAt, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(nextCheckAt.year, nextCheckAt.month, nextCheckAt.day);
  return due.difference(today).inDays;
}
