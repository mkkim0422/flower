import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

class SpaceRepository {
  SpaceRepository(this.db);

  final AppDatabase db;

  Stream<List<Space>> watchAll() => (db.select(db.spaces)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.id)]))
      .watch();

  Future<List<Space>> getAll() => (db.select(db.spaces)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.id)]))
      .get();

  Future<Space?> byId(int id) =>
      (db.select(db.spaces)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 생성 → id 반환
  Future<int> create({
    required String name,
    required WindowDir windowDir,
    required WindowDist windowDist,
  }) async {
    final all = await getAll();
    return db.into(db.spaces).insert(
          SpacesCompanion.insert(
            name: name.trim(),
            windowDir: windowDir,
            windowDist: windowDist,
            sortOrder: Value(all.length),
          ),
        );
  }

  Future<void> update({
    required int id,
    required String name,
    required WindowDir windowDir,
    required WindowDist windowDist,
  }) =>
      (db.update(db.spaces)..where((t) => t.id.equals(id))).write(
        SpacesCompanion(
          name: Value(name.trim()),
          windowDir: Value(windowDir),
          windowDist: Value(windowDist),
        ),
      );

  /// 삭제. 소속 식물의 space_id는 FK로 null 처리됨.
  Future<void> delete(int id) =>
      (db.delete(db.spaces)..where((t) => t.id.equals(id))).go();
}

final spaceRepositoryProvider = Provider<SpaceRepository>(
  (ref) => SpaceRepository(ref.watch(databaseProvider)),
);

final spacesProvider = StreamProvider<List<Space>>(
  (ref) => ref.watch(spaceRepositoryProvider).watchAll(),
);
