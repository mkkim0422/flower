import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/plant_card.dart';
import '../../app/widgets/toxic_badge.dart';
import '../../core/enums.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/space_repository.dart';
import '../home/soil_check_sheet.dart';
import 'interval_sheet.dart';

/// PLT-01 식물 상세
class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final entryAsync = ref.watch(plantByIdProvider(plantId));

    return entryAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('불러오지 못했어요', style: AppText.body.copyWith(color: c.textSecondary)),
        ),
      ),
      data: (entry) {
        if (entry == null) {
          // 삭제됨
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('삭제된 식물이에요', style: AppText.body.copyWith(color: c.textSecondary)),
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
        title: const Text('별명 바꾸기'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(plantRepositoryProvider).updateBasic(id: entry.plant.id, nickname: name);
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
        padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, AppSpace.xl),
        children: [
          Text('공간 이동', style: AppText.title.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpace.md),
          for (final s in spaces)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.name, style: AppText.body.copyWith(color: c.textPrimary)),
              subtitle: Text('${s.windowDir.label} · ${s.windowDist.label}',
                  style: AppText.caption.copyWith(color: c.textSecondary)),
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
            title: Text('공간 미지정', style: AppText.body.copyWith(color: c.textPrimary)),
            trailing: entry.plant.spaceId == null ? Icon(Icons.check_rounded, color: c.primary) : null,
            onTap: () async {
              await ref
                  .read(plantRepositoryProvider)
                  .updateBasic(id: entry.plant.id, spaceId: const Value(null));
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
          const SizedBox(height: AppSpace.sm),
          AppButton.secondary(
            label: '+ 새 공간 추가',
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

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${entry.plant.nickname}을(를) 삭제할까요?'),
        content: const Text('관리 이력과 일기도 함께 지워져요'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
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
    final events = ref.watch(careEventsProvider(p.id)).value ?? const [];

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
              const PopupMenuItem(value: 'rename', child: Text('별명 바꾸기')),
              const PopupMenuItem(value: 'space', child: Text('공간 이동')),
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
          // 헤더: 사진 4:3 + 별명 + 품종·학명
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: PlantThumb(size: double.infinity, photoPath: p.photoPath, radius: 0),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(p.nickname, style: AppText.headline.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpace.xs),
          Text(
            s == null
                ? '품종 미지정 · ${entry.space?.name ?? '공간 미지정'}'
                : '${s.koNames.first} · ${entry.space?.name ?? '공간 미지정'}',
            style: AppText.caption.copyWith(color: c.textSecondary),
          ),
          if (s != null)
            Text(s.scientificName,
                style: AppText.scientificName.copyWith(color: c.textSecondary)),
          const SizedBox(height: AppSpace.section),

          // 카드1: 다음 확인 D-day + 관리 일정
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dDay <= 0 ? '오늘 흙을 확인해 주세요' : '다음 확인까지',
                        style: AppText.body.copyWith(color: c.textSecondary),
                      ),
                    ),
                    Text(
                      dDay <= 0 ? 'D-day' : 'D-$dDay',
                      style: AppText.headline.copyWith(
                        color: dDay <= 0 ? c.statusNeedCheck : c.primary,
                        fontFeatures: AppText.tabularFeatures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                const Divider(),
                const SizedBox(height: AppSpace.md),
                _ScheduleLine(
                  icon: Icons.water_drop_outlined,
                  label: '물',
                  value: '${p.waterIntervalDays}일마다 ${p.manualOverride ? '(수동)' : '(자동)'}',
                  onTap: () => showIntervalSheet(context, entry: entry, result: result),
                ),
                _ScheduleLine(
                  icon: Icons.eco_outlined,
                  label: '비료',
                  value: p.fertIntervalDays == null
                      ? '정보 없음'
                      : '${p.fertIntervalDays}일마다'
                          '${p.lastFertAt == null ? '' : ' · 마지막 ${DateFormat('M/d').format(p.lastFertAt!)}'}',
                  onTap: () => ref.read(plantRepositoryProvider).addCareEvent(p.id, CareType.fert),
                  actionLabel: '줬어요',
                ),
                _ScheduleLine(
                  icon: Icons.yard_outlined,
                  label: '분갈이',
                  value: s?.repotMonths == null
                      ? '정보 없음'
                      : '${s!.repotMonths}개월마다'
                          '${p.repotAt == null ? '' : ' · 마지막 ${DateFormat('yyyy/M').format(p.repotAt!)}'}',
                  onTap: () => ref.read(plantRepositoryProvider).addCareEvent(p.id, CareType.repot),
                  actionLabel: '했어요',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 카드2: 관리 이력 (생장 일기 타임라인은 M3)
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('관리 이력', style: AppText.title.copyWith(color: c.textPrimary)),
                const SizedBox(height: AppSpace.md),
                if (events.isEmpty)
                  Text('아직 기록이 없어요', style: AppText.body.copyWith(color: c.textTertiary))
                else
                  for (final e in events.take(5)) _EventLine(event: e),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 카드3: 도감 정보 (독성 배지 첫 줄). 전체 페이지 INFO-01은 M3
          if (s != null)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToxicBadge(toxicPet: s.toxicPet, toxicChild: s.toxicChild),
                  const SizedBox(height: AppSpace.md),
                  _InfoLine(
                    icon: Icons.water_drop_outlined,
                    text: '기본 ${s.baseWaterDays}일마다 · 겉흙이 마르면',
                  ),
                  _InfoLine(
                    icon: Icons.wb_sunny_outlined,
                    text: switch (s.lightPref) {
                      LightPref.low => '빛 적어도 괜찮아요',
                      LightPref.med => '밝은 간접광',
                      LightPref.high => '햇빛 많이',
                    },
                  ),
                  if (s.tempMin != null && s.tempMax != null)
                    _InfoLine(
                      icon: Icons.thermostat_outlined,
                      text: '${s.tempMin}~${s.tempMax}°C',
                    ),
                  for (final issue in s.commonIssues.take(2))
                    _InfoLine(icon: Icons.error_outline_rounded, text: issue),
                ],
              ),
            ),
          const SizedBox(height: AppSpace.section),
          SafeArea(
            top: false,
            child: dDay <= 0
                ? AppButton.primary(
                    label: '흙 확인하기',
                    onPressed: () => showSoilCheckSheet(context, entries: [entry]),
                  )
                : AppButton.primary(
                    label: '일기 쓰기',
                    onPressed: null, // M3 DIA-01
                  ),
          ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpace.cardPadding),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.outline),
      ),
      child: child,
    );
  }
}

class _ScheduleLine extends StatelessWidget {
  const _ScheduleLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.actionLabel = '조정',
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: c.textSecondary),
          const SizedBox(width: AppSpace.sm),
          SizedBox(
            width: 48,
            child: Text(label, style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
          ),
          Expanded(child: Text(value, style: AppText.body.copyWith(color: c.textSecondary))),
          AppButton.text(label: actionLabel, onPressed: onTap),
        ],
      ),
    );
  }
}

class _EventLine extends StatelessWidget {
  const _EventLine({required this.event});

  final CareEvent event;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (icon, label) = switch (event.type) {
      CareType.water => (Icons.water_drop_rounded, '물 줌'),
      CareType.fert => (Icons.eco_rounded, '비료'),
      CareType.repot => (Icons.yard_rounded, '분갈이'),
      CareType.wipe => (Icons.cleaning_services_rounded, '잎 닦기'),
      CareType.checkDry => (Icons.check_circle_outline_rounded, '흙 확인 · 말랐음'),
      CareType.checkWet => (Icons.opacity_rounded, '흙 확인 · 촉촉함'),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.primary),
          const SizedBox(width: AppSpace.sm),
          Expanded(child: Text(label, style: AppText.body.copyWith(color: c.textPrimary))),
          Text(
            DateFormat('M/d').format(event.at),
            style: AppText.caption.copyWith(
              color: c.textTertiary,
              fontFeatures: AppText.tabularFeatures,
            ),
          ),
        ],
      ),
    );
  }
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
          Icon(icon, size: 18, color: c.textSecondary),
          const SizedBox(width: AppSpace.sm),
          Expanded(child: Text(text, style: AppText.body.copyWith(color: c.textPrimary))),
        ],
      ),
    );
  }
}
