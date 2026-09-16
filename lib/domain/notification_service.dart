// 로컬 알림 (HANDOFF 5-3). 매일 notify_hour에 1건: "오늘 확인할 식물이 N개 있어요"
// 백그라운드 서비스 없음. 앱이 포그라운드로 올 때마다 재계산·재예약.
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/db/app_database.dart';
import '../data/repositories/plant_repository.dart';
import '../domain/watering_rules.dart';

const int kDailyCheckNotificationId = 1;
const String _channelId = 'daily_check';
const String _channelName = '흙 확인 알림';
const String _channelDesc = '매일 정해진 시간에 확인할 식물 수를 알려드려요';

class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: ios),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('notification init failed: $e');
    }
  }

  /// ONB-02: 알림 권한 요청 (사용 시점에 요청)
  Future<bool> requestPermission() async {
    await init();
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
            false;
      }
    } catch (e) {
      debugPrint('notification permission failed: $e');
    }
    return false;
  }

  /// 다음 알림 시각 계산 (오늘 notify 시각이 지났으면 내일). 제외 요일은 건너뜀.
  @visibleForTesting
  static DateTime nextFireTime(Setting s, DateTime now) {
    var candidate = DateTime(now.year, now.month, now.day, s.notifyHour, s.notifyMinute);
    if (!candidate.isAfter(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    var guard = 0;
    while (s.skipWeekdays.contains(candidate.weekday) && guard < 7) {
      candidate = candidate.add(const Duration(days: 1));
      guard++;
    }
    return candidate;
  }

  /// 알림 시각 기준으로 확인 대상 식물 수
  @visibleForTesting
  static int dueCountAt(List<PlantEntry> plants, DateTime at) =>
      plants.where((e) => isDueToday(e.plant.nextCheckAt, at)).length;

  /// 다음 알림 1건 예약. 대상 0개면 취소.
  Future<void> reschedule({
    required Setting settings,
    required List<PlantEntry> plants,
    DateTime? now,
  }) async {
    await init();
    if (!_initialized) return;
    final at = nextFireTime(settings, now ?? DateTime.now());
    final count = dueCountAt(plants, at);
    try {
      await _plugin.cancel(id: kDailyCheckNotificationId);
      if (count == 0) return;
      await _plugin.zonedSchedule(
        id: kDailyCheckNotificationId,
        title: '잘자라라',
        body: '오늘 확인할 식물이 $count개 있어요',
        // 절대 시각을 UTC로 변환: 로컬 타임존 DB 없이도 정확
        scheduledDate: tz.TZDateTime.from(at, tz.UTC),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('notification schedule failed: $e');
    }
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());
