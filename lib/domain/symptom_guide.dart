// 증상으로 원인 찾기 (2026-09-17 사용자 승인 기능 4).
// 사진 진단이 아니라 흔한 원인과 확인 방법·조치를 안내하는 오프라인 규칙.
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 원인에 붙는 바로가기
enum CauseAction {
  none,

  /// 물주기 간격 조정 시트 열기
  adjustInterval,
}

class SymptomCause {
  const SymptomCause({
    required this.title,
    required this.check,
    required this.fix,
    this.action = CauseAction.none,
  });

  /// 원인 이름
  final String title;

  /// 이 원인인지 확인하는 방법
  final String check;

  /// 조치
  final String fix;
  final CauseAction action;
}

class Symptom {
  const Symptom({
    required this.id,
    required this.title,
    required this.icon,
    required this.causes,
  });

  final String id;
  final String title;
  final IconData icon;

  /// 흔한 순서대로
  final List<SymptomCause> causes;
}

/// 흔한 증상 12가지 (언어별 문구)
List<Symptom> symptomsFor(AppLocalizations l) {
  final overwater = SymptomCause(
    title: l.symOverwaterTitle,
    check: l.symOverwaterCheck,
    fix: l.symOverwaterFix,
    action: CauseAction.adjustInterval,
  );
  final underwater = SymptomCause(
    title: l.symUnderwaterTitle,
    check: l.symUnderwaterCheck,
    fix: l.symUnderwaterFix,
    action: CauseAction.adjustInterval,
  );
  final lowLight = SymptomCause(
    title: l.symLowLightTitle,
    check: l.symLowLightCheck,
    fix: l.symLowLightFix,
  );
  final cold = SymptomCause(
    title: l.symColdTitle,
    check: l.symColdCheck,
    fix: l.symColdFix,
  );
  return [
    Symptom(
      id: 'yellow',
      title: l.symYellow,
      icon: Icons.eco_outlined,
      causes: [
        overwater,
        SymptomCause(
          title: l.symOldLeafTitle,
          check: l.symOldLeafCheck,
          fix: l.symOldLeafFix,
        ),
        underwater,
        lowLight,
      ],
    ),
    Symptom(
      id: 'brown_tips',
      title: l.symBrownTips,
      icon: Icons.content_cut_rounded,
      causes: [
        SymptomCause(
          title: l.symDryAirTitle,
          check: l.symDryAirCheck,
          fix: l.symDryAirFix,
        ),
        underwater,
        SymptomCause(
          title: l.symSaltTitle,
          check: l.symSaltCheck,
          fix: l.symSaltFix,
        ),
      ],
    ),
    Symptom(
      id: 'droop',
      title: l.symDroop,
      icon: Icons.south_rounded,
      causes: [
        underwater,
        SymptomCause(
          title: l.symRootDamageTitle,
          check: l.symRootDamageCheck,
          fix: l.symRootDamageFix,
          action: CauseAction.adjustInterval,
        ),
        cold,
      ],
    ),
    Symptom(
      id: 'leaf_drop',
      title: l.symLeafDrop,
      icon: Icons.arrow_downward_rounded,
      causes: [
        SymptomCause(
          title: l.symAdjustingTitle,
          check: l.symAdjustingCheck,
          fix: l.symAdjustingFix,
        ),
        cold,
        overwater,
        underwater,
      ],
    ),
    Symptom(
      id: 'rot',
      title: l.symRot,
      icon: Icons.water_damage_outlined,
      causes: [
        SymptomCause(
          title: l.symRootRotTitle,
          check: l.symRootRotCheck,
          fix: l.symRootRotFix,
          action: CauseAction.adjustInterval,
        ),
      ],
    ),
    Symptom(
      id: 'spots',
      title: l.symSpots,
      icon: Icons.blur_on_rounded,
      causes: [
        SymptomCause(
          title: l.symSunburnTitle,
          check: l.symSunburnCheck,
          fix: l.symSunburnFix,
        ),
        SymptomCause(
          title: l.symLeafSpotTitle,
          check: l.symLeafSpotCheck,
          fix: l.symLeafSpotFix,
        ),
        overwater,
      ],
    ),
    Symptom(
      id: 'mealybug',
      title: l.symMealybug,
      icon: Icons.bug_report_outlined,
      causes: [
        SymptomCause(
          title: l.symMealybugTitle,
          check: l.symMealybugCheck,
          fix: l.symMealybugFix,
        ),
      ],
    ),
    Symptom(
      id: 'spider_mite',
      title: l.symSpiderMite,
      icon: Icons.grain_rounded,
      causes: [
        SymptomCause(
          title: l.symSpiderMiteTitle,
          check: l.symSpiderMiteCheck,
          fix: l.symSpiderMiteFix,
        ),
      ],
    ),
    Symptom(
      id: 'fungus_gnat',
      title: l.symGnat,
      icon: Icons.pest_control_outlined,
      causes: [
        SymptomCause(
          title: l.symGnatTitle,
          check: l.symGnatCheck,
          fix: l.symGnatFix,
          action: CauseAction.adjustInterval,
        ),
      ],
    ),
    Symptom(
      id: 'leggy',
      title: l.symLeggy,
      icon: Icons.height_rounded,
      causes: [
        SymptomCause(
          title: l.symLeggyTitle,
          check: l.symLeggyCheck,
          fix: l.symLeggyFix,
        ),
      ],
    ),
    Symptom(
      id: 'mold',
      title: l.symMold,
      icon: Icons.cloud_outlined,
      causes: [
        SymptomCause(
          title: l.symMoldTitle,
          check: l.symMoldCheck,
          fix: l.symMoldFix,
          action: CauseAction.adjustInterval,
        ),
      ],
    ),
    Symptom(
      id: 'no_growth',
      title: l.symNoGrowth,
      icon: Icons.hourglass_empty_rounded,
      causes: [
        SymptomCause(
          title: l.symDormantTitle,
          check: l.symDormantCheck,
          fix: l.symDormantFix,
        ),
        lowLight,
        SymptomCause(
          title: l.symPotboundTitle,
          check: l.symPotboundCheck,
          fix: l.symPotboundFix,
        ),
      ],
    ),
  ];
}

/// 품종의 흔한 문제 "증상 → 원인/대처" 문자열을 둘로 나눔
({String symptom, String solution}) splitIssue(String issue) {
  final i = issue.indexOf('→');
  if (i < 0) return (symptom: issue.trim(), solution: '');
  return (
    symptom: issue.substring(0, i).trim(),
    solution: issue.substring(i + 1).trim(),
  );
}
