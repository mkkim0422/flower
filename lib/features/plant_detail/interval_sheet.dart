import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../data/repositories/plant_repository.dart';
import '../../domain/watering_rules.dart';

/// PLT-02 관리 주기 조정: 자동 계산 근거 + 수동 슬라이더
Future<void> showIntervalSheet(
  BuildContext context, {
  required PlantEntry entry,
  required WateringResult result,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _IntervalSheet(entry: entry, result: result),
  );
}

class _IntervalSheet extends ConsumerStatefulWidget {
  const _IntervalSheet({required this.entry, required this.result});

  final PlantEntry entry;
  final WateringResult result;

  @override
  ConsumerState<_IntervalSheet> createState() => _IntervalSheetState();
}

class _IntervalSheetState extends ConsumerState<_IntervalSheet> {
  late bool _manual = widget.entry.plant.manualOverride;
  late double _days = widget.entry.plant.waterIntervalDays.toDouble();

  Future<void> _save() async {
    await ref
        .read(plantRepositoryProvider)
        .setManualInterval(widget.entry.plant.id, _manual ? _days.round() : null);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final r = widget.result;
    // 자동 계산값(수동 무시)
    final auto = ref.read(plantRepositoryProvider).computeFor(
          species: widget.entry.species,
          space: widget.entry.space,
          potSize: widget.entry.plant.potSize,
          hasDrainage: widget.entry.plant.hasDrainage,
          feedbackCoef: widget.entry.plant.feedbackCoef,
        );

    String f(double v) => v.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, AppSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('물주기 조정', style: AppText.title.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpace.md),
          Container(
            padding: const EdgeInsets.all(AppSpace.cardPadding),
            decoration: BoxDecoration(
              color: c.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('자동 계산 근거', style: AppText.label.copyWith(color: c.textSecondary)),
                const SizedBox(height: AppSpace.sm),
                Text(
                  '품종 기본 ${r.base}일 × 계절 ${f(r.season)} × 빛 ${f(r.light)} × 화분 ${f(r.pot)} × 피드백 ${f(r.feedback)}',
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  '= ${auto.days}일',
                  style: AppText.title.copyWith(
                    color: c.primary,
                    fontFeatures: AppText.tabularFeatures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _manual,
            activeThumbColor: c.primary,
            title: Text('직접 정하기', style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
            subtitle: Text(
              _manual ? '흙 확인 결과로 자동 보정하지 않아요' : '계절·환경·흙 확인 결과로 자동 보정해요',
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
            onChanged: (v) => setState(() {
              _manual = v;
              if (!v) _days = auto.days.toDouble();
            }),
          ),
          if (_manual) ...[
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _days,
                    min: 1,
                    max: 45,
                    divisions: 44,
                    activeColor: c.primary,
                    onChanged: (v) => setState(() => _days = v),
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    '${_days.round()}일',
                    textAlign: TextAlign.end,
                    style: AppText.title.copyWith(
                      color: c.textPrimary,
                      fontFeatures: AppText.tabularFeatures,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpace.lg),
          AppButton.primary(label: '저장', onPressed: _save),
        ],
      ),
    );
  }
}
