import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/notification_service.dart';

/// 알림 잠시 멈추기 (여행·휴가). 멈추는 동안 물 줄 날이 오는 식물을 미리 알려준다.
Future<void> showPauseSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => const _PauseSheet(),
  );
}

class _PauseSheet extends ConsumerStatefulWidget {
  const _PauseSheet();

  @override
  ConsumerState<_PauseSheet> createState() => _PauseSheetState();
}

class _PauseSheetState extends ConsumerState<_PauseSheet> {
  static const _presets = [3, 7, 14];
  DateTime? _until;

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _pickDate() async {
    final today = _today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _until ?? today.add(const Duration(days: 7)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 60)),
      locale: const Locale('ko', 'KR'),
      helpText: '이 날까지 알림을 멈춰요',
    );
    if (picked != null) setState(() => _until = picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final plants = ref.watch(plantsProvider).value ?? const <PlantEntry>[];
    final paused = settings != null && isNotifyPaused(settings, DateTime.now());
    final today = _today();
    final daysSel = _until?.difference(today).inDays;

    // 멈추는 동안(오늘~마지막 날) 물 줄 날이 오는 식물
    final dueDuring = _until == null
        ? const <PlantEntry>[]
        : plants.where((e) {
            final d = e.plant.nextCheckAt;
            return !DateTime(d.year, d.month, d.day).isAfter(_until!);
          }).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.screenH,
        0,
        AppSpace.screenH,
        AppSpace.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '알림 잠시 멈추기',
            style: AppText.title.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            '여행이나 휴가로 집을 비울 때 알림을 멈춰요',
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.lg),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final d in _presets)
                AppChip(
                  label: d == 7 ? '1주' : (d == 14 ? '2주' : '$d일'),
                  selected: daysSel == d,
                  onTap: () =>
                      setState(() => _until = today.add(Duration(days: d))),
                ),
              AppChip(
                label: _until != null && !_presets.contains(daysSel)
                    ? DateFormat('M월 d일까지', 'ko_KR').format(_until!)
                    : '날짜 선택',
                selected: _until != null && !_presets.contains(daysSel),
                onTap: _pickDate,
              ),
            ],
          ),
          if (_until != null) ...[
            const SizedBox(height: AppSpace.lg),
            Container(
              padding: const EdgeInsets.all(AppSpace.cardPadding),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Text(
                dueDuring.isEmpty
                    ? '${DateFormat('M월 d일', 'ko_KR').format(_until!)}까지 물 줄 날이 오는 식물은 없어요'
                    : '떠나기 전에 물 주면 좋은 식물: ${dueDuring.map((e) => e.plant.nickname).join(', ')}',
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
            ),
          ],
          const SizedBox(height: AppSpace.lg),
          AppButton.primary(
            label: _until == null
                ? '기간을 골라 주세요'
                : '${DateFormat('M월 d일', 'ko_KR').format(_until!)}까지 멈추기',
            onPressed: _until == null
                ? null
                : () async {
                    await ref
                        .read(settingsRepositoryProvider)
                        .setNotifyPausedUntil(_until);
                    if (context.mounted) Navigator.pop(context);
                  },
          ),
          if (paused) ...[
            const SizedBox(height: AppSpace.sm),
            AppButton.text(
              label: '알림 다시 켜기',
              expanded: true,
              onPressed: () async {
                await ref
                    .read(settingsRepositoryProvider)
                    .setNotifyPausedUntil(null);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ],
      ),
    );
  }
}
