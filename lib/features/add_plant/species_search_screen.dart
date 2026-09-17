import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/species_repository.dart';
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
      appBar: AppBar(title: const Text('이름으로 검색')),
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
              decoration: const InputDecoration(
                hintText: '예: 몬스테라, Monstera',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: seed.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  '품종 목록을 불러오지 못했어요',
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
              ),
              data: (_) => _Results(
                query: _query,
                onSelect: (s) => context.push(
                  AppRoutes.addEnv,
                  extra: AddPlantDraft(
                    speciesId: s.id,
                    nicknameHint: s.koNames.first,
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
                label: '목록에 없어요 → 직접 입력',
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
String? _matchedAlias(SpeciesRow s, String query) {
  final q = query.toLowerCase().replaceAll(' ', '');
  if (s.koNames.first.toLowerCase().replaceAll(' ', '').contains(q)) {
    return null;
  }
  for (final n in s.koNames.skip(1)) {
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
          '국내명이나 학명을 입력해 보세요',
          style: AppText.body.copyWith(color: c.textTertiary),
        ),
      );
    }
    final results = ref.watch(speciesSearchProvider(query));
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          '검색 중 문제가 생겼어요',
          style: AppText.body.copyWith(color: c.textSecondary),
        ),
      ),
      data: (rows) {
        if (rows.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.screenH),
              child: Text(
                '"$query"에 맞는 품종이 없어요.\n아래에서 직접 입력으로 등록해 보세요',
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.koNames.first,
                            style: AppText.title.copyWith(color: c.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_matchedAlias(s, query) case final alias?)
                            Text(
                              '$alias(으)로도 불려요',
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
                    if (s.toxicPet || s.toxicChild)
                      Icon(
                        Icons.warning_rounded,
                        color: c.warning,
                        size: AppSize.iconSm,
                      ),
                    IconButton(
                      tooltip: '도감 보기',
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
