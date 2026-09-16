import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../data/repositories/identification_repository.dart';
import '../../domain/identification_service.dart';
import '../add_plant/add_plant_draft.dart';

/// CAM-02(식별 중) / CAM-03(결과) / CAM-04(식별 불가) 를 상태에 따라 한 화면에서 처리
class IdentifyResultScreen extends ConsumerWidget {
  const IdentifyResultScreen({super.key, required this.photoPath});

  final String photoPath;

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    IdentificationSuccess result,
    IdentificationCandidate? chosen,
  ) async {
    await ref
        .read(identificationRepositoryProvider)
        .logSelection(
          localPhotoPath: photoPath,
          candidates: result.candidates,
          selectedSpeciesId: chosen?.speciesId,
        );
    if (!context.mounted) return;
    if (chosen == null) {
      // 목록에 없어요 → 직접 입력
      context.push(
        AppRoutes.addManual,
        extra: AddPlantDraft(photoPath: photoPath),
      );
      return;
    }
    context.push(
      AppRoutes.addEnv,
      extra: AddPlantDraft(
        speciesId: chosen.speciesId,
        nicknameHint: chosen.koName ?? chosen.scientificName,
        photoPath: photoPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final outcome = ref.watch(identifyPhotoProvider(photoPath));

    return Scaffold(
      appBar: AppBar(title: const Text('식별 결과')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          // 촬영 사진 4:3
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Image.file(File(photoPath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppSpace.section),
          outcome.when(
            loading: () => const _Identifying(),
            error: (e, _) => _Unavailable(
              reason: UnavailableReason.apiError,
              onSearch: () => context.push(AppRoutes.addSearch),
              onManual: () => context.push(
                AppRoutes.addManual,
                extra: AddPlantDraft(photoPath: photoPath),
              ),
            ),
            data: (o) => switch (o) {
              IdentificationSuccess s => _Results(
                result: s,
                onSelect: (cand) => _select(context, ref, s, cand),
                onNone: () => _select(context, ref, s, null),
              ),
              IdentificationUnavailable u => _Unavailable(
                reason: u.reason,
                onSearch: () => context.push(AppRoutes.addSearch),
                onManual: () => context.push(
                  AppRoutes.addManual,
                  extra: AddPlantDraft(photoPath: photoPath),
                ),
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

/// CAM-02
class _Identifying extends StatelessWidget {
  const _Identifying();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        const SizedBox(height: AppSpace.xl),
        const CircularProgressIndicator(),
        const SizedBox(height: AppSpace.lg),
        Text(
          '어떤 식물인지 찾고 있어요',
          style: AppText.title.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: AppSpace.xs),
        Text(
          '사진은 확인 후 바로 지워져요',
          style: AppText.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

/// CAM-03
class _Results extends StatelessWidget {
  const _Results({
    required this.result,
    required this.onSelect,
    required this.onNone,
  });

  final IdentificationSuccess result;
  final ValueChanged<IdentificationCandidate> onSelect;
  final VoidCallback onNone;

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
                    ? (candidate.commonNames.isEmpty
                          ? '도감 미등록'
                          : candidate.commonNames.first)
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
  });

  final UnavailableReason reason;
  final VoidCallback onSearch;
  final VoidCallback onManual;

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
        '잎 전체가 나오게 다시 찍거나, 이름 검색으로 등록해 보세요',
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
