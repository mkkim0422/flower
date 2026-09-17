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
  String get label => switch (this) {
    WindowDir.e => '동향',
    WindowDir.w => '서향',
    WindowDir.s => '남향',
    WindowDir.n => '북향',
    WindowDir.none => '창 없음',
  };
}

extension WindowDistLabel on WindowDist {
  String get label => switch (this) {
    WindowDist.near => '창가',
    WindowDist.oneMeter => '1m 이내',
    WindowDist.far => '멀리',
  };
}

extension PotSizeLabel on PotSize {
  String get label => switch (this) {
    PotSize.s => '작음',
    PotSize.m => '보통',
    PotSize.l => '큼',
  };
}

extension DiaryTagLabel on DiaryTag {
  String get label => switch (this) {
    DiaryTag.newLeaf => '새잎',
    DiaryTag.flower => '꽃',
    DiaryTag.droop => '잎 처짐',
    DiaryTag.yellow => '잎 노랗게',
    DiaryTag.pest => '해충 의심',
  };
}
