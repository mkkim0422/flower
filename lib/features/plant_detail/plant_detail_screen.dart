import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/species_l10n.dart';
import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_card.dart';
import '../../app/widgets/plant_card.dart';
import '../../app/widgets/toxic_badge.dart';
import '../../core/enums.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/diary_repository.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/space_repository.dart';
import '../home/soil_check_sheet.dart';
import 'interval_sheet.dart';

/// PLT-01 식물 상세 (2026-09-16 단순화: D-day → 내 메모 → 알아두면 좋은 정보 → 물 준 기록)
class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final entryAsync = ref.watch(plantByIdProvider(plantId));

    return entryAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            context.l10n.commonLoadFailed,
            style: AppText.body.copyWith(color: c.textSecondary),
          ),
        ),
      ),
      data: (entry) {
        if (entry == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                context.l10n.detailDeleted,
                style: AppText.body.copyWith(color: c.textSecondary),
              ),
            ),
          );
        }
        return _Body(entry: entry);
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.entry});

  final PlantEntry entry;

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: entry.plant.nickname);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.detailRename),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(context.l10n.commonSave),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref
          .read(plantRepositoryProvider)
          .updateBasic(id: entry.plant.id, nickname: name);
    }
  }

  Future<void> _editMemo(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: entry.plant.memo ?? '');
    final memo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.detailMyMemo),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(hintText: context.l10n.memoHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(context.l10n.commonSave),
          ),
        ],
      ),
    );
    if (memo != null) {
      await ref
          .read(plantRepositoryProvider)
          .setMemo(entry.plant.id, memo.isEmpty ? null : memo);
    }
  }

  Future<void> _moveSpace(BuildContext context, WidgetRef ref) async {
    final spaces = await ref.read(spaceRepositoryProvider).getAll();
    if (!context.mounted) return;
    final c = context.colors;
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screenH,
          0,
          AppSpace.screenH,
          AppSpace.xl,
        ),
        children: [
          Text(
            context.l10n.detailPlace,
            style: AppText.title.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.md),
          for (final s in spaces)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                s.name,
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
              subtitle: Text(
                '${s.windowDir.label(context.l10n)} · ${s.windowDist.label(context.l10n)}',
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
              trailing: entry.plant.spaceId == s.id
                  ? Icon(Icons.check_rounded, color: c.primary)
                  : null,
              onTap: () async {
                await ref
                    .read(plantRepositoryProvider)
                    .updateBasic(id: entry.plant.id, spaceId: Value(s.id));
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.l10n.detailPlaceNone,
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
            trailing: entry.plant.spaceId == null
                ? Icon(Icons.check_rounded, color: c.primary)
                : null,
            onTap: () async {
              await ref
                  .read(plantRepositoryProvider)
                  .updateBasic(id: entry.plant.id, spaceId: const Value(null));
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
          const SizedBox(height: AppSpace.sm),
          AppButton.secondary(
            label: context.l10n.detailAddPlace,
            onPressed: () async {
              Navigator.pop(ctx);
              final id = await context.push<int>(AppRoutes.spaceNew);
              if (id != null) {
                await ref
                    .read(plantRepositoryProvider)
                    .updateBasic(id: entry.plant.id, spaceId: Value(id));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDiary(
    BuildContext context,
    WidgetRef ref,
    DiaryEntry d,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.detailDeleteDiaryQ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.l10n.commonRemove,
              style: TextStyle(color: ctx.colors.error),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(diaryRepositoryProvider).delete(d.id);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.detailDeletePlantQ(entry.plant.nickname)),
        content: Text(context.l10n.detailDeletePlantBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.l10n.commonDelete,
              style: TextStyle(color: ctx.colors.error),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(plantRepositoryProvider).delete(entry.plant.id);
      if (context.mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final now = DateTime.now();
    final p = entry.plant;
    final s = entry.species;
    final dDay = entry.dDay(now);
    final result = ref.read(plantRepositoryProvider).computeForEntry(entry);
    final wateredToday = PlantRepository.wateredOn(
      ref.watch(careEventsProvider(p.id)).value ?? const <CareEvent>[],
      now,
    );
    final diary =
        ref.watch(diaryByPlantProvider(p.id)).value ?? const <DiaryEntry>[];

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'rename':
                  _rename(context, ref);
                case 'space':
                  _moveSpace(context, ref);
                case 'delete':
                  _delete(context, ref);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'rename',
                child: Text(context.l10n.detailRename),
              ),
              PopupMenuItem(
                value: 'space',
                child: Text(context.l10n.detailChangePlace),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  context.l10n.commonDelete,
                  style: TextStyle(color: c.error),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          // 헤더: 사진 4:3 (탭 → 원본 전체화면) + 이름 + 품종·학명
          GestureDetector(
            onTap: p.photoPath == null
                ? null
                : () => Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      opaque: false,
                      pageBuilder: (_, _, _) =>
                          PhotoViewerScreen(path: p.photoPath!),
                    ),
                  ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlantThumb(
                      size: double.infinity,
                      photoPath: p.photoPath,
                      fallbackUrl: s?.imageUrl,
                      radius: 0,
                    ),
                    if (p.photoPath == null && s?.imageUrl != null)
                      Positioned(
                        left: AppSpace.sm,
                        bottom: AppSpace.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpace.sm,
                            vertical: AppSpace.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: c.surface.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                          ),
                          child: Text(
                            context.l10n.detailCatalogPhoto,
                            style: AppText.label.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(
            p.nickname,
            style: AppText.headline.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            s == null
                ? context.l10n.speciesUnknown
                : s.displayName(context.l10n),
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
          if (s != null)
            Text(
              s.scientificName,
              style: AppText.scientificName.copyWith(color: c.textSecondary),
            ),
          const SizedBox(height: AppSpace.section),

          // 카드1: 물 주기 D-day
          AppCard(
            filled: dDay <= 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      color: dDay <= 0 ? c.statusNeedCheck : c.primary,
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: Text(
                        dDay < 0
                            ? context.l10n.detailOverdue(-dDay)
                            : (dDay == 0
                                  ? context.l10n.detailDueToday
                                  : context.l10n.detailUntilNext),
                        style: AppText.body.copyWith(color: c.textSecondary),
                      ),
                    ),
                    Text(
                      dDay < 0
                          ? context.l10n.statusOverdue(-dDay)
                          : (dDay == 0
                                ? context.l10n.detailDDay
                                : context.l10n.statusDaysLeft(dDay)),
                      style: AppText.headline.copyWith(
                        color: dDay <= 0 ? c.statusNeedCheck : c.primary,
                        fontFeatures: AppText.tabularFeatures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${context.l10n.commonEveryDays(p.waterIntervalDays)}${p.manualOverride ? context.l10n.detailIntervalManual : context.l10n.detailIntervalAuto}'
                        '${context.l10n.detailLastWatered(DateFormat.MMMd(context.l10n.localeName).format(p.lastWateredAt))}',
                        style: AppText.caption.copyWith(color: c.textSecondary),
                      ),
                    ),
                    AppButton.text(
                      label: context.l10n.detailAdjust,
                      onPressed: () => showIntervalSheet(
                        context,
                        entry: entry,
                        result: result,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 카드2: 내 메모 — 없으면 버튼 한 줄, 있으면 내용 카드
          if (p.memo?.isNotEmpty == true) ...[
            AppCard(
              onTap: () => _editMemo(context, ref),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: AppSize.iconSm,
                    color: c.textSecondary,
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text(
                      p.memo!,
                      style: AppText.body.copyWith(color: c.textPrimary),
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    size: AppSize.iconSm,
                    color: c.textTertiary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.cardGap),
          ] else ...[
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.text(
                label: context.l10n.detailAddMemo,
                icon: Icons.sticky_note_2_outlined,
                onPressed: () => _editMemo(context, ref),
              ),
            ),
            const SizedBox(height: AppSpace.xs),
          ],

          // 카드2-2: 생장 일기 (최근 3개 + 더보기)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.diaryLabel,
                        style: AppText.title.copyWith(color: c.textPrimary),
                      ),
                    ),
                    AppButton.text(
                      label: context.l10n.detailDiaryWrite,
                      onPressed: () => context.push(AppRoutes.diaryNew(p.id)),
                    ),
                  ],
                ),
                if (diary.isEmpty)
                  Text(
                    context.l10n.detailDiaryEmpty,
                    style: AppText.body.copyWith(color: c.textTertiary),
                  )
                else ...[
                  const SizedBox(height: AppSpace.sm),
                  for (final d in diary.take(3))
                    _DiaryLine(
                      entry: d,
                      onDelete: () => _deleteDiary(context, ref, d),
                    ),
                  if (diary.length > 3)
                    Text(
                      context.l10n.detailDiaryMore(diary.length - 3),
                      style: AppText.caption.copyWith(color: c.textTertiary),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 카드3: 알아두면 좋은 정보 (도감 페이지와 내용이 같아 별도 링크 없음)
          if (s != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.detailGoodToKnow,
                    style: AppText.title.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: AppSpace.md),
                  if (s.toxicSevere) ...[
                    ToxicBadge(
                      toxicPet: s.toxicPet,
                      childLevel: s.toxicChildLevel,
                      note: s.toxicityNoteFor(context.l10n),
                    ),
                    const SizedBox(height: AppSpace.md),
                  ],
                  for (final tip in careTips(s, context.l10n))
                    _InfoLine(icon: tip.icon, text: tip.text),
                ],
              ),
            )
          else
            AppCard(
              child: Text(
                context.l10n.detailNoSpeciesInfo,
                style: AppText.body.copyWith(color: c.textSecondary),
              ),
            ),
          const SizedBox(height: AppSpace.cardGap),

          const SizedBox(height: AppSpace.cardGap),
          // 증상으로 원인 찾기
          AppCard(
            onTap: () => context.push(AppRoutes.symptoms(p.id)),
            child: Row(
              children: [
                Icon(Icons.healing_outlined, color: c.textSecondary),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Text(
                    context.l10n.detailSymptomEntry,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.textTertiary),
              ],
            ),
          ),
          // 플로팅 버튼 자리
          SizedBox(
            height:
                AppSize.buttonHeight +
                AppSpace.xl * 2 +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      ),
      // 화면 하단에 떠 있는 "물 줬어요" (Override: 사용자 지시 2026-09-16)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            heroTag: 'water-${p.id}',
            backgroundColor: wateredToday ? c.primaryContainer : c.primary,
            foregroundColor: wateredToday ? c.primary : c.onPrimary,
            elevation: wateredToday ? 0 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            onPressed: wateredToday
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.detailAlreadyWatered)),
                  )
                : () => showSoilCheckSheet(context, entries: [entry]),
            icon: Icon(
              wateredToday ? Icons.check_rounded : Icons.water_drop_rounded,
            ),
            label: Text(
              wateredToday
                  ? context.l10n.detailWateredToday
                  : (dDay <= 0
                        ? context.l10n.detailWatered
                        : context.l10n.detailWateredToday),
              style: AppText.bodyStrong,
            ),
          ),
        ),
      ),
    );
  }
}

/// 일기 한 줄: 썸네일 · 날짜 · 태그 · 메모
class _DiaryLine extends StatelessWidget {
  const _DiaryLine({required this.entry, required this.onDelete});

  final DiaryEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: entry.photoPath == null
                ? null
                : () => Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      opaque: false,
                      pageBuilder: (_, _, _) =>
                          PhotoViewerScreen(path: entry.photoPath!),
                    ),
                  ),
            child: PlantThumb(
              size: AppSize.plantThumb,
              photoPath: entry.photoPath,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.MMMEd(context.l10n.localeName).format(entry.at),
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
                if (entry.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.xs),
                    child: Wrap(
                      spacing: AppSpace.xs,
                      children: [
                        for (final t in entry.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpace.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: c.accentSoft,
                              borderRadius: BorderRadius.circular(
                                AppRadius.chip,
                              ),
                            ),
                            child: Text(
                              t.label(context.l10n),
                              style: AppText.label.copyWith(color: c.primary),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (entry.memo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.xs),
                    child: Text(
                      entry.memo!,
                      style: AppText.body.copyWith(color: c.textPrimary),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.l10n.commonRemove,
            onPressed: onDelete,
            icon: Icon(
              Icons.close_rounded,
              size: AppSize.iconXs,
              color: c.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 사진 원본 전체화면 보기 (핀치 줌) + 닫기
class PhotoViewerScreen extends StatelessWidget {
  const PhotoViewerScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.file(File(path), fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.sm),
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: context.l10n.commonClose,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 온도 문장: 적정 범위(있으면) + 최저 한계. 화씨 국가는 °F
String temperatureTip(SpeciesRow s, AppLocalizations l) {
  final optMin = s.tempOptMin ?? s.tempMin;
  final optMax = s.tempOptMax ?? s.tempMax;
  final low = s.tempMin;
  if (optMin == null || optMax == null) return '';
  final opt = l.tipTempOptimal(
    formatTemperature(optMin),
    formatTemperature(optMax),
  );
  if (low == null) return opt;
  if (low <= 0) return l.tipTempHardy(opt);
  if (low <= 5) return l.tipTempCool(opt, formatTemperature(low));
  return l.tipTempTender(opt, formatTemperature(low));
}

/// 품종 정보 → 알아두면 좋은 정보 문장 (비료·분갈이는 2026-09-16 사용자 지시로 제외)
class CareTip {
  const CareTip(this.icon, this.text);

  final IconData icon;
  final String text;
}

List<CareTip> careTips(SpeciesRow s, AppLocalizations l) {
  return [
    CareTip(Icons.water_drop_outlined, switch (s.category) {
      'succulent' => l.tipWaterSucculent(s.baseWaterDays),
      'herb' => l.tipWaterHerb(s.baseWaterDays),
      'flower' => l.tipWaterFlower(s.baseWaterDays),
      _ => l.tipWaterFoliage(s.baseWaterDays),
    }),
    CareTip(Icons.wb_sunny_outlined, switch (s.lightPref) {
      LightPref.low => l.tipLightLow,
      LightPref.med => l.tipLightMed,
      LightPref.high => l.tipLightHigh,
    }),
    if (s.tempMin != null && s.tempMax != null)
      CareTip(Icons.thermostat_outlined, temperatureTip(s, l)),
    for (final issue in s.commonIssuesFor(l))
      CareTip(Icons.error_outline_rounded, issue),
  ];
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSize.iconXs, color: c.textSecondary),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Text(
              text,
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
