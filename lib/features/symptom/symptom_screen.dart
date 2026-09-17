import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_card.dart';
import '../../data/repositories/plant_repository.dart';
import '../../domain/symptom_guide.dart';
import '../plant_detail/interval_sheet.dart';

/// 증상으로 원인 찾기. 품종이 있으면 그 품종에 흔한 문제를 먼저 보여준다.
class SymptomScreen extends ConsumerStatefulWidget {
  const SymptomScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends ConsumerState<SymptomScreen> {
  String? _openId;

  void _openInterval(PlantEntry entry) {
    final result = ref.read(plantRepositoryProvider).computeForEntry(entry);
    showIntervalSheet(context, entry: entry, result: result);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final entry = ref.watch(plantByIdProvider(widget.plantId)).value;
    final issues = entry?.species?.commonIssues ?? const <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text('증상으로 원인 찾기')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screenH,
          0,
          AppSpace.screenH,
          AppSpace.xxl,
        ),
        children: [
          Text(
            '사진 진단이 아니라 흔한 원인을 안내해요. 여러 원인이 겹칠 수 있으니 확인 방법을 보고 골라 주세요',
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.section),

          if (entry?.species != null && issues.isNotEmpty) ...[
            Text(
              '${entry!.species!.koNames.first}에 흔한 문제',
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < issues.length; i++) ...[
                    if (i > 0) ...[
                      const SizedBox(height: AppSpace.md),
                      const Divider(),
                      const SizedBox(height: AppSpace.md),
                    ],
                    Builder(
                      builder: (_) {
                        final it = splitIssue(issues[i]);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              it.symptom,
                              style: AppText.bodyStrong.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                            if (it.solution.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpace.xs,
                                ),
                                child: Text(
                                  it.solution,
                                  style: AppText.body.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpace.section),
          ],

          Text(
            '어떤 증상인가요?',
            style: AppText.label.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.sm),
          for (final s in kSymptoms) ...[
            _SymptomCard(
              symptom: s,
              open: _openId == s.id,
              onToggle: () =>
                  setState(() => _openId = _openId == s.id ? null : s.id),
              onAdjustInterval: entry == null
                  ? null
                  : () => _openInterval(entry),
            ),
            const SizedBox(height: AppSpace.cardGap),
          ],
        ],
      ),
    );
  }
}

class _SymptomCard extends StatelessWidget {
  const _SymptomCard({
    required this.symptom,
    required this.open,
    required this.onToggle,
    required this.onAdjustInterval,
  });

  final Symptom symptom;
  final bool open;
  final VoidCallback onToggle;
  final VoidCallback? onAdjustInterval;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.cardPadding),
              child: Row(
                children: [
                  Icon(symptom.icon, color: c.textSecondary),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Text(
                      symptom.title,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                    ),
                  ),
                  Icon(
                    open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: c.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.cardPadding,
                0,
                AppSpace.cardPadding,
                AppSpace.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < symptom.causes.length; i++)
                    _CauseBlock(
                      index: i + 1,
                      cause: symptom.causes[i],
                      onAdjustInterval: onAdjustInterval,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CauseBlock extends StatelessWidget {
  const _CauseBlock({
    required this.index,
    required this.cause,
    required this.onAdjustInterval,
  });

  final int index;
  final SymptomCause cause;
  final VoidCallback? onAdjustInterval;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpace.sm),
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${cause.title}',
            style: AppText.bodyStrong.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            '확인: ${cause.check}',
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(cause.fix, style: AppText.body.copyWith(color: c.textPrimary)),
          if (cause.action == CauseAction.adjustInterval &&
              onAdjustInterval != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAdjustInterval,
                icon: const Icon(Icons.water_drop_outlined),
                label: const Text('물주기 간격 조정'),
              ),
            ),
        ],
      ),
    );
  }
}
