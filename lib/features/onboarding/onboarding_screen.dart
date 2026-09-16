import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  static const _slides = [
    (
      Icons.eco_outlined,
      '내 식물, 잘 자라게',
      '이름을 검색하거나 사진을 찍어 등록하면\n환경에 맞는 물주기를 계산해 드려요',
    ),
    (
      Icons.water_drop_outlined,
      '물 주는 날을 놓치지 않게',
      '품종에 맞는 주기로 물 줄 날을 알려드리고,
"물 줬어요" 한 번이면 다음 날짜가 잡혀요',
    ),
    (
      Icons.lock_outline_rounded,
      '로그인 없이, 광고 없이',
      '기록은 기기에만 저장돼요.\n사진은 서버에 백업되지 않아요',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final last = _page == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final (icon, title, desc) = _slides[i];
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
                for (var i = 0; i < _slides.length; i++)
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
                label: last ? '시작하기' : '다음',
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
                '물 주는 날 알려드릴게요',
                style: AppText.headline.copyWith(color: c.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                '물 줄 날 오전 9시에 알려드려요.\n시간은 MY에서 바꿀 수 있어요',
                style: AppText.body.copyWith(color: c.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton.primary(
                label: '알림 허용',
                onPressed: _busy ? null : () => _finish(askPermission: true),
              ),
              const SizedBox(height: AppSpace.sm),
              AppButton.text(
                label: '나중에',
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
