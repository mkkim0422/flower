import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../data/repositories/identification_repository.dart';
import '../../domain/identification_service.dart';
import '../../domain/image_prep.dart';
import '../add_plant/add_plant_draft.dart';

/// CAM-02(식별 중) / CAM-03(결과) / CAM-04(식별 불가) 를 상태에 따라 한 화면에서 처리.
/// 사진은 최대 [kMaxIdentifyPhotos]장까지 추가할 수 있고, 추가하면 모두 합쳐 다시 식별한다.
class IdentifyResultScreen extends ConsumerStatefulWidget {
  const IdentifyResultScreen({super.key, required this.photoPath});

  /// 첫 사진 (카메라 탭에서 찍거나 고른 것)
  final String photoPath;

  @override
  ConsumerState<IdentifyResultScreen> createState() =>
      _IdentifyResultScreenState();
}

class _IdentifyResultScreenState extends ConsumerState<IdentifyResultScreen> {
  late final List<String> _paths = [widget.photoPath];
  final _picker = ImagePicker();
  bool _adding = false;

  String get _key => _paths.join('|');

  /// 대표 사진 = 첫 사진
  String get _cover => _paths.first;

  Future<void> _addPhoto() async {
    if (_adding || _paths.length >= kMaxIdentifyPhotos) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screenH,
          0,
          AppSpace.screenH,
          AppSpace.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '사진 추가',
              style: AppText.title.copyWith(color: ctx.colors.textPrimary),
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              '잎을 가까이, 또는 꽃이 있으면 꽃을 찍으면 더 정확해져요',
              style: AppText.caption.copyWith(color: ctx.colors.textSecondary),
            ),
            const SizedBox(height: AppSpace.lg),
            AppButton.primary(
              label: '사진 찍기',
              icon: Icons.photo_camera_rounded,
              onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: AppSpace.sm),
            AppButton.secondary(
              label: '앨범에서 고르기',
              icon: Icons.photo_library_outlined,
              onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    setState(() => _adding = true);
    try {
      final x = await _picker.pickImage(source: source, imageQuality: 92);
      if (x == null) return;
      final jpeg = await prepareForIdentification(await x.readAsBytes());
      final path = await savePhotoLocally(jpeg);
      if (mounted) setState(() => _paths.add(path));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진을 가져오지 못했어요')));
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  void _removePhoto(int index) {
    if (_paths.length <= 1) return;
    setState(() => _paths.removeAt(index));
  }

  Future<void> _select(
    IdentificationSuccess result,
    IdentificationCandidate? chosen,
  ) async {
    await ref
        .read(identificationRepositoryProvider)
        .logSelection(
          localPhotoPath: _cover,
          candidates: result.candidates,
          selectedSpeciesId: chosen?.speciesId,
        );
    if (!mounted) return;
    if (chosen == null) {
      await _askHowToRegister();
      return;
    }
    context.push(
      AppRoutes.addEnv,
      extra: AddPlantDraft(
        speciesId: chosen.speciesId,
        nicknameHint: chosen.koName ?? chosen.scientificName,
        photoPath: _cover,
        scientificName: chosen.scientificName,
      ),
    );
  }

  Future<void> _askHowToRegister() async {
    final draft = AddPlantDraft(photoPath: _cover);
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screenH,
          0,
          AppSpace.screenH,
          AppSpace.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '어떻게 등록할까요?',
              style: AppText.title.copyWith(color: ctx.colors.textPrimary),
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              '찍은 사진은 대표 사진으로 들어가요',
              style: AppText.caption.copyWith(color: ctx.colors.textSecondary),
            ),
            const SizedBox(height: AppSpace.lg),
            AppButton.primary(
              label: '이름으로 검색',
              icon: Icons.search_rounded,
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.addSearch, extra: draft);
              },
            ),
            const SizedBox(height: AppSpace.sm),
            AppButton.secondary(
              label: '직접 입력',
              icon: Icons.edit_outlined,
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.addManual, extra: draft);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final outcome = ref.watch(identifyPhotoProvider(_key));
    final canAdd = _paths.length < kMaxIdentifyPhotos && !outcome.isLoading;
    final draft = AddPlantDraft(photoPath: _cover);

    return Scaffold(
      appBar: AppBar(title: const Text('식별 결과')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          // 대표 사진 4:3
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Image.file(File(_cover), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          _PhotoStrip(
            paths: _paths,
            canAdd: canAdd,
            adding: _adding,
            onAdd: _addPhoto,
            onRemove: _removePhoto,
          ),
          const SizedBox(height: AppSpace.section),
          outcome.when(
            loading: () => _Identifying(count: _paths.length),
            error: (e, _) => _Unavailable(
              reason: UnavailableReason.apiError,
              onSearch: () => context.push(AppRoutes.addSearch, extra: draft),
              onManual: () => context.push(AppRoutes.addManual, extra: draft),
            ),
            data: (o) => switch (o) {
              IdentificationSuccess s => _Results(
                result: s,
                onSelect: (cand) => _select(s, cand),
                onNone: () => _select(s, null),
                // 확신이 낮고 사진을 더 넣을 수 있으면 추가를 권한다
                onAddPhoto: !s.isConfident && canAdd ? _addPhoto : null,
              ),
              IdentificationUnavailable u => _Unavailable(
                reason: u.reason,
                onSearch: () => context.push(AppRoutes.addSearch, extra: draft),
                onManual: () => context.push(AppRoutes.addManual, extra: draft),
                onAddPhoto: u.reason == UnavailableReason.noResult && canAdd
                    ? _addPhoto
                    : null,
              ),
            },
          ),
          SizedBox(height: AppSpace.xl + MediaQuery.paddingOf(context).bottom),
        ],
      ),
      backgroundColor: c.background,
    );
  }
}

/// 사진 썸네일 줄 + "사진 추가" 타일
class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.paths,
    required this.canAdd,
    required this.adding,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> paths;
  final bool canAdd;
  final bool adding;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const size = AppSize.candidateThumb;
    return SizedBox(
      height: size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < paths.length; i++) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.thumbnail),
                  child: Image.file(
                    File(paths[i]),
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                ),
                if (paths.length > 1)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => onRemove(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.textPrimary.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(AppSpace.xs / 2),
                        child: Icon(
                          Icons.close_rounded,
                          size: AppSize.iconXxs,
                          color: c.surface,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpace.sm),
          ],
          if (paths.length < kMaxIdentifyPhotos)
            Material(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.thumbnail),
              child: InkWell(
                onTap: canAdd ? onAdd : null,
                borderRadius: BorderRadius.circular(AppRadius.thumbnail),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: adding
                      ? const Center(
                          child: SizedBox(
                            width: AppSize.iconSm,
                            height: AppSize.iconSm,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: AppSize.iconSm,
                              color: canAdd ? c.textSecondary : c.textTertiary,
                            ),
                            const SizedBox(height: AppSpace.xs / 2),
                            Text(
                              '사진 추가',
                              style: AppText.label.copyWith(
                                color: canAdd
                                    ? c.textSecondary
                                    : c.textTertiary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// CAM-02
class _Identifying extends StatelessWidget {
  const _Identifying({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        const SizedBox(height: AppSpace.xl),
        const CircularProgressIndicator(),
        const SizedBox(height: AppSpace.lg),
        Text(
          count > 1 ? '사진 $count장으로 다시 찾고 있어요' : '어떤 식물인지 찾고 있어요',
          style: AppText.title.copyWith(color: c.textPrimary),
        ),
      ],
    );
  }
}

/// 사진 추가 권유 카드
class _AddPhotoHint extends StatelessWidget {
  const _AddPhotoHint({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.accentSoft,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.cardPadding),
          child: Row(
            children: [
              Icon(Icons.add_a_photo_outlined, color: c.primary),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Text(
                  '잎을 가까이, 또는 꽃을 찍어 추가하면 더 정확해져요',
                  style: AppText.body.copyWith(color: c.textPrimary),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// CAM-03
class _Results extends StatelessWidget {
  const _Results({
    required this.result,
    required this.onSelect,
    required this.onNone,
    this.onAddPhoto,
  });

  final IdentificationSuccess result;
  final ValueChanged<IdentificationCandidate> onSelect;
  final VoidCallback onNone;
  final VoidCallback? onAddPhoto;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (result.isConfident) {
      final top = result.top;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpace.cardPadding),
            decoration: BoxDecoration(
              color: c.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: _CandidateBody(candidate: top, emphasize: true),
          ),
          const SizedBox(height: AppSpace.lg),
          AppButton.primary(label: '이 식물이 맞아요', onPressed: () => onSelect(top)),
          const SizedBox(height: AppSpace.sm),
          if (result.candidates.length > 1) ...[
            Text(
              '다른 후보',
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            for (final cand in result.candidates.skip(1))
              _CandidateRow(candidate: cand, onTap: () => onSelect(cand)),
          ],
          AppButton.text(label: '목록에 없어요', expanded: true, onPressed: onNone),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('이 중에 있나요?', style: AppText.title.copyWith(color: c.textPrimary)),
        const SizedBox(height: AppSpace.md),
        for (var i = 0; i < result.candidates.length; i++)
          _CandidateRow(
            candidate: result.candidates[i],
            highlight: i == 0,
            onTap: () => onSelect(result.candidates[i]),
          ),
        if (onAddPhoto != null) ...[
          const SizedBox(height: AppSpace.xs),
          _AddPhotoHint(onAdd: onAddPhoto!),
          const SizedBox(height: AppSpace.sm),
        ],
        const SizedBox(height: AppSpace.sm),
        AppButton.text(label: '목록에 없어요', expanded: true, onPressed: onNone),
      ],
    );
  }
}

/// 식별 후보 행 — 이미지 64 · 국내명 title / 학명 caption 이탤릭 · 확률 title primary. 1순위 primaryContainer 배경.
class _CandidateRow extends StatelessWidget {
  const _CandidateRow({
    required this.candidate,
    required this.onTap,
    this.highlight = false,
  });

  final IdentificationCandidate candidate;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.cardGap),
      child: Material(
        color: highlight ? c.primaryContainer : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: highlight ? c.primaryContainer : c.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.md),
            child: _CandidateBody(candidate: candidate),
          ),
        ),
      ),
    );
  }
}

class _CandidateBody extends StatelessWidget {
  const _CandidateBody({required this.candidate, this.emphasize = false});

  final IdentificationCandidate candidate;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = emphasize
        ? AppSize.candidateThumb * 1.25
        : AppSize.candidateThumb;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.thumbnail),
          child: SizedBox(
            width: size,
            height: size,
            child: candidate.imageUrl == null
                ? ColoredBox(
                    color: c.surfaceVariant,
                    child: Icon(Icons.eco_outlined, color: c.textTertiary),
                  )
                : Image.network(
                    candidate.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: c.surfaceVariant,
                      child: Icon(Icons.eco_outlined, color: c.textTertiary),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                candidate.koName ?? candidate.scientificName,
                style: AppText.title.copyWith(color: c.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                candidate.koName == null
                    ? '도감에 없는 품종 · 등록하면 이름을 직접 정할 수 있어요'
                    : candidate.scientificName,
                style: AppText.scientificName.copyWith(color: c.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        Text(
          '${candidate.percent}%',
          style: AppText.title.copyWith(
            color: c.primary,
            fontFeatures: AppText.tabularFeatures,
          ),
        ),
      ],
    );
  }
}

/// CAM-04
class _Unavailable extends StatelessWidget {
  const _Unavailable({
    required this.reason,
    required this.onSearch,
    required this.onManual,
    this.onAddPhoto,
  });

  final UnavailableReason reason;
  final VoidCallback onSearch;
  final VoidCallback onManual;
  final VoidCallback? onAddPhoto;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (title, desc) = switch (reason) {
      UnavailableReason.dailyLimit => (
        '오늘 식별 횟수를 다 썼어요',
        '내일 다시 시도하거나, 이름 검색으로 등록해 보세요',
      ),
      UnavailableReason.network => (
        '인터넷에 연결되지 않았어요',
        '연결을 확인하고 다시 시도하거나, 이름 검색으로 등록해 보세요',
      ),
      UnavailableReason.noResult => (
        '식물을 찾지 못했어요',
        '잎이나 꽃을 가까이 찍어 추가하거나, 이름 검색으로 등록해 보세요',
      ),
      UnavailableReason.modelMissing || UnavailableReason.apiError => (
        '지금은 식별을 할 수 없어요',
        '식별 서버 연결이 아직 설정되지 않았어요. 이름 검색으로 등록해 보세요',
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: AppSize.emptyIllustration * 0.6,
          color: c.textTertiary,
        ),
        const SizedBox(height: AppSpace.lg),
        Text(
          title,
          style: AppText.title.copyWith(color: c.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpace.sm),
        Text(
          desc,
          style: AppText.body.copyWith(color: c.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpace.xl),
        if (onAddPhoto != null) ...[
          AppButton.primary(
            label: '사진 추가해서 다시 찾기',
            icon: Icons.add_a_photo_outlined,
            onPressed: onAddPhoto,
          ),
          const SizedBox(height: AppSpace.sm),
          AppButton.secondary(label: '이름으로 검색', onPressed: onSearch),
        ] else
          AppButton.primary(label: '이름으로 검색', onPressed: onSearch),
        const SizedBox(height: AppSpace.sm),
        AppButton.text(
          label: '직접 입력으로 등록',
          expanded: true,
          onPressed: onManual,
        ),
      ],
    );
  }
}
