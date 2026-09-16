import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/identification_service.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../remote/plantnet_client.dart';
import 'species_repository.dart';

/// 일 한도 카운터 + 식별 로그
class IdentificationRepository implements DailyQuota {
  IdentificationRepository(
    this.db, {
    DateTime Function()? clock,
    this.cap = kPlantNetDailyCap,
  }) : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final DateTime Function() _now;
  final int cap;

  static int dayKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  @override
  Future<bool> tryConsume() async {
    final s = await db.getSettings();
    final today = dayKey(_now());
    final count = s.plantnetDay == today ? s.plantnetCount : 0;
    if (count >= cap) return false;
    await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
      SettingsCompanion(
        plantnetDay: Value(today),
        plantnetCount: Value(count + 1),
      ),
    );
    return true;
  }

  Future<int> remainingToday() async {
    final s = await db.getSettings();
    final count = s.plantnetDay == dayKey(_now()) ? s.plantnetCount : 0;
    return (cap - count).clamp(0, cap);
  }

  /// 사용자 선택 저장 (5-2 ⑥). 사진은 로컬 경로만.
  Future<int> logSelection({
    required String localPhotoPath,
    required List<IdentificationCandidate> candidates,
    int? selectedSpeciesId,
  }) {
    return db
        .into(db.identificationLogs)
        .insert(
          IdentificationLogsCompanion.insert(
            localPhotoPath: localPhotoPath,
            candidatesJson: jsonEncode(
              candidates.map((c) => c.toJson()).toList(),
            ),
            userSelectedSpeciesId: Value(selectedSpeciesId),
            at: _now(),
          ),
        );
  }
}

/// 후보 학명 → species DB 매칭 (국내명 병기)
class SpeciesMatcher {
  const SpeciesMatcher(this.species);

  final SpeciesRepository species;

  Future<List<IdentificationCandidate>> attach(
    List<IdentificationCandidate> cs,
  ) async {
    final out = <IdentificationCandidate>[];
    for (final c in cs) {
      final row = await species.byNormalizedName(
        normalizeScientificName(c.scientificName),
      );
      out.add(
        row == null
            ? c
            : c.copyWith(speciesId: row.id, koName: row.koNames.first),
      );
    }
    return out;
  }
}

final identificationRepositoryProvider = Provider<IdentificationRepository>(
  (ref) => IdentificationRepository(ref.watch(databaseProvider)),
);

final identificationPipelineProvider = Provider<IdentificationPipeline>((ref) {
  return IdentificationPipeline(
    onDevice: OnDeviceIdentifier(),
    remote: PlantNetIdentifier(
      client: PlantNetClient(),
      quota: ref.watch(identificationRepositoryProvider),
    ),
  );
});

/// 사진 경로 → 식별 결과 (species 매칭 포함). CAM-02/03/04 가 watch.
final identifyPhotoProvider = FutureProvider.autoDispose
    .family<IdentificationOutcome, String>((ref, path) async {
      final bytes = await File(path).readAsBytes();
      final outcome = await ref
          .watch(identificationPipelineProvider)
          .run(bytes);
      if (outcome is IdentificationSuccess) {
        final matcher = SpeciesMatcher(ref.watch(speciesRepositoryProvider));
        return outcome.withCandidates(await matcher.attach(outcome.candidates));
      }
      return outcome;
    });
