import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_card.dart';
import '../../app/widgets/app_chip.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/notification_service.dart';
import 'pause_sheet.dart';
import '../../domain/stats_service.dart';

const String kAppVersion = '0.1.0';

/// MY-01: 통계 3칸 + 설정 리스트. 백업·계정·품종 요청은 M4.
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final stats = ref.watch(statsProvider).value;
    final settings = ref.watch(settingsProvider).value;
    final bottomPad =
        AppSize.tabBarHeight +
        AppSize.cameraButtonOverlap +
        AppSpace.xl +
        MediaQuery.paddingOf(context).bottom;

    String two(int v) => v.toString().padLeft(2, '0');
    final notifyLabel = settings == null
        ? '-'
        : '${settings.notifyHour < 12 ? '오전' : '오후'} '
              '${settings.notifyHour % 12 == 0 ? 12 : settings.notifyHour % 12}:${two(settings.notifyMinute)}';
    final skipLabel = settings == null || settings.skipWeekdays.isEmpty
        ? '매일'
        : '제외: ${settings.skipWeekdays.map(_weekdayLabel).join(' ')}';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpace.screenH,
            AppSpace.lg,
            AppSpace.screenH,
            bottomPad,
          ),
          children: [
            Text('MY', style: AppText.headline.copyWith(color: c.textPrimary)),
            const SizedBox(height: AppSpace.section),

            // 통계 3칸
            AppCard(
              child: Row(
                children: [
                  _Stat(
                    value: stats?.wateringsThisMonth,
                    label: '이번 달\n물 준 횟수',
                  ),
                  _Divider(),
                  _Stat(value: stats?.diaryCount, label: '일기'),
                  _Divider(),
                  _Stat(value: stats?.streakDays, label: '연속 관리일'),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.section),

            Text('알림', style: AppText.label.copyWith(color: c.textSecondary)),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.notifications_outlined,
                    title: '알림 시간',
                    value: notifyLabel,
                    onTap: settings == null
                        ? null
                        : () => _pickTime(
                            context,
                            ref,
                            settings.notifyHour,
                            settings.notifyMinute,
                          ),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.schedule_outlined,
                    title: '알림 시점',
                    value: settings == null
                        ? '-'
                        : (settings.notifyDayBefore ? '하루 전' : '당일'),
                    onTap: settings == null
                        ? null
                        : () => ref
                              .read(settingsRepositoryProvider)
                              .setNotifyDayBefore(!settings.notifyDayBefore),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.pause_circle_outline_rounded,
                    title: '알림 잠시 멈추기',
                    value:
                        settings == null ||
                            !isNotifyPaused(settings, DateTime.now())
                        ? '꺼짐'
                        : '${settings.notifyPausedUntil!.month}월 ${settings.notifyPausedUntil!.day}일까지',
                    onTap: settings == null
                        ? null
                        : () => showPauseSheet(context, ref),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.event_busy_outlined,
                    title: '알림 요일',
                    value: skipLabel,
                    onTap: settings == null
                        ? null
                        : () => _pickWeekdays(
                            context,
                            ref,
                            settings.skipWeekdays,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.section),

            Text('데이터', style: AppText.label.copyWith(color: c.textSecondary)),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.save_alt_rounded,
                    title: '기록 내보내기·가져오기',
                    value: '파일',
                    onTap: () => context.push(AppRoutes.backup),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.add_circle_outline_rounded,
                    title: '품종 추가 요청',
                    value: '준비 중',
                    onTap: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.section),

            if (kDebugMode) ...[
              AppCard(
                padding: EdgeInsets.zero,
                child: _Row(
                  icon: Icons.bug_report_outlined,
                  title: '(개발용) 10초 뒤 알림',
                  value: '테스트',
                  onTap: () async {
                    final plants = await ref
                        .read(plantRepositoryProvider)
                        .getAll();
                    await ref
                        .read(notificationServiceProvider)
                        .scheduleDebug(plants: plants);
                  },
                ),
              ),
              const SizedBox(height: AppSpace.section),
            ],
            Text('정보', style: AppText.label.copyWith(color: c.textSecondary)),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.description_outlined,
                    title: '약관·개인정보 처리방침',
                    value: '준비 중',
                    onTap: null,
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.photo_outlined,
                    title: '도감 사진 출처',
                    value: '',
                    onTap: () => context.push(AppRoutes.photoCredits),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.mail_outline_rounded,
                    title: '문의',
                    value: '준비 중',
                    onTap: null,
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.info_outline_rounded,
                    title: '버전',
                    value: kAppVersion,
                    onTap: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              '기록은 이 기기에만 저장돼요. 폰 백업(구글·iCloud)에 기록이 포함되고, 사진까지 옮기려면 내보내기를 쓰세요',
              style: AppText.caption.copyWith(color: c.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static String _weekdayLabel(int w) =>
      const ['월', '화', '수', '목', '금', '토', '일'][w - 1];

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    int h,
    int m,
  ) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: h, minute: m),
      helpText: '물 주는 날 알림 시간',
    );
    if (t != null) {
      await ref
          .read(settingsRepositoryProvider)
          .setNotifyTime(t.hour, t.minute);
    }
  }

  Future<void> _pickWeekdays(
    BuildContext context,
    WidgetRef ref,
    List<int> current,
  ) async {
    final selected = {...current};
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.screenH,
            0,
            AppSpace.screenH,
            AppSpace.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '알림을 받지 않을 요일',
                style: AppText.title.copyWith(color: ctx.colors.textPrimary),
              ),
              const SizedBox(height: AppSpace.md),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  for (var w = 1; w <= 7; w++)
                    AppChip(
                      label: _weekdayLabel(w),
                      selected: selected.contains(w),
                      onTap: () => setState(() {
                        if (!selected.remove(w)) selected.add(w);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              AppButton.primary(
                label: '저장',
                onPressed: selected.length == 7
                    ? null
                    : () async {
                        await ref
                            .read(settingsRepositoryProvider)
                            .setSkipWeekdays(selected.toList()..sort());
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
              ),
              if (selected.length == 7)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpace.sm),
                  child: Text(
                    '모든 요일을 제외하면 알림이 오지 않아요',
                    style: AppText.caption.copyWith(color: ctx.colors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: Column(
        children: [
          Text(
            value?.toString() ?? '-',
            style: AppText.headline.copyWith(
              color: c.primary,
              fontFeatures: AppText.tabularFeatures,
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: AppSize.plantThumb,
    color: context.colors.outline,
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSize.icon,
              color: disabled ? c.textTertiary : c.textSecondary,
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Text(
                title,
                style: AppText.body.copyWith(
                  color: disabled ? c.textTertiary : c.textPrimary,
                ),
              ),
            ),
            Text(
              value,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
            if (!disabled) ...[
              const SizedBox(width: AppSpace.xs),
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
            ],
          ],
        ),
      ),
    );
  }
}
