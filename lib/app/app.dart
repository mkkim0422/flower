import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/plant_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/seed/species_seed.dart';
import '../domain/notification_service.dart';
import 'router.dart';
import 'theme.dart';

class PlantApp extends ConsumerStatefulWidget {
  const PlantApp({super.key});

  @override
  ConsumerState<PlantApp> createState() => _PlantAppState();
}

class _PlantAppState extends ConsumerState<PlantApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // 포그라운드 진입마다 주기 재계산 + 알림 재예약 (HANDOFF 5-3)
    _lifecycle = AppLifecycleListener(onResume: _onForeground);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onForeground());
  }

  Future<void> _onForeground() async {
    try {
      ref.read(speciesSeedProvider); // 시드 로드 트리거
      final plantsRepo = ref.read(plantRepositoryProvider);
      await plantsRepo.recalcAll();
      final settings = await ref.read(settingsRepositoryProvider).get();
      final plants = await plantsRepo.watchAll().first;
      await ref
          .read(notificationServiceProvider)
          .reschedule(settings: settings, plants: plants);
    } catch (e) {
      debugPrint('foreground refresh failed: $e');
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '잘자라라',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
