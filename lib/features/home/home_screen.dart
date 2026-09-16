import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/empty_state.dart';
import '../../app/widgets/plant_card.dart';
import '../../app/widgets/today_check_tile.dart';
import '../../data/repositories/plant_repository.dart';
import 'soil_check_sheet.dart';

/// HOME-01
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Set<int> _selected = {};
  bool _bySpace = false;

  Future<void> _openSoilCheck(List<PlantEntry> entries) async {
    if (entries.isEmpty) return;
    final result = await showSoilCheckSheet(context, entries: entries);
    if (result != null && mounted) {
      setState(() => _selected.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();
    final dateLabel = DateFormat('M월 d일 EEEE', 'ko_KR').format(now);
    final plantsAsync = ref.watch(plantsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: plantsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('불러오지 못했어요. 앱을 다시 열어 보세요',
                style: AppText.body.copyWith(color: c.textSecondary)),
          ),
          data: (plants) {
            if (plants.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(dateLabel: dateLabel),
                  Expanded(
                    child: EmptyState(
                      title: '첫 식물을 등록해 보세요',
                      description: '이름을 검색하거나 사진을 찍어 등록할 수 있어요',
                      actionLabel: '식물 추가',
                      onAction: () => context.push(AppRoutes.add),
                    ),
                  ),
                ],
              );
            }

            final due = plants.where((e) => e.isDue(now)).toList();
            _selected.removeWhere((id) => !due.any((e) => e.plant.id == id));
            final selectedEntries =
                due.where((e) => _selected.contains(e.plant.id)).toList();

            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(
                    left: AppSpace.screenH,
                    right: AppSpace.screenH,
                    bottom: AppSize.tabBarHeight +
                        AppSize.cameraButtonOverlap +
                        MediaQuery.paddingOf(context).bottom +
                        (selectedEntries.isNotEmpty ? 80 : AppSpace.xl),
                  ),
                  children: [
                    _Header(dateLabel: dateLabel, padded: false),
                    const SizedBox(height: AppSpace.section),

                    // 섹션1: 오늘 확인
                    if (due.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '확인할 식물 ${due.length}',
                              style: AppText.title.copyWith(color: c.textPrimary),
                            ),
                          ),
                          AppButton.text(
                            label: _selected.length == due.length ? '선택 해제' : '전체 선택',
                            onPressed: () => setState(() {
                              if (_selected.length == due.length) {
                                _selected.clear();
                              } else {
                                _selected
                                  ..clear()
                                  ..addAll(due.map((e) => e.plant.id));
                              }
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.md),
                      for (final e in due) ...[
                        TodayCheckTile(
                          nickname: e.plant.nickname,
                          spaceName: e.space?.name ?? e.displaySpeciesName,
                          photoPath: e.plant.photoPath,
                          selected: _selected.contains(e.plant.id),
                          onToggle: () => setState(() {
                            if (!_selected.remove(e.plant.id)) {
                              _selected.add(e.plant.id);
                            }
                          }),
                          onTap: () => _openSoilCheck([e]),
                        ),
                        const SizedBox(height: AppSpace.cardGap),
                      ],
                      const SizedBox(height: AppSpace.section - AppSpace.cardGap),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpace.cardPadding),
                        decoration: BoxDecoration(
                          color: c.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: c.primary),
                            const SizedBox(width: AppSpace.md),
                            Expanded(
                              child: Text(
                                '오늘 확인할 식물이 없어요',
                                style: AppText.bodyStrong.copyWith(color: c.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpace.section),
                    ],

                    // 섹션2: 내 식물
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '내 식물 ${plants.length}',
                            style: AppText.title.copyWith(color: c.textPrimary),
                          ),
                        ),
                        _SegmentToggle(
                          bySpace: _bySpace,
                          onChanged: (v) => setState(() => _bySpace = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.md),
                    if (!_bySpace)
                      for (final e in plants) ...[
                        _card(e, now),
                        const SizedBox(height: AppSpace.cardGap),
                      ]
                    else
                      ..._groupedBySpace(plants, now, c),
                    const SizedBox(height: AppSpace.xs),
                    AppButton.secondary(
                      label: '+ 식물 추가',
                      onPressed: () => context.push(AppRoutes.add),
                    ),
                  ],
                ),

                // 다중 선택 하단 고정 바
                if (selectedEntries.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: AppSize.tabBarHeight +
                        AppSize.cameraButtonOverlap +
                        MediaQuery.paddingOf(context).bottom,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.screenH,
                        AppSpace.md,
                        AppSpace.screenH,
                        AppSpace.md,
                      ),
                      color: c.background,
                      child: AppButton.primary(
                        label: '${selectedEntries.length}개 확인 완료',
                        onPressed: () => _openSoilCheck(selectedEntries),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _card(PlantEntry e, DateTime now) => PlantCard(
        nickname: e.plant.nickname,
        speciesName: e.displaySpeciesName,
        photoPath: e.plant.photoPath,
        status: e.status(now),
        statusLabel: e.statusLabel(now),
        onTap: () => context.push(AppRoutes.plant(e.plant.id)),
      );

  List<Widget> _groupedBySpace(List<PlantEntry> plants, DateTime now, AppColors c) {
    final groups = <String, List<PlantEntry>>{};
    for (final e in plants) {
      groups.putIfAbsent(e.space?.name ?? '공간 미지정', () => []).add(e);
    }
    final out = <Widget>[];
    for (final entry in groups.entries) {
      out.add(Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm, top: AppSpace.xs),
        child: Text(
          '${entry.key} ${entry.value.length}',
          style: AppText.label.copyWith(color: c.textSecondary),
        ),
      ));
      for (final e in entry.value) {
        out
          ..add(_card(e, now))
          ..add(const SizedBox(height: AppSpace.cardGap));
      }
    }
    return out;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dateLabel, this.padded = true});

  final String dateLabel;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(
        left: padded ? AppSpace.screenH : 0,
        right: padded ? AppSpace.screenH : 0,
        top: AppSpace.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('오늘', style: AppText.headline.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpace.xs),
          Text(dateLabel, style: AppText.caption.copyWith(color: c.textSecondary)),
        ],
      ),
    );
  }
}

/// [목록 | 공간] 세그먼트 토글
class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.bySpace, required this.onChanged});

  final bool bySpace;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget item(String label, bool value) {
      final selected = bySpace == value;
      return InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: Container(
          height: AppSize.chipHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
          decoration: BoxDecoration(
            color: selected ? c.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppText.label.copyWith(
              color: selected ? c.onPrimary : c.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [item('목록', false), item('공간', true)],
      ),
    );
  }
}
