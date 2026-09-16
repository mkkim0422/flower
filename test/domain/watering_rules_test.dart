import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/domain/watering_rules.dart';

void main() {
  group('seasonCoef', () {
    test('3~5월 1.0', () {
      expect(seasonCoef(3), 1.0);
      expect(seasonCoef(4), 1.0);
      expect(seasonCoef(5), 1.0);
    });
    test('6~8월 0.8', () {
      expect(seasonCoef(6), 0.8);
      expect(seasonCoef(7), 0.8);
      expect(seasonCoef(8), 0.8);
    });
    test('9~10월 1.0', () {
      expect(seasonCoef(9), 1.0);
      expect(seasonCoef(10), 1.0);
    });
    test('11~2월 1.4', () {
      expect(seasonCoef(11), 1.4);
      expect(seasonCoef(12), 1.4);
      expect(seasonCoef(1), 1.4);
      expect(seasonCoef(2), 1.4);
    });
  });

  group('lightCoef', () {
    test('남향 창가 0.8', () => expect(lightCoef(WindowDir.s, WindowDist.near), 0.8));
    test('동향 창가 0.9', () => expect(lightCoef(WindowDir.e, WindowDist.near), 0.9));
    test('서향 창가 0.9', () => expect(lightCoef(WindowDir.w, WindowDist.near), 0.9));
    test('북향은 거리 무관 1.2', () {
      expect(lightCoef(WindowDir.n, WindowDist.near), 1.2);
      expect(lightCoef(WindowDir.n, WindowDist.oneMeter), 1.2);
      expect(lightCoef(WindowDir.n, WindowDist.far), 1.2);
    });
    test('멀리는 방향 무관 1.2', () {
      expect(lightCoef(WindowDir.s, WindowDist.far), 1.2);
      expect(lightCoef(WindowDir.e, WindowDist.far), 1.2);
    });
    test('창 없음 1.3', () => expect(lightCoef(WindowDir.none, WindowDist.far), 1.3));
    test('남·동·서 1m 이내 1.0', () {
      expect(lightCoef(WindowDir.s, WindowDist.oneMeter), 1.0);
      expect(lightCoef(WindowDir.e, WindowDist.oneMeter), 1.0);
    });
    test('공간 미지정 1.0', () => expect(lightCoef(null, null), 1.0));
  });

  group('potCoef', () {
    test('S 0.85', () => expect(potCoef(PotSize.s, hasDrainage: true), 0.85));
    test('M 1.0', () => expect(potCoef(PotSize.m, hasDrainage: true), 1.0));
    test('L 1.2', () => expect(potCoef(PotSize.l, hasDrainage: true), 1.2));
    test('배수구 없음 ×1.2', () {
      expect(potCoef(PotSize.m, hasDrainage: false), closeTo(1.2, 1e-9));
      expect(potCoef(PotSize.l, hasDrainage: false), closeTo(1.44, 1e-9));
    });
  });

  group('applyFeedback', () {
    test('촉촉 → ×1.15, streak 리셋', () {
      final r = applyFeedback(
        feedbackCoef: 1.0,
        dryStreak: 1,
        result: SoilCheckResult.wet,
      );
      expect(r.feedbackCoef, closeTo(1.15, 1e-9));
      expect(r.dryStreak, 0);
    });
    test('말랐음 1회는 변화 없음, streak 1', () {
      final r = applyFeedback(
        feedbackCoef: 1.0,
        dryStreak: 0,
        result: SoilCheckResult.dry,
      );
      expect(r.feedbackCoef, 1.0);
      expect(r.dryStreak, 1);
    });
    test('말랐음 2회 연속 → ×0.9, streak 리셋', () {
      final r = applyFeedback(
        feedbackCoef: 1.0,
        dryStreak: 1,
        result: SoilCheckResult.dry,
      );
      expect(r.feedbackCoef, closeTo(0.9, 1e-9));
      expect(r.dryStreak, 0);
    });
    test('상한 2.0 클램프', () {
      final r = applyFeedback(
        feedbackCoef: 1.95,
        dryStreak: 0,
        result: SoilCheckResult.wet,
      );
      expect(r.feedbackCoef, 2.0);
    });
    test('하한 0.5 클램프', () {
      final r = applyFeedback(
        feedbackCoef: 0.52,
        dryStreak: 1,
        result: SoilCheckResult.dry,
      );
      expect(r.feedbackCoef, 0.5);
    });
  });

  group('computeWatering', () {
    WateringInput base({
      int? baseDays = 10,
      int month = 4,
      WindowDir? dir = WindowDir.s,
      WindowDist? dist = WindowDist.oneMeter,
      PotSize pot = PotSize.m,
      bool drainage = true,
      double feedback = 1.0,
      bool manual = false,
      int? manualDays,
    }) =>
        WateringInput(
          baseWaterDays: baseDays,
          month: month,
          windowDir: dir,
          windowDist: dist,
          potSize: pot,
          hasDrainage: drainage,
          feedbackCoef: feedback,
          manualOverride: manual,
          manualDays: manualDays,
        );

    test('모든 계수 1.0이면 base 그대로', () {
      expect(computeWatering(base()).days, 10);
    });
    test('품종 미지정이면 base 7', () {
      final r = computeWatering(base(baseDays: null));
      expect(r.base, 7);
      expect(r.days, 7);
    });
    test('여름(0.8) × 남향 창가(0.8) × S(0.85) = 10×0.544 → 5', () {
      final r = computeWatering(
        base(month: 7, dist: WindowDist.near, pot: PotSize.s),
      );
      expect(r.raw, closeTo(5.44, 1e-9));
      expect(r.days, 5);
    });
    test('겨울(1.4) × 창 없음(1.3) × L 배수구 없음(1.44) = 10×2.6208 → 26', () {
      final r = computeWatering(
        base(
          month: 1,
          dir: WindowDir.none,
          dist: WindowDist.far,
          pot: PotSize.l,
          drainage: false,
        ),
      );
      expect(r.days, 26);
    });
    test('feedback 1.15 반영: 10×1.15 → 12 (반올림)', () {
      expect(computeWatering(base(feedback: 1.15)).days, 12);
    });
    test('feedback 범위 밖 입력은 클램프: 3.0 → 2.0', () {
      final r = computeWatering(base(feedback: 3.0));
      expect(r.feedback, 2.0);
      expect(r.days, 20);
    });
    test('최소 1일', () {
      final r = computeWatering(
        base(
          baseDays: 1,
          month: 7,
          dist: WindowDist.near,
          pot: PotSize.s,
          feedback: 0.5,
        ),
      );
      expect(r.days, 1);
    });
    test('manual_override 이면 계산 무시', () {
      final r = computeWatering(
        base(month: 1, dir: WindowDir.none, manual: true, manualDays: 3),
      );
      expect(r.isManual, isTrue);
      expect(r.days, 3);
    });
    test('manual_override 인데 manualDays 없으면 계산값 사용', () {
      final r = computeWatering(base(manual: true, manualDays: null));
      expect(r.isManual, isFalse);
      expect(r.days, 10);
    });
  });

  group('날짜 계산', () {
    test('nextCheckAt = last + interval, 자정 정규화', () {
      final r = nextCheckAt(DateTime(2026, 9, 16, 14, 30), 7);
      expect(r, DateTime(2026, 9, 23));
    });
    test('isDueToday: 오늘·과거 true, 내일 false', () {
      final now = DateTime(2026, 9, 16, 9);
      expect(isDueToday(DateTime(2026, 9, 16), now), isTrue);
      expect(isDueToday(DateTime(2026, 9, 10), now), isTrue);
      expect(isDueToday(DateTime(2026, 9, 17), now), isFalse);
    });
    test('daysUntil', () {
      final now = DateTime(2026, 9, 16, 23);
      expect(daysUntil(DateTime(2026, 9, 19), now), 3);
      expect(daysUntil(DateTime(2026, 9, 16), now), 0);
      expect(daysUntil(DateTime(2026, 9, 14), now), -2);
    });
    test('recheckDaysAfterWet: 25%, 1~3일 클램프', () {
      expect(recheckDaysAfterWet(2), 1);
      expect(recheckDaysAfterWet(8), 2);
      expect(recheckDaysAfterWet(30), 3);
    });
  });
}
