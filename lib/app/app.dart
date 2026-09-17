import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_locale.dart';
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
  bool _refreshing = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // 포그라운드 진입마다 주기 재계산 + 알림 재예약 (HANDOFF 5-3)
    _lifecycle = AppLifecycleListener(onResume: _onForeground);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onForeground());
  }

  /// 재계산은 포그라운드 진입 시에만, 알림 재예약은 데이터 변경 시에도
  Future<void> _onForeground() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      ref.read(speciesSeedProvider); // 시드 로드 트리거
      await ref.read(plantRepositoryProvider).recalcAll();
      await _rescheduleNotifications();
    } catch (e) {
      debugPrint('foreground refresh failed: $e');
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _rescheduleNotifications() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    final plants = await ref.read(plantRepositoryProvider).getAll();
    await ref
        .read(notificationServiceProvider)
        .reschedule(settings: settings, plants: plants);
  }

  void _scheduleDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _rescheduleNotifications().catchError((Object e) {
        debugPrint('reschedule failed: $e');
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 식물·설정이 바뀌면(흙 확인, 등록, 삭제, 알림 시간 변경) 알림 재예약
    ref.listen(plantsProvider, (_, _) => _scheduleDebounced());
    ref.listen(settingsProvider, (_, _) => _scheduleDebounced());

    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      onGenerateTitle: (ctx) => ctx.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      // 기기 언어를 따른다. 한국어 외에는 영어로 보인다
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (device, _) => resolveAppLocale(device),
      routerConfig: router,
    );
  }
}
