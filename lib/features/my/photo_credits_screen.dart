import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/species_l10n.dart';
import '../../core/app_locale.dart';
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
      appBar: AppBar(title: Text(context.l10n.creditsTitle)),
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
                context.l10n.creditsIntro,
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
                  '${s.displayName(context.l10n)} (${s.scientificName})',
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
                Text(
                  '${s.imageAuthor ?? context.l10n.infoUnknownAuthor} · ${s.imageLicense ?? ''}',
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
