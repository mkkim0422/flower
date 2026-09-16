import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';

class SpeciesRepository {
  SpeciesRepository(this.db);

  final AppDatabase db;

  /// 국내명·학명 동시 검색 (ADD-02). 빈 질의는 빈 목록.
  Future<List<SpeciesRow>> search(String query, {int limit = 30}) async {
    final q = query.trim().toLowerCase().replaceAll(RegExp('[%_]'), '');
    if (q.isEmpty) return const [];
    final compact = q.replaceAll(' ', '');
    final rows =
        await (db.select(db.species)
              ..where(
                (t) =>
                    t.searchText.like('%$q%') | t.searchText.like('%$compact%'),
              )
              ..limit(limit * 2))
            .get();
    // 정렬: 국내명 첫 항목이 접두 일치 > 국내명 포함 > 학명 포함
    int rank(SpeciesRow r) {
      final first = r.koNames.isEmpty ? '' : r.koNames.first.toLowerCase();
      if (first.startsWith(q)) return 0;
      if (r.koNames.any((n) => n.toLowerCase().contains(q))) return 1;
      return 2;
    }

    rows.sort((a, b) {
      final c = rank(a).compareTo(rank(b));
      return c != 0 ? c : a.koNames.first.compareTo(b.koNames.first);
    });
    return rows.take(limit).toList();
  }

  Future<SpeciesRow?> byId(int id) =>
      (db.select(db.species)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<SpeciesRow?> byScientificName(String name) =>
      (db.select(db.species)
            ..where((t) => t.scientificName.lower().equals(name.toLowerCase())))
          .getSingleOrNull();

  /// 정규화 학명("genus species", 소문자)으로 매칭. 품종·저자명 무시.
  Future<SpeciesRow?> byNormalizedName(String normalized) async {
    if (normalized.isEmpty) return null;
    final exact =
        await (db.select(db.species)
              ..where((t) => t.scientificName.lower().equals(normalized)))
            .getSingleOrNull();
    if (exact != null) return exact;
    // "Genus species 'Cultivar'" 형태의 행도 잡히도록 접두 일치
    final rows =
        await (db.select(db.species)
              ..where((t) => t.scientificName.lower().like('$normalized %'))
              ..limit(1))
            .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> count() async {
    final c = db.species.id.count();
    return (db.selectOnly(
      db.species,
    )..addColumns([c])).map((r) => r.read(c) ?? 0).getSingle();
  }
}

final speciesRepositoryProvider = Provider<SpeciesRepository>(
  (ref) => SpeciesRepository(ref.watch(databaseProvider)),
);

/// 검색 결과 (질의 문자열별 캐시)
final speciesSearchProvider = FutureProvider.autoDispose
    .family<List<SpeciesRow>, String>((ref, query) {
      return ref.watch(speciesRepositoryProvider).search(query);
    });

final speciesByIdProvider = FutureProvider.autoDispose.family<SpeciesRow?, int>(
  (ref, id) {
    return ref.watch(speciesRepositoryProvider).byId(id);
  },
);
