import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';

class SettingsRepository {
  SettingsRepository(this.db);

  final AppDatabase db;

  Stream<Setting> watch() =>
      (db.select(db.settings)..where((t) => t.id.equals(1)))
          .watchSingleOrNull()
          .asyncMap((s) async => s ?? await db.getSettings());

  Future<Setting> get() => db.getSettings();

  Future<void> setOnboardingDone(bool done) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(onboardingDone: Value(done)),
    );
  }

  Future<void> setNotifyTime(int hour, int minute) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(notifyHour: Value(hour), notifyMinute: Value(minute)),
    );
  }

  Future<void> setNotifyDayBefore(bool dayBefore) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(notifyDayBefore: Value(dayBefore)),
    );
  }

  /// 알림 잠시 멈추기. null 이면 다시 켬
  Future<void> setNotifyPausedUntil(DateTime? until) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(
        notifyPausedUntil: Value(
          until == null ? null : DateTime(until.year, until.month, until.day),
        ),
      ),
    );
  }

  Future<void> setHomeGrid(bool grid) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(homeGrid: Value(grid)),
    );
  }

  Future<void> setSkipWeekdays(List<int> weekdays) async {
    await db.getSettings();
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(skipWeekdays: Value(weekdays)),
    );
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final settingsProvider = StreamProvider<Setting>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// 온보딩 완료 여부. main()에서 DB 값으로 override 되고, ONB-02 완료 시 true.
final onboardingDoneProvider = StateProvider<bool>((ref) => false);
