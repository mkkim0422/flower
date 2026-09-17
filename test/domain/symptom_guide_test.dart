import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/domain/symptom_guide.dart';

void main() {
  test('증상 데이터: 12가지, id 중복 없음, 원인마다 확인·조치 문장이 있다', () {
    expect(kSymptoms.length, 12);
    expect(kSymptoms.map((s) => s.id).toSet().length, kSymptoms.length);
    for (final s in kSymptoms) {
      expect(s.title.trim(), isNotEmpty);
      expect(s.causes, isNotEmpty, reason: s.id);
      for (final cause in s.causes) {
        expect(cause.title.trim(), isNotEmpty, reason: s.id);
        expect(
          cause.check.trim(),
          isNotEmpty,
          reason: '${s.id}/${cause.title}',
        );
        expect(cause.fix.trim(), isNotEmpty, reason: '${s.id}/${cause.title}');
      }
    }
  });

  test('물 관련 원인에는 물주기 조정 바로가기가 붙는다', () {
    final yellow = kSymptoms.firstWhere((s) => s.id == 'yellow');
    expect(yellow.causes.first.action, CauseAction.adjustInterval);
    final mealybug = kSymptoms.firstWhere((s) => s.id == 'mealybug');
    expect(mealybug.causes.single.action, CauseAction.none);
  });

  test('품종 흔한 문제 문자열 나누기', () {
    final a = splitIssue('잎 끝 갈변 → 건조, 분무');
    expect(a.symptom, '잎 끝 갈변');
    expect(a.solution, '건조, 분무');
    final b = splitIssue('화살표 없는 문장');
    expect(b.symptom, '화살표 없는 문장');
    expect(b.solution, isEmpty);
  });
}
