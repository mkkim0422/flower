// 로컬 알림 (HANDOFF 5-3). 매일 notify_hour에 1건: "오늘 확인할 식물이 N개 있어요"
// 백그라운드 서비스 없음. 앱이 포그라운드로 오거나 식물 데이터가 바뀔 때마다
// 앞으로 [kScheduleDays]일치를 다시 예약한다 (앱을 며칠 안 열어도 알림이 끊기지 않게).
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/db/app_database.dart';
import '../data/repositories/plant_repository.dart';
import '../domain/watering_rules.dart';

/// 미리 예약해 두는 일수 (알림 id = 1..kScheduleDays)
const int kScheduleDays = 7;
const String _channelId = 'daily_check';
const String _channelName = '물 주기 알림';
const String _channelDesc = '매일 정해진 시간에 물 줄 식물 수를 알려드려요';

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
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (e) {
      debugPrint('notification permission failed: $e');
    }
    return false;
  }

  static DateTime _atNotifyTime(Setting s, DateTime day) =>
      DateTime(day.year, day.month, day.day, s.notifyHour, s.notifyMinute);

  /// 다음 알림 시각 (오늘 notify 시각이 지났으면 내일). 제외 요일은 건너뜀.
  /// 모든 요일이 제외되면 null.
  @visibleForTesting
  static DateTime? nextFireTime(Setting s, DateTime now) {
    if (s.skipWeekdays.toSet().length >= 7) return null;
    var candidate = _atNotifyTime(s, now);
    if (!candidate.isAfter(now)) {
      candidate = _atNotifyTime(s, DateTime(now.year, now.month, now.day + 1));
    }
    var guard = 0;
    while (s.skipWeekdays.contains(candidate.weekday) && guard < 7) {
      candidate = _atNotifyTime(
        s,
        DateTime(candidate.year, candidate.month, candidate.day + 1),
      );
      guard++;
    }
    return candidate;
  }

  /// 앞으로 [count]개의 알림 시각 (제외 요일 건너뜀)
  @visibleForTesting
  static List<DateTime> fireTimes(
    Setting s,
    DateTime now, {
    int count = kScheduleDays,
  }) {
    final out = <DateTime>[];
    var cursor = now;
    while (out.length < count) {
      final next = nextFireTime(s, cursor);
      if (next == null) break;
      out.add(next);
      cursor = next;
    }
    return out;
  }

  /// 알림 시각 기준으로 확인 대상 식물 수
  @visibleForTesting
  static int dueCountAt(List<PlantEntry> plants, DateTime at) =>
      plants.where((e) => isDueToday(e.plant.nextCheckAt, at)).length;

  /// 앞으로 7일치 예약. 각 날짜에 대상이 0개면 그 날은 예약하지 않음.
  Future<void> reschedule({
    required Setting settings,
    required List<PlantEntry> plants,
    DateTime? now,
  }) async {
    await init();
    if (!_initialized) return;
    final times = fireTimes(settings, now ?? DateTime.now());
    try {
      for (var i = 1; i <= kScheduleDays; i++) {
        await _plugin.cancel(id: i);
      }
      for (var i = 0; i < times.length; i++) {
        final at = times[i];
        final count = dueCountAt(plants, at);
        if (count == 0) continue;
        await _plugin.zonedSchedule(
          id: i + 1,
          title: '잘자라라',
          body: '오늘 물 줄 식물이 $count개 있어요',
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
      }
    } catch (e) {
      debugPrint('notification schedule failed: $e');
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
