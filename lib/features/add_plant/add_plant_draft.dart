/// ADD-01~04 사이에 전달되는 등록 초안 (go_router extra)
class AddPlantDraft {
  const AddPlantDraft({this.speciesId, this.nicknameHint, this.photoPath});

  final int? speciesId;
  final String? nicknameHint;
  final String? photoPath;
}
