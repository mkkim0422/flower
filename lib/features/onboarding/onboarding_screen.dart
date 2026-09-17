import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/notification_service.dart';

/// ONB-01 인트로 슬라이드 3장 + "시작하기". 로그인 없음.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  List<(IconData, String, String)> _slides(AppLocalizations l) => [
    (Icons.eco_outlined, l.onbSlide1Title, l.onbSlide1Body),
    (Icons.water_drop_outlined, l.onbSlide2Title, l.onbSlide2Body),
    (Icons.lock_outline_rounded, l.onbSlide3Title, l.onbSlide3Body),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final last = _page == _slides(context.l10n).length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides(context.l10n).length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final (icon, title, desc) = _slides(context.l10n)[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: AppSize.emptyIllustration,
                          color: c.primary,
                        ),
                        const SizedBox(height: AppSpace.xxl),
                        Text(
                          title,
                          style: AppText.headline.copyWith(
                            color: c.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpace.md),
                        Text(
                          desc,
                          style: AppText.body.copyWith(color: c.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides(context.l10n).length; i++)
                  Container(
                    width: i == _page ? AppSize.pageDotActive : AppSize.pageDot,
                    height: AppSize.pageDot,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
                    decoration: BoxDecoration(
                      color: i == _page ? c.primary : c.outline,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.screenH,
                AppSpace.xl,
                AppSpace.screenH,
                AppSpace.lg,
              ),
              child: AppButton.primary(
                label: last ? context.l10n.onbStart : context.l10n.commonNext,
                onPressed: () {
                  if (last) {
                    context.go(AppRoutes.onboardingPermission);
                  } else {
                    _controller.nextPage(
                      duration: AppMotion.bottomSheet,
                      curve: AppMotion.bottomSheetCurve,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ONB-02 권한 안내: 알림 권한만. 카메라 권한은 카메라 첫 사용 시.
class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _busy = false;

  Future<void> _finish({required bool askPermission}) async {
    if (_busy) return;
    setState(() => _busy = true);
    if (askPermission) {
      await ref.read(notificationServiceProvider).requestPermission();
    }
    await ref.read(settingsRepositoryProvider).setOnboardingDone(true);
    ref.read(onboardingDoneProvider.notifier).state = true;
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.notifications_active_outlined,
                size: AppSize.emptyIllustration,
                color: c.primary,
              ),
              const SizedBox(height: AppSpace.xxl),
              Text(
                context.l10n.onbPermTitle,
                style: AppText.headline.copyWith(color: c.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                context.l10n.onbPermBody,
                style: AppText.body.copyWith(color: c.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton.primary(
                label: context.l10n.onbPermAllow,
                onPressed: _busy ? null : () => _finish(askPermission: true),
              ),
              const SizedBox(height: AppSpace.sm),
              AppButton.text(
                label: context.l10n.commonLater,
                onPressed: _busy ? null : () => _finish(askPermission: false),
              ),
              const SizedBox(height: AppSpace.lg),
            ],
          ),
        ),
      ),
    );
  }
}
