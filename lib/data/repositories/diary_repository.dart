import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';

/// 생장 일기 (DIA-01). 사진은 로컬 경로만.
class DiaryRepository {
  DiaryRepository(this.db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final DateTime Function() _now;

  Stream<List<DiaryEntry>> watchByPlant(int plantId, {int? limit}) {
    final q = db.select(db.diaryEntries)
      ..where((t) => t.plantId.equals(plantId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.at),
        (t) => OrderingTerm.desc(t.id),
      ]);
    if (limit != null) q.limit(limit);
    return q.watch();
  }

  Future<List<DiaryEntry>> getAll() => (db.select(
    db.diaryEntries,
  )..orderBy([(t) => OrderingTerm.desc(t.at)])).get();

  Future<int> add({
    required int plantId,
    String? photoPath,
    String? memo,
    List<DiaryTag> tags = const [],
    DateTime? at,
  }) {
    final m = memo?.trim();
    return db
        .into(db.diaryEntries)
        .insert(
          DiaryEntriesCompanion.insert(
            plantId: plantId,
            photoPath: Value(photoPath),
            memo: Value(m == null || m.isEmpty ? null : m),
            tags: Value(tags),
            at: at ?? _now(),
          ),
        );
  }

  Future<void> delete(int id) =>
      (db.delete(db.diaryEntries)..where((t) => t.id.equals(id))).go();
}

final diaryRepositoryProvider = Provider<DiaryRepository>(
  (ref) => DiaryRepository(ref.watch(databaseProvider)),
);

final diaryByPlantProvider = StreamProvider.autoDispose
    .family<List<DiaryEntry>, int>(
      (ref, plantId) =>
          ref.watch(diaryRepositoryProvider).watchByPlant(plantId),
    );
