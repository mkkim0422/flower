// 기록 내보내기·가져오기 (로그인 없음). 기록 JSON + 사진을 zip 하나로.
// 형식: jaljarara-backup-YYYYMMDD.zip { backup.json, photos/<file>.jpg ... }
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums.dart';
import '../data/db/app_database.dart';
import '../data/db/database_provider.dart';

const int kBackupFormatVersion = 1;

class BackupSummary {
  const BackupSummary({
    required this.plants,
    required this.diaries,
    required this.photos,
    required this.exportedAt,
  });

  final int plants;
  final int diaries;
  final int photos;
  final DateTime exportedAt;
}

class BackupService {
  BackupService(this.db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final DateTime Function() _now;

  // ---------- 내보내기 ----------

  /// DB → JSON (species 제외: 앱 번들 시드로 복원). 사진은 파일명만 기록.
  Future<Map<String, dynamic>> exportJson() async {
    final spaces = await db.select(db.spaces).get();
    final plants = await db.select(db.plants).get();
    final species = await db.select(db.species).get();
    final speciesName = {for (final s in species) s.id: s.scientificName};
    final events = await db.select(db.careEvents).get();
    final diaries = await db.select(db.diaryEntries).get();
    final settings = await db.getSettings();

    String? base(String? path) =>
        path?.split(Platform.pathSeparator).last.split('/').last;

    return {
      'format': kBackupFormatVersion,
      'app': 'jaljarara',
      'exported_at': _now().toIso8601String(),
      'settings': {
        'notify_hour': settings.notifyHour,
        'notify_minute': settings.notifyMinute,
        'skip_weekdays': settings.skipWeekdays,
        'home_grid': settings.homeGrid,
        'notify_day_before': settings.notifyDayBefore,
      },
      'spaces': [
        for (final s in spaces)
          {
            'id': s.id,
            'name': s.name,
            'window_dir': s.windowDir.name,
            'window_dist': s.windowDist.name,
            'sort_order': s.sortOrder,
          },
      ],
      'plants': [
        for (final p in plants)
          {
            'id': p.id,
            // 품종은 학명으로 저장 → 복원 시 시드 DB에서 다시 매칭 (id 는 설치마다 다를 수 있음)
            'species_scientific_name': p.speciesId == null
                ? null
                : speciesName[p.speciesId],
            'nickname': p.nickname,
            'photo': base(p.photoPath),
            'space_id': p.spaceId,
            'pot_size': p.potSize.name,
            'has_drainage': p.hasDrainage,
            'water_interval_days': p.waterIntervalDays,
            'manual_override': p.manualOverride,
            'feedback_coef': p.feedbackCoef,
            'dry_streak': p.dryStreak,
            'last_watered_at': p.lastWateredAt.toIso8601String(),
            'next_check_at': p.nextCheckAt.toIso8601String(),
            'created_at': p.createdAt.toIso8601String(),
            'memo': p.memo,
          },
      ],
      'care_events': [
        for (final e in events)
          {
            'plant_id': e.plantId,
            'type': e.type.name,
            'at': e.at.toIso8601String(),
            'note': e.note,
          },
      ],
      'diary_entries': [
        for (final d in diaries)
          {
            'plant_id': d.plantId,
            'photo': base(d.photoPath),
            'memo': d.memo,
            'tags': d.tags.map((t) => t.name).toList(),
            'at': d.at.toIso8601String(),
          },
      ],
    };
  }

  /// 참조되는 사진 경로 목록 (존재하는 파일만)
  Future<List<String>> referencedPhotoPaths() async {
    final plants = await db.select(db.plants).get();
    final diaries = await db.select(db.diaryEntries).get();
    final paths = <String>{
      for (final p in plants)
        if (p.photoPath != null) p.photoPath!,
      for (final d in diaries)
        if (d.photoPath != null) d.photoPath!,
    };
    return [
      for (final p in paths)
        if (File(p).existsSync()) p,
    ];
  }

  /// zip 바이트 생성
  Future<Uint8List> exportZip() async {
    final json = await exportJson();
    final archive = Archive();
    final jsonBytes = utf8.encode(
      const JsonEncoder.withIndent(' ').convert(json),
    );
    archive.addFile(ArchiveFile('backup.json', jsonBytes.length, jsonBytes));
    for (final path in await referencedPhotoPaths()) {
      final bytes = await File(path).readAsBytes();
      final name = path.split(Platform.pathSeparator).last.split('/').last;
      archive.addFile(ArchiveFile('photos/$name', bytes.length, bytes));
    }
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  String suggestedFileName() {
    final n = _now();
    String two(int v) => v.toString().padLeft(2, '0');
    return 'jaljarara-backup-${n.year}${two(n.month)}${two(n.day)}.zip';
  }

  // ---------- 가져오기 ----------

  /// zip 검사 → 요약 (실제 복원 전 확인용)
  static BackupSummary? inspectZip(Uint8List zipBytes) {
    try {
      final archive = ZipDecoder().decodeBytes(zipBytes);
      final entry = archive.findFile('backup.json');
      if (entry == null) return null;
      final json =
          jsonDecode(utf8.decode(entry.content as List<int>))
              as Map<String, dynamic>;
      if (json['app'] != 'jaljarara') return null;
      return BackupSummary(
        plants: (json['plants'] as List).length,
        diaries: (json['diary_entries'] as List).length,
        photos: archive.files
            .where((f) => f.name.startsWith('photos/') && f.isFile)
            .length,
        exportedAt:
            DateTime.tryParse(json['exported_at'] as String? ?? '') ??
            DateTime(2000),
      );
    } catch (_) {
      return null;
    }
  }

  /// zip → 로컬 데이터 전체 교체. [photoDir]에 사진을 풀고 경로를 다시 연결한다.
  Future<void> importZip(
    Uint8List zipBytes, {
    required Directory photoDir,
  }) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final entry = archive.findFile('backup.json');
    if (entry == null) throw const FormatException('backup.json missing');
    final json =
        jsonDecode(utf8.decode(entry.content as List<int>))
            as Map<String, dynamic>;
    if (json['app'] != 'jaljarara') {
      throw const FormatException('not a Jaljarara backup');
    }

    if (!await photoDir.exists()) await photoDir.create(recursive: true);
    final photoPathByName = <String, String>{};
    for (final f in archive.files) {
      if (!f.isFile || !f.name.startsWith('photos/')) continue;
      final name = f.name.substring('photos/'.length);
      final out = File('${photoDir.path}${Platform.pathSeparator}$name');
      await out.writeAsBytes(f.content as List<int>, flush: true);
      photoPathByName[name] = out.path;
    }
    await importJson(json, photoPathByName: photoPathByName);
  }

  /// JSON → DB (트랜잭션, 기존 식물·공간·기록 삭제 후 삽입)
  Future<void> importJson(
    Map<String, dynamic> json, {
    Map<String, String> photoPathByName = const {},
  }) async {
    final species = await db.select(db.species).get();
    final speciesIdByName = {
      for (final s in species) s.scientificName.toLowerCase(): s.id,
    };
    String? photo(String? name) => name == null ? null : photoPathByName[name];

    await db.transaction(() async {
      await db.delete(db.diaryEntries).go();
      await db.delete(db.careEvents).go();
      await db.delete(db.plants).go();
      await db.delete(db.spaces).go();

      final spaceIdMap = <int, int>{};
      for (final s
          in (json['spaces'] as List? ?? const [])
              .cast<Map<String, dynamic>>()) {
        final id = await db
            .into(db.spaces)
            .insert(
              SpacesCompanion.insert(
                name: s['name'] as String,
                windowDir: WindowDir.values.byName(s['window_dir'] as String),
                windowDist: WindowDist.values.byName(
                  s['window_dist'] as String,
                ),
                sortOrder: Value((s['sort_order'] as int?) ?? 0),
              ),
            );
        spaceIdMap[s['id'] as int] = id;
      }

      final plantIdMap = <int, int>{};
      for (final p
          in (json['plants'] as List? ?? const [])
              .cast<Map<String, dynamic>>()) {
        final sci = (p['species_scientific_name'] as String?)?.toLowerCase();
        final id = await db
            .into(db.plants)
            .insert(
              PlantsCompanion.insert(
                nickname: p['nickname'] as String,
                speciesId: Value(sci == null ? null : speciesIdByName[sci]),
                photoPath: Value(photo(p['photo'] as String?)),
                spaceId: Value(
                  p['space_id'] == null
                      ? null
                      : spaceIdMap[p['space_id'] as int],
                ),
                potSize: PotSize.values.byName(
                  (p['pot_size'] as String?) ?? 'm',
                ),
                hasDrainage: Value((p['has_drainage'] as bool?) ?? true),
                waterIntervalDays: p['water_interval_days'] as int,
                manualOverride: Value((p['manual_override'] as bool?) ?? false),
                feedbackCoef: Value(
                  ((p['feedback_coef'] as num?) ?? 1.0).toDouble(),
                ),
                dryStreak: Value((p['dry_streak'] as int?) ?? 0),
                lastWateredAt: DateTime.parse(p['last_watered_at'] as String),
                nextCheckAt: DateTime.parse(p['next_check_at'] as String),
                createdAt: DateTime.parse(p['created_at'] as String),
                memo: Value(p['memo'] as String?),
              ),
            );
        plantIdMap[p['id'] as int] = id;
      }

      for (final e
          in (json['care_events'] as List? ?? const [])
              .cast<Map<String, dynamic>>()) {
        final pid = plantIdMap[e['plant_id'] as int];
        if (pid == null) continue;
        await db
            .into(db.careEvents)
            .insert(
              CareEventsCompanion.insert(
                plantId: pid,
                type: CareType.values.byName(e['type'] as String),
                at: DateTime.parse(e['at'] as String),
                note: Value(e['note'] as String?),
              ),
            );
      }

      for (final d
          in (json['diary_entries'] as List? ?? const [])
              .cast<Map<String, dynamic>>()) {
        final pid = plantIdMap[d['plant_id'] as int];
        if (pid == null) continue;
        await db
            .into(db.diaryEntries)
            .insert(
              DiaryEntriesCompanion.insert(
                plantId: pid,
                photoPath: Value(photo(d['photo'] as String?)),
                memo: Value(d['memo'] as String?),
                tags: Value(
                  ((d['tags'] as List?) ?? const [])
                      .cast<String>()
                      .map(DiaryTag.values.byName)
                      .toList(),
                ),
                at: DateTime.parse(d['at'] as String),
              ),
            );
      }

      final st = json['settings'] as Map<String, dynamic>?;
      if (st != null) {
        await db.getSettings();
        await (db.update(db.settings)..where((t) => t.id.equals(1))).write(
          SettingsCompanion(
            notifyHour: Value((st['notify_hour'] as int?) ?? 9),
            notifyMinute: Value((st['notify_minute'] as int?) ?? 0),
            skipWeekdays: Value(
              ((st['skip_weekdays'] as List?) ?? const []).cast<int>(),
            ),
            homeGrid: Value((st['home_grid'] as bool?) ?? true),
            notifyDayBefore: Value((st['notify_day_before'] as bool?) ?? false),
          ),
        );
      }
    });
  }
}

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(databaseProvider)),
);
