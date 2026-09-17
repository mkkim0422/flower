import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';

/// 도감 사진 출처 (위키미디어 공용, CC 라이선스 표기 의무 이행)
final _creditedSpeciesProvider = FutureProvider.autoDispose<List<SpeciesRow>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final rows =
      await (db.select(db.species)
            ..where((t) => t.imageUrl.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.scientificName)]))
          .get();
  return rows;
});

class PhotoCreditsScreen extends ConsumerWidget {
  const PhotoCreditsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final rows = ref.watch(_creditedSpeciesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('도감 사진 출처')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screenH,
          0,
          AppSpace.screenH,
          AppSpace.xxl,
        ),
        itemCount: rows.length + 1,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: Text(
                '도감 사진은 위키미디어 공용(Wikimedia Commons)의 자유 라이선스 사진이에요. '
                '각 사진의 작가와 라이선스, 원본 주소는 아래와 같아요',
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
            );
          }
          final s = rows[i - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.koNames.first} (${s.scientificName})',
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
                Text(
                  '${s.imageAuthor ?? '작가 미상'} · ${s.imageLicense ?? ''}',
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
                if (s.imagePage != null)
                  SelectableText(
                    s.imagePage!,
                    style: AppText.caption.copyWith(color: c.textTertiary),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
