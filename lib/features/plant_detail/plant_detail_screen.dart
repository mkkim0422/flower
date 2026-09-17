import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
            '불러오지 못했어요',
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
                '삭제된 식물이에요',
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
        title: const Text('이름 바꾸기'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('저장'),
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
        title: const Text('내 메모'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 5,
          minLines: 3,
          decoration: const InputDecoration(hintText: '예: 베란다 왼쪽. 잎이 처지면 물 부족'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('저장'),
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
          Text('놓는 곳', style: AppText.title.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpace.md),
          for (final s in spaces)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                s.name,
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
              subtitle: Text(
                '${s.windowDir.label} · ${s.windowDist.label}',
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
              '지정 안 함',
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
            label: '+ 새 장소 추가',
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
        title: const Text('이 일기를 지울까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('지우기', style: TextStyle(color: ctx.colors.error)),
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
        title: Text('${entry.plant.nickname}을(를) 삭제할까요?'),
        content: const Text('물 준 기록과 메모도 함께 지워져요'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('삭제', style: TextStyle(color: ctx.colors.error)),
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
              const PopupMenuItem(value: 'rename', child: Text('이름 바꾸기')),
              const PopupMenuItem(value: 'space', child: Text('놓는 곳 바꾸기')),
              PopupMenuItem(
                value: 'delete',
                child: Text('삭제', style: TextStyle(color: c.error)),
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
                child: PlantThumb(
                  size: double.infinity,
                  photoPath: p.photoPath,
                  radius: 0,
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
            s == null ? '품종 미지정' : s.koNames.first,
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
                            ? '물 주는 날이 ${-dDay}일 지났어요'
                            : (dDay == 0 ? '오늘 물 주는 날이에요' : '다음 물 주는 날까지'),
                        style: AppText.body.copyWith(color: c.textSecondary),
                      ),
                    ),
                    Text(
                      dDay < 0
                          ? 'D+${-dDay}'
                          : (dDay == 0 ? 'D-day' : 'D-$dDay'),
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
                        '${p.waterIntervalDays}일마다 ${p.manualOverride ? '(직접 설정)' : '(자동)'}'
                        ' · 마지막 ${DateFormat('M월 d일', 'ko_KR').format(p.lastWateredAt)}',
                        style: AppText.caption.copyWith(color: c.textSecondary),
                      ),
                    ),
                    AppButton.text(
                      label: '주기 조정',
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
                label: '+ 메모 남기기',
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
                        '일기',
                        style: AppText.title.copyWith(color: c.textPrimary),
                      ),
                    ),
                    AppButton.text(
                      label: '+ 쓰기',
                      onPressed: () => context.push(AppRoutes.diaryNew(p.id)),
                    ),
                  ],
                ),
                if (diary.isEmpty)
                  Text(
                    '사진과 한 줄 메모로 자라는 모습을 남겨 보세요',
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
                      '외 ${diary.length - 3}개',
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
                    '알아두면 좋은 정보',
                    style: AppText.title.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: AppSpace.md),
                  ToxicBadge(
                    toxicPet: s.toxicPet,
                    childLevel: s.toxicChildLevel,
                    note: s.toxicityNote,
                  ),
                  const SizedBox(height: AppSpace.md),
                  for (final tip in careTips(s))
                    _InfoLine(icon: tip.icon, text: tip.text),
                ],
              ),
            )
          else
            AppCard(
              child: Text(
                '품종을 지정하면 키우기 정보를 보여드려요. 카메라로 식별하거나 이름으로 검색해 보세요',
                style: AppText.body.copyWith(color: c.textSecondary),
              ),
            ),
          const SizedBox(height: AppSpace.cardGap),

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
                ? () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('오늘은 이미 물을 줬어요')))
                : () => showSoilCheckSheet(context, entries: [entry]),
            icon: Icon(
              wateredToday ? Icons.check_rounded : Icons.water_drop_rounded,
            ),
            label: Text(
              wateredToday ? '오늘 물 줬어요' : (dDay <= 0 ? '물 줬어요' : '오늘 물 줬어요'),
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
                  DateFormat('M월 d일 (E)', 'ko_KR').format(entry.at),
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
                              t.label,
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
            tooltip: '지우기',
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
                  tooltip: '닫기',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 온도 문장: 적정 범위(있으면) + 최저 한계
String temperatureTip(SpeciesRow s) {
  final optMin = s.tempOptMin ?? s.tempMin;
  final optMax = s.tempOptMax ?? s.tempMax;
  final low = s.tempMin;
  if (optMin == null || optMax == null) return '';
  final opt = '적정 $optMin~$optMax°C';
  if (low == null) return opt;
  if (low <= 0) return '$opt. 추위에 강해 바깥 월동도 되지만 실내에서는 찬바람이 직접 닿지 않게 해 주세요';
  if (low <= 5) return '$opt. $low°C까지는 견디니 겨울 베란다도 괜찮아요';
  return '$opt. $low°C 아래로 내려가면 잎이 상하니 겨울에는 창가에서 떨어뜨려 주세요';
}

/// 품종 정보 → 알아두면 좋은 정보 문장 (비료·분갈이는 2026-09-16 사용자 지시로 제외)
class CareTip {
  const CareTip(this.icon, this.text);

  final IconData icon;
  final String text;
}

List<CareTip> careTips(SpeciesRow s) {
  return [
    CareTip(Icons.water_drop_outlined, switch (s.category) {
      'succulent' =>
        '물은 ${s.baseWaterDays}일쯤에 한 번, 흙이 속까지 완전히 마른 뒤 흠뻑 주세요. 과습이 가장 흔한 실패 원인이에요',
      'herb' =>
        '물은 ${s.baseWaterDays}일쯤에 한 번, 겉흙이 마르면 바로 주세요. 허브는 마르면 잎이 금방 처져요',
      'flower' =>
        '물은 ${s.baseWaterDays}일쯤에 한 번, 겉흙이 마르면 주세요. 꽃이 피는 동안은 조금 더 자주 살펴 주세요',
      _ =>
        '물은 ${s.baseWaterDays}일쯤에 한 번, 화분 밑으로 흘러나올 만큼 흠뻑 주세요. 받침에 고인 물은 버려 주세요',
    }),
    CareTip(Icons.wb_sunny_outlined, switch (s.lightPref) {
      LightPref.low => '빛이 적은 곳에서도 잘 자라요. 직사광선은 잎을 태울 수 있으니 창가에서 조금 떨어뜨려 두세요',
      LightPref.med => '밝은 간접광을 좋아해요. 커튼을 친 창가나 창에서 1m 안쪽이 좋아요',
      LightPref.high => '햇빛을 많이 받아야 해요. 남향이나 동향 창가에 두고, 빛이 부족하면 웃자라요',
    }),
    if (s.tempMin != null && s.tempMax != null)
      CareTip(Icons.thermostat_outlined, temperatureTip(s)),
    for (final issue in s.commonIssues)
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
