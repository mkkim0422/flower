import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/plant_card.dart';
import '../../data/repositories/plant_repository.dart';
import '../../domain/watering_rules.dart';

/// HOME-02 물 주기 바텀시트 (2026-09-16 사용자 지시로 "흙 확인" → "물 줬어요" 단일 액션으로 단순화)
/// - 물 줬어요: 오늘을 물 준 날로 기록, 다음 D-day 계산
/// - 나중에 줄게요: 2~3일 뒤 다시 알림 (주기는 살짝 늘어남)
Future<SoilCheckResult?> showSoilCheckSheet(
  BuildContext context, {
  required List<PlantEntry> entries,
}) {
  return showModalBottomSheet<SoilCheckResult>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _WaterSheet(entries: entries),
  );
}

class _WaterSheet extends ConsumerStatefulWidget {
  const _WaterSheet({required this.entries});

  final List<PlantEntry> entries;

  @override
  ConsumerState<_WaterSheet> createState() => _WaterSheetState();
}

class _WaterSheetState extends ConsumerState<_WaterSheet> {
  bool _saving = false;

  Future<void> _submit(SoilCheckResult result) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(plantRepositoryProvider)
          .recordSoilCheckBatch(widget.entries.map((e) => e.plant.id), result);
      if (mounted) Navigator.of(context).pop(result);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final single = widget.entries.length == 1;
    final first = widget.entries.first;
    final snooze = recheckDaysAfterWet(first.plant.waterIntervalDays);

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
          Row(
            children: [
              if (single)
                PlantThumb(
                  size: AppSize.plantThumb,
                  photoPath: first.plant.photoPath,
                )
              else
                Container(
                  width: AppSize.plantThumb,
                  height: AppSize.plantThumb,
                  decoration: BoxDecoration(
                    color: c.accentSoft,
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
                      single
                          ? first.plant.nickname
                          : '식물 ${widget.entries.length}개',
                      style: AppText.title.copyWith(color: c.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      single
                          ? first.displaySpeciesName
                          : widget.entries
                                .map((e) => e.plant.nickname)
                                .join(', '),
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
          AppButton.primary(
            label: '물 줬어요',
            icon: Icons.water_drop_rounded,
            onPressed: _saving ? null : () => _submit(SoilCheckResult.dry),
          ),
          const SizedBox(height: AppSpace.sm),
          AppButton.text(
            label: '나중에 줄게요 · $snooze일 뒤 다시 알려드려요',
            expanded: true,
            onPressed: _saving ? null : () => _submit(SoilCheckResult.wet),
          ),
        ],
      ),
    );
  }
}
