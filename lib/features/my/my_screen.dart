import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/app_locale.dart';
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

    final l = context.l10n;
    final notifyLabel = settings == null
        ? '-'
        : TimeOfDay(
            hour: settings.notifyHour,
            minute: settings.notifyMinute,
          ).format(context);
    final skipLabel = settings == null || settings.skipWeekdays.isEmpty
        ? l.myEveryDay
        : l.mySkipDays(
            settings.skipWeekdays
                .map((w) => _weekdayLabel(w, l.localeName))
                .join(' '),
          );

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
            Text(
              l.myTitle,
              style: AppText.headline.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: AppSpace.section),

            // 통계 3칸
            AppCard(
              child: Row(
                children: [
                  _Stat(
                    value: stats?.wateringsThisMonth,
                    label: l.myStatWaterings,
                  ),
                  _Divider(),
                  _Stat(value: stats?.diaryCount, label: l.myStatDiary),
                  _Divider(),
                  _Stat(value: stats?.streakDays, label: l.myStatStreak),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.section),

            Text(
              l.mySectionNotifications,
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.notifications_outlined,
                    title: l.myNotifyTime,
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
                    title: l.myNotifyTiming,
                    value: settings == null
                        ? '-'
                        : (settings.notifyDayBefore
                              ? l.myNotifyDayBefore
                              : l.myNotifySameDay),
                    onTap: settings == null
                        ? null
                        : () => ref
                              .read(settingsRepositoryProvider)
                              .setNotifyDayBefore(!settings.notifyDayBefore),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.pause_circle_outline_rounded,
                    title: l.myPause,
                    value:
                        settings == null ||
                            !isNotifyPaused(settings, DateTime.now())
                        ? l.myPauseOff
                        : l.myPauseUntil(
                            DateFormat.MMMd(
                              l.localeName,
                            ).format(settings.notifyPausedUntil!),
                          ),
                    onTap: settings == null
                        ? null
                        : () => showPauseSheet(context, ref),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.event_busy_outlined,
                    title: l.myNotifyDays,
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

            Text(
              l.mySectionData,
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.save_alt_rounded,
                    title: l.myBackup,
                    value: l.myBackupValue,
                    onTap: () => context.push(AppRoutes.backup),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.add_circle_outline_rounded,
                    title: l.myRequestSpecies,
                    value: l.commonComingSoon,
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
                  title: l.myDebugNotify,
                  value: l.myDebugTest,
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
            Text(
              l.mySectionInfo,
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Icons.description_outlined,
                    title: l.myTermsPrivacy,
                    value: l.commonComingSoon,
                    onTap: null,
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.photo_outlined,
                    title: l.myPhotoCredits,
                    value: '',
                    onTap: () => context.push(AppRoutes.photoCredits),
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.mail_outline_rounded,
                    title: l.myContact,
                    value: l.commonComingSoon,
                    onTap: null,
                  ),
                  const Divider(),
                  _Row(
                    icon: Icons.info_outline_rounded,
                    title: l.myVersion,
                    value: kAppVersion,
                    onTap: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              l.myLocalOnly,
              style: AppText.caption.copyWith(color: c.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 요일 짧은 이름 (월=1 … 일=7), 언어별
  static String _weekdayLabel(int w, String locale) =>
      DateFormat.E(locale).format(DateTime(2024, 1, w)); // 2024-01-01 은 월요일

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    int h,
    int m,
  ) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: h, minute: m),
      helpText: context.l10n.myNotifyTimeHelp,
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
                ctx.l10n.mySkipDaysTitle,
                style: AppText.title.copyWith(color: ctx.colors.textPrimary),
              ),
              const SizedBox(height: AppSpace.md),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  for (var w = 1; w <= 7; w++)
                    AppChip(
                      label: _weekdayLabel(w, ctx.l10n.localeName),
                      selected: selected.contains(w),
                      onTap: () => setState(() {
                        if (!selected.remove(w)) selected.add(w);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              AppButton.primary(
                label: ctx.l10n.commonSave,
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
                    ctx.l10n.mySkipAllWarning,
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
