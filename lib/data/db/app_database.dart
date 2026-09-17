import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Species,
    Spaces,
    Plants,
    CareEvents,
    DiaryEntries,
    IdentificationLogs,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// 테스트용 인메모리 DB
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // 설정 단일 행 생성
      await into(settings).insert(
        const SettingsCompanion(id: Value(1)),
        mode: InsertMode.insertOrIgnore,
      );
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(settings, settings.plantnetDay);
        await m.addColumn(settings, settings.plantnetCount);
      }
      if (from < 3) {
        await m.addColumn(settings, settings.homeGrid);
      }
      if (from < 4) {
        await m.addColumn(plants, plants.memo);
      }
      if (from < 5) {
        await m.addColumn(settings, settings.notifyDayBefore);
      }
      if (from < 6) {
        await m.addColumn(settings, settings.themeVariant);
      }
      if (from < 7) {
        await m.addColumn(species, species.tempOptMin);
        await m.addColumn(species, species.tempOptMax);
        await m.addColumn(species, species.toxicChildLevel);
        await m.addColumn(species, species.toxicityNote);
      }
      if (from < 8) {
        await m.addColumn(species, species.toxicSevere);
      }
      if (from < 9) {
        await m.addColumn(species, species.imageUrl);
        await m.addColumn(species, species.imageAuthor);
        await m.addColumn(species, species.imageLicense);
        await m.addColumn(species, species.imagePage);
        await m.addColumn(settings, settings.notifyPausedUntil);
      }
      if (from < 10) {
        await m.addColumn(species, species.namesEn);
        await m.addColumn(species, species.toxicityNoteEn);
        await m.addColumn(species, species.commonIssuesEn);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'plant_app',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
        // 알림 버튼(백그라운드 isolate)에서 쓴 기록이 앱 화면에 바로 반영되도록
        shareAcrossIsolates: true,
      ),
    );
  }

  /// 설정 단일 행 조회(없으면 기본값으로 생성)
  Future<Setting> getSettings() async {
    final row = await (select(
      settings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row != null) return row;
    await into(settings).insert(const SettingsCompanion(id: Value(1)));
    return (select(settings)..where((t) => t.id.equals(1))).getSingle();
  }
}
