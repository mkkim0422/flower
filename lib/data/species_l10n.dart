// 도감 품종의 언어별 표시
import '../core/app_locale.dart';
import 'db/app_database.dart';

extension SpeciesLocalized on SpeciesRow {
  bool _ko(AppLocalizations l) => isKorean(l);

  /// 대표 이름: 한국어는 국내 유통명, 그 외는 영어 일반명(없으면 학명)
  String displayName(AppLocalizations l) {
    if (_ko(l)) return koNames.isNotEmpty ? koNames.first : scientificName;
    return namesEn.isNotEmpty ? namesEn.first : scientificName;
  }

  /// 다른 이름들
  List<String> otherNames(AppLocalizations l) =>
      (_ko(l) ? koNames : namesEn).skip(1).toList();

  /// 검색 결과에서 "…로도 불려요"에 쓸 전체 이름
  List<String> allNames(AppLocalizations l) => _ko(l) ? koNames : namesEn;

  String toxicityNoteFor(AppLocalizations l) =>
      _ko(l) || toxicityNoteEn.isEmpty ? toxicityNote : toxicityNoteEn;

  List<String> commonIssuesFor(AppLocalizations l) =>
      _ko(l) || commonIssuesEn.isEmpty ? commonIssues : commonIssuesEn;
}
