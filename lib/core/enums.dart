import '../l10n/app_localizations.dart';

// 도메인 열거형. DB(Drift textEnum)와 UI가 공유한다. 이름(name)이 DB에 저장되므로 변경 시 마이그레이션 필요.

/// 창 방향 (SPC-02)
enum WindowDir { e, w, s, n, none }

/// 창과의 거리 (SPC-02)
enum WindowDist { near, oneMeter, far }

/// 화분 크기 (ADD-04)
enum PotSize { s, m, l }

/// 품종 빛 선호도
enum LightPref { low, med, high }

/// 아이(사람) 독성 단계: 없음 / 자극(삼키면 입·피부 자극) / 독성
enum ChildToxicity { none, irritant, toxic }

/// 관리 이벤트 종류
enum CareType { water, fert, repot, wipe, checkDry, checkWet }

/// 일기 상태 태그 (DIA-01)
enum DiaryTag { newLeaf, flower, droop, yellow, pest }

extension WindowDirLabel on WindowDir {
  String label(AppLocalizations l) => switch (this) {
    WindowDir.e => l.windowDirE,
    WindowDir.w => l.windowDirW,
    WindowDir.s => l.windowDirS,
    WindowDir.n => l.windowDirN,
    WindowDir.none => l.windowDirNone,
  };
}

extension WindowDistLabel on WindowDist {
  String label(AppLocalizations l) => switch (this) {
    WindowDist.near => l.windowDistNear,
    WindowDist.oneMeter => l.windowDistOneMeter,
    WindowDist.far => l.windowDistFar,
  };
}

extension PotSizeLabel on PotSize {
  String label(AppLocalizations l) => switch (this) {
    PotSize.s => l.potSizeS,
    PotSize.m => l.potSizeM,
    PotSize.l => l.potSizeL,
  };
}

extension DiaryTagLabel on DiaryTag {
  String label(AppLocalizations l) => switch (this) {
    DiaryTag.newLeaf => l.diaryTagNewLeaf,
    DiaryTag.flower => l.diaryTagFlower,
    DiaryTag.droop => l.diaryTagDroop,
    DiaryTag.yellow => l.diaryTagYellow,
    DiaryTag.pest => l.diaryTagPest,
  };
}
