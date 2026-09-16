import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/plant_card.dart';
import '../../data/repositories/plant_repository.dart';
import '../../domain/watering_rules.dart';

/// HOME-02 흙 확인 결과 입력 바텀시트.
/// 1개 또는 여러 개(다중 선택 일괄 완료) 식물에 같은 결과를 적용한다.
Future<SoilCheckResult?> showSoilCheckSheet(
  BuildContext context, {
  required List<PlantEntry> entries,
}) {
  return showModalBottomSheet<SoilCheckResult>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _SoilCheckSheet(entries: entries),
  );
}

class _SoilCheckSheet extends ConsumerStatefulWidget {
  const _SoilCheckSheet({required this.entries});

  final List<PlantEntry> entries;

  @override
  ConsumerState<_SoilCheckSheet> createState() => _SoilCheckSheetState();
}

class _SoilCheckSheetState extends ConsumerState<_SoilCheckSheet> {
  bool _saving = false;

  Future<void> _submit(SoilCheckResult result) async {
    if (_saving) return;
    setState(() => _saving = true);
    final repo = ref.read(plantRepositoryProvider);
    await repo.recordSoilCheckBatch(
      widget.entries.map((e) => e.plant.id),
      result,
    );
    if (mounted) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final single = widget.entries.length == 1;
    final first = widget.entries.first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.screenH,
        AppSpace.sm,
        AppSpace.screenH,
        AppSpace.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 대상 식물
          Row(
            children: [
              if (single)
                PlantThumb(size: AppSize.plantThumb, photoPath: first.plant.photoPath)
              else
                Container(
                  width: AppSize.plantThumb,
                  height: AppSize.plantThumb,
                  decoration: BoxDecoration(
                    color: c.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.thumbnail),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.entries.length}',
                    style: AppText.title.copyWith(
                      color: c.primary,
                      fontFeatures: AppText.tabularFeatures,
                    ),
                  ),
                ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      single ? first.plant.nickname : '식물 ${widget.entries.length}개',
                      style: AppText.title.copyWith(color: c.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      single
                          ? (first.space?.name ?? first.displaySpeciesName)
                          : widget.entries.map((e) => e.plant.nickname).join(', '),
                      style: AppText.caption.copyWith(color: c.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xl),
          Text(
            '흙을 손가락으로 2~3cm 눌러 보세요',
            style: AppText.body.copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpace.lg),
          _ChoiceCard(
            icon: Icons.water_drop_rounded,
            title: '말랐어요, 물 줬어요',
            subtitle: '물 준 날로 기록하고 다음 확인일을 잡아요',
            primary: true,
            onTap: _saving ? null : () => _submit(SoilCheckResult.dry),
          ),
          const SizedBox(height: AppSpace.md),
          _ChoiceCard(
            icon: Icons.opacity_rounded,
            title: '아직 촉촉해요',
            subtitle: '물 주기를 조금 늘리고 며칠 뒤 다시 확인해요',
            primary: false,
            onTap: _saving ? null : () => _submit(SoilCheckResult.wet),
          ),
          const SizedBox(height: AppSpace.sm),
          AppButton.text(
            label: '나중에',
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// 큰 선택 카드 2개 (Override O3: 직관적으로 선택하기 쉽게)
class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = primary ? c.primary : c.primaryContainer;
    final fg = primary ? c.onPrimary : c.primary;
    final sub = primary ? c.onPrimary.withValues(alpha: 0.8) : c.textSecondary;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.cardPadding),
          child: Row(
            children: [
              Icon(icon, color: fg, size: AppSpace.xxl),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.title.copyWith(color: fg)),
                    const SizedBox(height: AppSpace.xs / 2),
                    Text(subtitle, style: AppText.caption.copyWith(color: sub)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
