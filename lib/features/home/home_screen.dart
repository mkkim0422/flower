import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/empty_state.dart';
import '../../app/widgets/plant_card.dart';
import '../../app/widgets/plant_grid_card.dart';
import '../../app/widgets/today_check_tile.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/notification_service.dart' show isNotifyPaused;
import 'soil_check_sheet.dart';

/// HOME-01
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Set<int> _selected = {};

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
    final settings = ref.watch(settingsProvider).value;
    final grid = settings?.homeGrid ?? true;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: plantsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              '불러오지 못했어요. 앱을 다시 열어 보세요',
              style: AppText.body.copyWith(color: c.textSecondary),
            ),
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
                      description: '사진을 찍으면 품종과 물주기를 알려드려요',
                      actionLabel: '식물 추가',
                      onAction: () => context.push(AppRoutes.add),
                    ),
                  ),
                ],
              );
            }

            final due = plants.where((e) => e.isDue(now)).toList();
            _selected.removeWhere((id) => !due.any((e) => e.plant.id == id));
            final selectedEntries = due
                .where((e) => _selected.contains(e.plant.id))
                .toList();
            final bottomInset =
                AppSize.tabBarHeight +
                AppSize.cameraButtonOverlap +
                MediaQuery.paddingOf(context).bottom;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.screenH,
                      ),
                      sliver: SliverList.list(
                        children: [
                          _Header(dateLabel: dateLabel, padded: false),
                          const SizedBox(height: AppSpace.section),
                          if (settings != null &&
                              isNotifyPaused(settings, now)) ...[
                            _PausedBanner(
                              until: settings.notifyPausedUntil!,
                              onResume: () => ref
                                  .read(settingsRepositoryProvider)
                                  .setNotifyPausedUntil(null),
                            ),
                            const SizedBox(height: AppSpace.md),
                          ],
                          if (due.isNotEmpty) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '물 줄 식물 ${due.length}',
                                    style: AppText.title.copyWith(
                                      color: c.textPrimary,
                                    ),
                                  ),
                                ),
                                AppButton.text(
                                  label: _selected.length == due.length
                                      ? '선택 해제'
                                      : '전체 선택',
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
                                spaceName:
                                    e.space?.name ?? e.displaySpeciesName,
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
                            const SizedBox(
                              height: AppSpace.section - AppSpace.cardGap,
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(
                                AppSpace.cardPadding,
                              ),
                              decoration: BoxDecoration(
                                color: c.accentSoft,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: c.primary,
                                  ),
                                  const SizedBox(width: AppSpace.md),
                                  Expanded(
                                    child: Text(
                                      '오늘 물 줄 식물이 없어요',
                                      style: AppText.bodyStrong.copyWith(
                                        color: c.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpace.section),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '내 식물 ${plants.length}',
                                  style: AppText.title.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                              ),
                              _ViewToggle(
                                grid: grid,
                                onChanged: (v) => ref
                                    .read(settingsRepositoryProvider)
                                    .setHomeGrid(v),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpace.md),
                        ],
                      ),
                    ),
                    // 내 식물: 앨범(2열) 또는 목록
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.screenH,
                      ),
                      sliver: grid
                          ? SliverGrid.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: AppSpace.cardGap,
                                    crossAxisSpacing: AppSpace.cardGap,
                                    mainAxisExtent: PlantGridCard.extentFor(
                                      context,
                                      (MediaQuery.sizeOf(context).width -
                                              AppSpace.screenH * 2 -
                                              AppSpace.cardGap) /
                                          2,
                                    ),
                                  ),
                              itemCount: plants.length,
                              itemBuilder: (_, i) => _gridCard(plants[i], now),
                            )
                          : SliverList.separated(
                              itemCount: plants.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpace.cardGap),
                              itemBuilder: (_, i) => _card(plants[i], now),
                            ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpace.screenH,
                        AppSpace.lg,
                        AppSpace.screenH,
                        bottomInset +
                            (selectedEntries.isNotEmpty
                                ? AppSize.stickyBar
                                : AppSpace.xl),
                      ),
                      sliver: SliverToBoxAdapter(
                        child: AppButton.secondary(
                          label: '+ 식물 추가',
                          onPressed: () => context.push(AppRoutes.add),
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedEntries.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomInset,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.screenH,
                        AppSpace.md,
                        AppSpace.screenH,
                        AppSpace.md,
                      ),
                      color: c.background,
                      child: AppButton.primary(
                        label: '${selectedEntries.length}개 물 줬어요',
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
    fallbackUrl: e.species?.imageUrl,
    status: e.status(now),
    statusLabel: e.statusLabel(now),
    onTap: () => context.push(AppRoutes.plant(e.plant.id)),
  );

  Widget _gridCard(PlantEntry e, DateTime now) => PlantGridCard(
    nickname: e.plant.nickname,
    speciesName: e.displaySpeciesName,
    photoPath: e.plant.photoPath,
    fallbackUrl: e.species?.imageUrl,
    status: e.status(now),
    statusLabel: e.statusLabel(now),
    onTap: () => context.push(AppRoutes.plant(e.plant.id)),
  );
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
          Text(
            dateLabel,
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// [앨범 | 목록] 세그먼트 토글 (아이콘)
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.grid, required this.onChanged});

  final bool grid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget item(IconData icon, String label, bool value) {
      final selected = grid == value;
      return Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(AppRadius.chip),
          child: Container(
            height: AppSize.chipHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            decoration: BoxDecoration(
              color: selected ? c.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: Icon(
              icon,
              size: AppSize.iconXs,
              color: selected ? c.onPrimary : c.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSize.segmentPadding),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          item(Icons.grid_view_rounded, '앨범', true),
          item(Icons.view_list_rounded, '목록', false),
        ],
      ),
    );
  }
}

/// 알림 멈춤 안내
class _PausedBanner extends StatelessWidget {
  const _PausedBanner({required this.until, required this.onResume});

  final DateTime until;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.only(left: AppSpace.cardPadding),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.pause_circle_outline_rounded, color: c.textSecondary),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Text(
              '알림이 ${until.month}월 ${until.day}일까지 멈춰 있어요',
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
          ),
          AppButton.text(label: '다시 켜기', onPressed: onResume),
        ],
      ),
    );
  }
}
