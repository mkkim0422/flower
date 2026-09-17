import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_locale.dart';

import 'theme.dart';

/// 하단 탭 3개: 홈 · (카메라: 중앙 원형 강조) · MY  (DESIGN.md 3·5장)
class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: _AppTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }
}

class _AppTabBar extends StatelessWidget {
  const _AppTabBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: AppSize.tabBarHeight + bottomInset + AppSize.cameraButtonOverlap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 탭바 본체
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: AppSize.tabBarHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.outline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabItem(
                      label: context.l10n.tabHome,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      selected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  // 중앙 카메라 버튼 자리
                  const SizedBox(width: AppSize.cameraButton + AppSpace.lg),
                  Expanded(
                    child: _TabItem(
                      label: context.l10n.tabMy,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      selected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 중앙 카메라 버튼: 지름 56, 탭바 위로 12 돌출
          Positioned(
            bottom:
                bottomInset +
                AppSize.tabBarHeight -
                AppSize.cameraButton +
                AppSize.cameraButtonOverlap,
            child: _CameraButton(
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.textTertiary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              size: AppSize.tabIcon,
              color: color,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(label, style: AppText.label.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.tabCamera,
      child: Material(
        color: c.primary,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: AppSize.cameraButton,
            height: AppSize.cameraButton,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppShadow.cameraButton,
            ),
            child: Icon(
              Icons.photo_camera_rounded,
              size: AppSize.tabIcon,
              color: c.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
