/// ADD-01~04 사이에 전달되는 등록 초안 (go_router extra)
class AddPlantDraft {
  const AddPlantDraft({
    this.speciesId,
    this.nicknameHint,
    this.photoPath,
    this.scientificName,
  });

  final int? speciesId;

  /// 도감에 없는 종을 식별로 선택한 경우 표시용 학명
  final String? scientificName;
  final String? nicknameHint;
  final String? photoPath;
}
