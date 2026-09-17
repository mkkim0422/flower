import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/plant_card.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/species_repository.dart';
import '../../data/species_l10n.dart';
import '../../data/seed/species_seed.dart';
import 'add_plant_draft.dart';

/// ADD-02 이름 검색 (국내명·학명 동시)
class SpeciesSearchScreen extends ConsumerStatefulWidget {
  const SpeciesSearchScreen({super.key, this.draft});

  /// 식별 흐름에서 넘어온 사진 등 (선택)
  final AddPlantDraft? draft;

  @override
  ConsumerState<SpeciesSearchScreen> createState() =>
      _SpeciesSearchScreenState();
}

class _SpeciesSearchScreenState extends ConsumerState<SpeciesSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final seed = ref.watch(speciesSeedProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.searchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.screenH,
              AppSpace.sm,
              AppSpace.screenH,
              AppSpace.md,
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: seed.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  context.l10n.searchCatalogFailed,
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
              ),
              data: (_) => _Results(
                query: _query,
                onSelect: (s) => context.push(
                  AppRoutes.addEnv,
                  extra: AddPlantDraft(
                    speciesId: s.id,
                    nicknameHint: s.displayName(context.l10n),
                    photoPath: widget.draft?.photoPath,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.screenH,
                vertical: AppSpace.sm,
              ),
              child: AppButton.text(
                label: context.l10n.searchNotListed,
                expanded: true,
                onPressed: () => context.push(
                  AppRoutes.addManual,
                  extra: AddPlantDraft(
                    nicknameHint: _query.isEmpty ? null : _query,
                    photoPath: widget.draft?.photoPath,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 검색어가 대표명이 아닌 별칭에 걸렸을 때 그 별칭 (없으면 null)
String? _matchedAlias(SpeciesRow s, String query, AppLocalizations l) {
  final q = query.toLowerCase().replaceAll(' ', '');
  final names = s.allNames(l);
  if (names.isEmpty ||
      s.displayName(l).toLowerCase().replaceAll(' ', '').contains(q)) {
    return null;
  }
  for (final n in names.skip(1)) {
    if (n.toLowerCase().replaceAll(' ', '').contains(q)) return n;
  }
  return null;
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.onSelect});

  final String query;
  final ValueChanged<SpeciesRow> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    if (query.isEmpty) {
      return Center(
        child: Text(
          context.l10n.searchPrompt,
          style: AppText.body.copyWith(color: c.textTertiary),
        ),
      );
    }
    final results = ref.watch(speciesSearchProvider(query));
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          context.l10n.searchError,
          style: AppText.body.copyWith(color: c.textSecondary),
        ),
      ),
      data: (rows) {
        if (rows.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.screenH),
              child: Text(
                context.l10n.searchNoResult(query),
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: c.textSecondary),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
          itemCount: rows.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (_, i) {
            final s = rows[i];
            return InkWell(
              onTap: () => onSelect(s),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
                child: Row(
                  children: [
                    PlantThumb(
                      size: AppSize.plantThumb,
                      fallbackUrl: s.imageUrl,
                    ),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.displayName(context.l10n),
                            style: AppText.title.copyWith(color: c.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_matchedAlias(s, query, context.l10n)
                              case final alias?)
                            Text(
                              context.l10n.searchAlsoKnownAs(alias),
                              style: AppText.caption.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          Text(
                            s.scientificName,
                            style: AppText.scientificName.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (s.toxicSevere)
                      Icon(
                        Icons.warning_rounded,
                        color: c.warning,
                        size: AppSize.iconSm,
                      ),
                    IconButton(
                      tooltip: context.l10n.searchViewCatalog,
                      onPressed: () => context.push(AppRoutes.species(s.id)),
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: c.textSecondary,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: c.textTertiary),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
