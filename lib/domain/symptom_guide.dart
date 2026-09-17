// 증상으로 원인 찾기 (2026-09-17 사용자 승인 기능 4).
// 사진 진단이 아니라 흔한 원인과 확인 방법·조치를 안내하는 오프라인 규칙.
import 'package:flutter/material.dart';

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

const _overwater = SymptomCause(
  title: '물을 너무 자주 줌 (과습)',
  check: '흙이 며칠째 축축하고, 아랫잎부터 노래지며 잎이 물렁해요',
  fix: '흙이 속까지 마를 때까지 물을 멈추고, 물주기 간격을 늘려 주세요. 받침에 고인 물은 버려 주세요',
  action: CauseAction.adjustInterval,
);

const _underwater = SymptomCause(
  title: '물 부족',
  check: '흙이 바싹 말라 화분이 가볍고, 잎이 얇고 힘없이 처져요',
  fix: '화분 밑으로 물이 흘러나올 만큼 흠뻑 주세요. 자주 이러면 물주기 간격을 줄여 주세요',
  action: CauseAction.adjustInterval,
);

const _lowLight = SymptomCause(
  title: '빛 부족',
  check: '잎 색이 전체적으로 연해지고, 줄기가 가늘고 길게 늘어져요',
  fix: '창가처럼 더 밝은 곳으로 옮겨 주세요. 한여름 직사광선만 피하면 돼요',
);

const _coldDraft = SymptomCause(
  title: '추위·찬바람',
  check: '겨울 창가나 에어컨·현관 바람이 닿는 자리에 있어요',
  fix: '찬바람이 닿지 않는 따뜻한 곳으로 옮겨 주세요. 상한 잎은 회복되지 않으니 떼어 주세요',
);

/// 흔한 증상 12가지
const List<Symptom> kSymptoms = [
  Symptom(
    id: 'yellow',
    title: '잎이 노랗게 변해요',
    icon: Icons.eco_outlined,
    causes: [
      _overwater,
      SymptomCause(
        title: '오래된 잎이 자연스럽게 지는 중',
        check: '맨 아래 잎 1~2장만 노래지고, 새잎은 건강해요',
        fix: '정상이에요. 노란 잎만 떼어 주세요',
      ),
      _underwater,
      _lowLight,
    ],
  ),
  Symptom(
    id: 'brown_tips',
    title: '잎 끝이 갈색으로 말라요',
    icon: Icons.content_cut_rounded,
    causes: [
      SymptomCause(
        title: '공기가 건조함',
        check: '난방·에어컨을 켜는 계절이거나 바람이 직접 닿는 자리예요',
        fix: '가습기를 곁에 두거나 잎 주변에 분무해 주세요. 마른 끝은 가위로 다듬어도 돼요',
      ),
      _underwater,
      SymptomCause(
        title: '수돗물 성분·비료가 쌓임',
        check: '물을 제때 주는데도 끝이 계속 타들어가요',
        fix: '하루 받아둔 물을 주고, 비료를 줬다면 한동안 쉬어 주세요',
      ),
    ],
  ),
  Symptom(
    id: 'droop',
    title: '잎이 축 처져요',
    icon: Icons.south_rounded,
    causes: [
      _underwater,
      SymptomCause(
        title: '과습으로 뿌리가 상함',
        check: '흙이 젖어 있는데도 처지고, 밑동이 무르거나 흙에서 냄새가 나요',
        fix: '물을 멈추고 흙을 말려 주세요. 밑동이 물렀다면 아래 "줄기·밑동이 물러요"를 확인해 주세요',
        action: CauseAction.adjustInterval,
      ),
      _coldDraft,
    ],
  ),
  Symptom(
    id: 'leaf_drop',
    title: '잎이 갑자기 떨어져요',
    icon: Icons.arrow_downward_rounded,
    causes: [
      SymptomCause(
        title: '자리가 바뀌어 적응 중',
        check: '최근에 들여왔거나 자리를 옮겼어요 (고무나무·벤자민에 흔해요)',
        fix: '2~3주는 자리를 옮기지 말고 지켜봐 주세요. 새잎이 나면 적응한 거예요',
      ),
      _coldDraft,
      _overwater,
      _underwater,
    ],
  ),
  Symptom(
    id: 'rot',
    title: '줄기·밑동이 물러요',
    icon: Icons.water_damage_outlined,
    causes: [
      SymptomCause(
        title: '뿌리 썩음 (오랜 과습)',
        check: '밑동이 검고 물렁하며, 흙에서 퀴퀴한 냄새가 나요',
        fix:
            '화분에서 꺼내 검고 무른 뿌리를 잘라내고 마른 새 흙에 심어 주세요. 한동안 물을 아껴 주세요. 심하면 건강한 줄기를 잘라 물꽂이로 살릴 수 있어요',
        action: CauseAction.adjustInterval,
      ),
    ],
  ),
  Symptom(
    id: 'spots',
    title: '잎에 갈색·검은 반점이 생겨요',
    icon: Icons.blur_on_rounded,
    causes: [
      SymptomCause(
        title: '햇빛에 잎이 탐',
        check: '햇빛이 닿는 쪽 잎에 마르고 바삭한 갈색 자국이 있어요',
        fix: '커튼 너머로 옮겨 주세요. 탄 자국은 사라지지 않지만 새잎은 괜찮아요',
      ),
      SymptomCause(
        title: '곰팡이·세균성 반점',
        check: '노란 테두리가 있는 젖은 듯한 반점이 점점 번져요',
        fix: '반점 난 잎을 떼어 내고, 잎에 물이 오래 묻어 있지 않게 통풍을 시켜 주세요',
      ),
      _overwater,
    ],
  ),
  Symptom(
    id: 'mealybug',
    title: '흰 솜 같은 벌레, 끈적임',
    icon: Icons.bug_report_outlined,
    causes: [
      SymptomCause(
        title: '깍지벌레·솜깍지벌레',
        check: '잎 겨드랑이나 뒷면에 하얀 솜뭉치나 갈색 껍질이 붙어 있고, 잎이 끈적여요',
        fix: '물티슈나 면봉으로 닦아내고 다른 식물과 떨어뜨려 주세요. 계속 생기면 원예용 살충제를 써 주세요',
      ),
    ],
  ),
  Symptom(
    id: 'spider_mite',
    title: '잎 뒷면에 거미줄·작은 점',
    icon: Icons.grain_rounded,
    causes: [
      SymptomCause(
        title: '응애',
        check: '잎에 자잘한 흰 점이 생기고, 뒷면에 가는 거미줄이 보여요. 건조할 때 잘 생겨요',
        fix: '샤워기로 잎 앞뒤를 씻어내고 습도를 올려 주세요. 반복되면 응애용 살충제를 써 주세요',
      ),
    ],
  ),
  Symptom(
    id: 'fungus_gnat',
    title: '작은 날파리가 날아다녀요',
    icon: Icons.pest_control_outlined,
    causes: [
      SymptomCause(
        title: '뿌리파리 (흙이 오래 젖어 있음)',
        check: '화분 흙 위나 주변에 작은 검은 날파리가 맴돌아요',
        fix: '겉흙이 마를 때까지 물을 참고 노란 끈끈이를 꽂아 주세요. 물주기 간격을 조금 늘리면 줄어들어요',
        action: CauseAction.adjustInterval,
      ),
    ],
  ),
  Symptom(
    id: 'leggy',
    title: '줄기만 길쭉하게 자라요',
    icon: Icons.height_rounded,
    causes: [
      SymptomCause(
        title: '빛 부족 (웃자람)',
        check: '잎 사이 간격이 넓어지고 줄기가 창 쪽으로 휘어요',
        fix: '더 밝은 곳으로 옮기고, 웃자란 줄기는 잘라 정리해 주세요. 가끔 화분을 돌려 주면 고르게 자라요',
      ),
    ],
  ),
  Symptom(
    id: 'mold',
    title: '흙 위에 하얀 곰팡이가 폈어요',
    icon: Icons.cloud_outlined,
    causes: [
      SymptomCause(
        title: '통풍 부족·과습',
        check: '흙 표면에 흰 실이나 솜 같은 곰팡이가 보여요',
        fix: '곰팡이 핀 겉흙을 걷어내고 통풍이 되는 곳에 두세요. 식물에는 대부분 해가 없어요',
        action: CauseAction.adjustInterval,
      ),
    ],
  ),
  Symptom(
    id: 'no_growth',
    title: '새잎이 안 나요',
    icon: Icons.hourglass_empty_rounded,
    causes: [
      SymptomCause(
        title: '겨울 휴면',
        check: '11월~2월이에요',
        fix: '정상이에요. 봄이 되면 다시 자라요. 겨울에는 물을 조금 아껴 주세요',
      ),
      _lowLight,
      SymptomCause(
        title: '화분이 작아짐',
        check: '뿌리가 배수구 밖으로 나오거나 물이 금방 빠져요',
        fix: '봄에 한 치수 큰 화분으로 옮겨 심어 주세요',
      ),
    ],
  ),
];

/// 품종의 흔한 문제 "증상 → 원인/대처" 문자열을 둘로 나눔
({String symptom, String solution}) splitIssue(String issue) {
  final i = issue.indexOf('→');
  if (i < 0) return (symptom: issue.trim(), solution: '');
  return (
    symptom: issue.substring(0, i).trim(),
    solution: issue.substring(i + 1).trim(),
  );
}
