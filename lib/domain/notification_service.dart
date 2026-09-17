// 로컬 알림 (HANDOFF 5-3 + 2026-09-17 사용자 승인 기능 1)
// - 매일 설정 시각에 1건. 본문에 물 줄 식물 이름을 넣는다.
// - 알림 버튼: "물 줬어요" / "내일 할게요" (하루 전 알림은 "오늘 미리 줬어요" 하나).
//   버튼은 앱을 열지 않고 백그라운드에서 기록한 뒤 알림을 다시 예약한다.
// - 백그라운드 서비스 없음. 앱 포그라운드·데이터 변경 때마다 앞으로 [kScheduleDays]일치를 예약한다.
import 'dart:convert';
import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/db/app_database.dart';
import '../data/repositories/plant_repository.dart';
import '../domain/watering_rules.dart';

/// 미리 예약해 두는 일수 (알림 id = 1..kScheduleDays)
const int kScheduleDays = 7;

/// 개발용 즉시 테스트 알림 id
const int kDebugNotificationId = 99;

const String kActionWatered = 'water_done';
const String kActionSnooze = 'snooze_tomorrow';
const String _categoryToday = 'water_today';
const String _categoryDayBefore = 'water_day_before';

const String _channelId = 'daily_check';
const String _channelName = '물 주기 알림';
const String _channelDesc = '물 줄 날에 식물 이름과 함께 알려드려요';

/// 예약할 알림 한 건 (순수 데이터, 테스트 대상)
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.fireAt,
    required this.body,
    required this.plantIds,
    required this.dayBefore,
  });

  final int id;
  final DateTime fireAt;
  final String body;
  final List<int> plantIds;
  final bool dayBefore;

  String get payload => jsonEncode({'ids': plantIds});
}

/// 멈춤이 오늘 이후까지 유효한지
bool isNotifyPaused(Setting s, DateTime now) {
  final p = s.notifyPausedUntil;
  if (p == null) return false;
  return !DateTime(
    now.year,
    now.month,
    now.day,
  ).isAfter(DateTime(p.year, p.month, p.day));
}

/// 알림 payload → 식물 id 목록
List<int> plantIdsFromPayload(String? payload) {
  if (payload == null || payload.isEmpty) return const [];
  try {
    final m = jsonDecode(payload) as Map<String, dynamic>;
    return ((m['ids'] as List?) ?? const []).cast<int>();
  } catch (_) {
    return const [];
  }
}

class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  /// [onForegroundAction]: 앱이 켜져 있을 때 버튼을 누르면 호출 (메인 DB 사용)
  Future<void> init({
    Future<void> Function(NotificationResponse response)? onForegroundAction,
  }) async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          _categoryToday,
          actions: [
            DarwinNotificationAction.plain(kActionWatered, '물 줬어요'),
            DarwinNotificationAction.plain(kActionSnooze, '내일 할게요'),
          ],
        ),
        DarwinNotificationCategory(
          _categoryDayBefore,
          actions: [
            DarwinNotificationAction.plain(kActionWatered, '오늘 미리 줬어요'),
          ],
        ),
      ],
    );
    try {
      await _plugin.initialize(
        settings: InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: onForegroundAction,
        onDidReceiveBackgroundNotificationResponse:
            notificationActionBackground,
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

  /// 알림이 가리키는 날: 당일 알림이면 그날, 하루 전 알림이면 다음 날
  @visibleForTesting
  static DateTime targetDay(DateTime fireAt, {required bool dayBefore}) =>
      dayBefore
      ? DateTime(
          fireAt.year,
          fireAt.month,
          fireAt.day + 1,
          fireAt.hour,
          fireAt.minute,
        )
      : fireAt;

  /// 이름으로 본문 만들기.
  /// 1개: "몬스테라 물 줄 날이에요" / 2~3개: "A·B·C 물 줄 날이에요" / 4개+: "A·B 외 2개 물 줄 날이에요"
  /// 하루 전이면 앞에 "내일은 "을 붙인다.
  @visibleForTesting
  static String bodyForNames(List<String> names, {required bool dayBefore}) {
    final String who;
    if (names.length <= 3) {
      who = names.join('·');
    } else {
      who = '${names.take(2).join('·')} 외 ${names.length - 2}개';
    }
    return '${dayBefore ? '내일은 ' : ''}$who 물 줄 날이에요';
  }

  /// 예약 계획 (순수 함수)
  @visibleForTesting
  static List<PlannedReminder> plan({
    required Setting settings,
    required List<PlantEntry> plants,
    required DateTime now,
  }) {
    final out = <PlannedReminder>[];
    final times = fireTimes(settings, now);
    final paused = settings.notifyPausedUntil;
    for (var i = 0; i < times.length; i++) {
      final at = times[i];
      // 알림 멈춤 기간(마지막 날 포함)에는 예약하지 않는다
      if (paused != null &&
          !DateTime(
            at.year,
            at.month,
            at.day,
          ).isAfter(DateTime(paused.year, paused.month, paused.day))) {
        continue;
      }
      final target = targetDay(at, dayBefore: settings.notifyDayBefore);
      final due = plants
          .where((e) => isDueToday(e.plant.nextCheckAt, target))
          .toList();
      if (due.isEmpty) continue;
      out.add(
        PlannedReminder(
          id: i + 1,
          fireAt: at,
          body: bodyForNames(
            due.map((e) => e.plant.nickname).toList(),
            dayBefore: settings.notifyDayBefore,
          ),
          plantIds: due.map((e) => e.plant.id).toList(),
          dayBefore: settings.notifyDayBefore,
        ),
      );
    }
    return out;
  }

  NotificationDetails _details({required bool dayBefore}) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          actions: dayBefore
              ? const [AndroidNotificationAction(kActionWatered, '오늘 미리 줬어요')]
              : const [
                  AndroidNotificationAction(kActionWatered, '물 줬어요'),
                  AndroidNotificationAction(kActionSnooze, '내일 할게요'),
                ],
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: dayBefore ? _categoryDayBefore : _categoryToday,
        ),
      );

  /// 앞으로 7일치 예약. 각 날짜에 대상이 0개면 그 날은 예약하지 않음.
  Future<void> reschedule({
    required Setting settings,
    required List<PlantEntry> plants,
    DateTime? now,
  }) async {
    await init();
    if (!_initialized) return;
    try {
      for (var i = 1; i <= kScheduleDays; i++) {
        await _plugin.cancel(id: i);
      }
      for (final r in plan(
        settings: settings,
        plants: plants,
        now: now ?? DateTime.now(),
      )) {
        await _plugin.zonedSchedule(
          id: r.id,
          title: '잘자라라',
          body: r.body,
          payload: r.payload,
          // 절대 시각을 UTC로 변환: 로컬 타임존 DB 없이도 정확
          scheduledDate: tz.TZDateTime.from(r.fireAt, tz.UTC),
          notificationDetails: _details(dayBefore: r.dayBefore),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('notification schedule failed: $e');
    }
  }

  /// 개발용: 지금 물 줄 식물(없으면 전체)로 [delay] 뒤 알림 1건
  Future<void> scheduleDebug({
    required List<PlantEntry> plants,
    Duration delay = const Duration(seconds: 10),
  }) async {
    await init();
    final now = DateTime.now();
    final due = plants.where((e) => e.isDue(now)).toList();
    final target = due.isEmpty ? plants : due;
    if (target.isEmpty) return;
    await _plugin.zonedSchedule(
      id: kDebugNotificationId,
      title: '잘자라라',
      body: bodyForNames(
        target.map((e) => e.plant.nickname).toList(),
        dayBefore: false,
      ),
      payload: jsonEncode({'ids': target.map((e) => e.plant.id).toList()}),
      scheduledDate: tz.TZDateTime.from(now.add(delay), tz.UTC),
      notificationDetails: _details(dayBefore: false),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}

/// 알림 버튼 처리 (순수 로직, 테스트 대상). 처리한 식물 수 반환.
Future<int> applyNotificationAction({
  required PlantRepository repo,
  required String actionId,
  required List<int> plantIds,
  DateTime? now,
}) async {
  final at = now ?? DateTime.now();
  var handled = 0;
  for (final id in plantIds) {
    final e = await repo.getById(id);
    if (e == null) continue;
    switch (actionId) {
      case kActionWatered:
        // 같은 날 중복은 저장소에서 무시됨
        await repo.recordSoilCheck(id, SoilCheckResult.dry, at: at);
        handled++;
      case kActionSnooze:
        if (e.isDue(at)) {
          await repo.snoozeToTomorrow(id, at: at);
          handled++;
        }
    }
  }
  return handled;
}

/// 버튼 처리 + 재예약 (앱이 켜져 있으면 메인 DB, 아니면 백그라운드에서 연 DB)
Future<void> handleNotificationResponse(
  NotificationResponse response, {
  required AppDatabase db,
  required NotificationService service,
}) async {
  final action = response.actionId;
  if (action == null || action.isEmpty) return; // 본문 탭은 앱 열기만
  final repo = PlantRepository(db);
  await applyNotificationAction(
    repo: repo,
    actionId: action,
    plantIds: plantIdsFromPayload(response.payload),
  );
  await service.reschedule(
    settings: await db.getSettings(),
    plants: await repo.getAll(),
  );
}

/// 앱이 꺼져 있거나 백그라운드일 때 버튼 처리 (별도 isolate)
@pragma('vm:entry-point')
Future<void> notificationActionBackground(NotificationResponse response) async {
  final action = response.actionId;
  if (action == null || action.isEmpty) return;
  AppDatabase? db;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    db = AppDatabase();
    await handleNotificationResponse(
      response,
      db: db,
      service: NotificationService(),
    );
  } catch (e) {
    debugPrint('notification background action failed: $e');
  } finally {
    await db?.close();
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
