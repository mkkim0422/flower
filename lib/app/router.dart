import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/settings_repository.dart';
import '../features/add_plant/add_method_screen.dart';
import '../features/add_plant/add_plant_draft.dart';
import '../features/add_plant/manual_input_screen.dart';
import '../features/add_plant/plant_env_screen.dart';
import '../features/add_plant/species_search_screen.dart';
import '../features/camera/camera_screen.dart';
import '../features/home/home_screen.dart';
import '../features/my/my_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/plant_detail/plant_detail_screen.dart';
import '../features/spaces/space_edit_screen.dart';
import 'tab_scaffold.dart';

/// 경로 상수. 화면ID(HANDOFF 3-2)와 1:1 대응.
class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding'; // ONB-01
  static const onboardingPermission = '/onboarding/permission'; // ONB-02
  static const home = '/home'; // HOME-01
  static const camera = '/camera'; // CAM-01
  static const my = '/my'; // MY-01
  static const add = '/add'; // ADD-01
  static const addSearch = '/add/search'; // ADD-02
  static const addManual = '/add/manual'; // ADD-03
  static const addEnv = '/add/env'; // ADD-04
  static const spaceNew = '/spaces/new'; // SPC-02
  static String plant(int id) => '/home/plant/$id'; // PLT-01
  static String spaceEdit(int id) => '/spaces/$id'; // SPC-02
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// 온보딩 완료 여부에 따라 리다이렉트하는 라우터
final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingDone = ValueNotifier<bool>(ref.read(onboardingDoneProvider));
  ref.listen(onboardingDoneProvider, (_, v) => onboardingDone.value = v);
  ref.onDispose(onboardingDone.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    refreshListenable: onboardingDone,
    redirect: (context, state) {
      final inOnboarding = state.matchedLocation.startsWith(AppRoutes.onboarding);
      if (!onboardingDone.value && !inOnboarding) return AppRoutes.onboarding;
      if (onboardingDone.value && inOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: 'permission',
            builder: (_, _) => const PermissionScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => TabScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'plant/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => PlantDetailScreen(
                      plantId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.camera, builder: (_, _) => const CameraScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.my, builder: (_, _) => const MyScreen()),
            ],
          ),
        ],
      ),
      // 등록 플로우: 탭바 위 전체 화면
      GoRoute(
        path: AppRoutes.add,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const AddMethodScreen(),
        routes: [
          GoRoute(
            path: 'search',
            parentNavigatorKey: _rootKey,
            builder: (_, _) => const SpeciesSearchScreen(),
          ),
          GoRoute(
            path: 'manual',
            parentNavigatorKey: _rootKey,
            builder: (_, state) => ManualInputScreen(draft: state.extra as AddPlantDraft?),
          ),
          GoRoute(
            path: 'env',
            parentNavigatorKey: _rootKey,
            builder: (_, state) => PlantEnvScreen(
              draft: (state.extra as AddPlantDraft?) ?? const AddPlantDraft(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.spaceNew,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const SpaceEditScreen(),
      ),
      GoRoute(
        path: '/spaces/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            SpaceEditScreen(spaceId: int.parse(state.pathParameters['id']!)),
      ),
    ],
  );
});
