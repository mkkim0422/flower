import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/camera/camera_screen.dart';
import '../features/home/home_screen.dart';
import '../features/my/my_screen.dart';
import 'tab_scaffold.dart';

/// 경로 상수. 화면ID(HANDOFF 3-2)와 1:1 대응.
class AppRoutes {
  AppRoutes._();

  static const home = '/home'; // HOME-01
  static const camera = '/camera'; // CAM-01
  static const my = '/my'; // MY-01
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// 3탭 StatefulShellRoute. 탭별 내비게이션 스택 유지.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          TabScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.camera,
              builder: (context, state) => const CameraScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.my,
              builder: (context, state) => const MyScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
