import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../app/widgets/plant_card.dart';
import '../../core/enums.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/species_repository.dart';
import 'add_plant_draft.dart';

/// ADD-04 등록 마무리 (2026-09-16 사용자 지시로 간소화)
/// 필수: 이름 · 마지막 물 준 날. 화분 크기·배수구·공간은 "더 정확한 계산(선택)"에 접어 둔다.
class PlantEnvScreen extends ConsumerStatefulWidget {
  const PlantEnvScreen({super.key, required this.draft});

  final AddPlantDraft draft;

  @override
  ConsumerState<PlantEnvScreen> createState() => _PlantEnvScreenState();
}

class _PlantEnvScreenState extends ConsumerState<PlantEnvScreen> {
  static const _quickDays = [0, 1, 3, 7];

  late final _nickname = TextEditingController(
    text: widget.draft.nicknameHint ?? '',
  );
  PotSize _potSize = PotSize.m;
  bool _hasDrainage = true;
  int? _spaceId;
  DateTime _lastWatered = DateTime.now();
  bool _saving = false;
  bool _advanced = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastWatered,
      firstDate: now.subtract(const Duration(days: 60)),
      lastDate: now,
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) setState(() => _lastWatered = picked);
  }

  Future<void> _addSpace() async {
    final id = await context.push<int>(AppRoutes.spaceNew);
    if (id != null && mounted) setState(() => _spaceId = id);
  }

  Future<void> _submit() async {
    final name = _nickname.text.trim();
    if (name.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final id = await ref
          .read(plantRepositoryProvider)
          .create(
            nickname: name,
            speciesId: widget.draft.speciesId,
            spaceId: _spaceId,
            potSize: _potSize,
            hasDrainage: _hasDrainage,
            lastWateredAt: _lastWatered,
            photoPath: widget.draft.photoPath,
          );
      if (!mounted) return;
      context.go(AppRoutes.plant(id));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  static int _daysAgo(DateTime d) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(d.year, d.month, d.day)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final spaces = ref.watch(spacesProvider).value ?? const [];
    final speciesId = widget.draft.speciesId;
    final species = speciesId == null
        ? null
        : ref.watch(speciesByIdProvider(speciesId)).value;
    final preview = ref
        .read(plantRepositoryProvider)
        .computeFor(
          species: species,
          space: spaces.where((s) => s.id == _spaceId).firstOrNull,
          potSize: _potSize,
          hasDrainage: _hasDrainage,
        );
    final ago = _daysAgo(_lastWatered);
    final customDate = !_quickDays.contains(ago);

    return Scaffold(
      appBar: AppBar(title: const Text('내 식물로 등록')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          Row(
            children: [
              PlantThumb(
                size: AppSize.candidateThumb,
                photoPath: widget.draft.photoPath,
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species?.koNames.first ?? '품종 미지정',
                      style: AppText.title.copyWith(color: c.textPrimary),
                    ),
                    if (species != null)
                      Text(
                        species.scientificName,
                        style: AppText.scientificName.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.section),

          const _Label('이름'),
          TextField(
            controller: _nickname,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: '예: 거실 몬스테라'),
          ),
          const SizedBox(height: AppSpace.section),

          const _Label('마지막으로 물 준 날'),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final d in _quickDays)
                AppChip(
                  label: switch (d) {
                    0 => '오늘',
                    1 => '어제',
                    _ => '$d일 전',
                  },
                  selected: ago == d,
                  onTap: () => setState(
                    () => _lastWatered = DateTime.now().subtract(
                      Duration(days: d),
                    ),
                  ),
                ),
              AppChip(
                label: customDate
                    ? DateFormat('M월 d일', 'ko_KR').format(_lastWatered)
                    : '날짜 선택',
                selected: customDate,
                onTap: _pickDate,
              ),
            ],
          ),
          const SizedBox(height: AppSpace.section),

          Container(
            padding: const EdgeInsets.all(AppSpace.cardPadding),
            decoration: BoxDecoration(
              color: c.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Row(
              children: [
                Icon(Icons.water_drop_rounded, color: c.primary),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Text(
                    '약 ${preview.days}일마다 흙을 확인하도록 알려드려요. '
                    '흙 상태를 알려주시면 주기가 자동으로 맞춰져요',
                    style: AppText.bodyStrong.copyWith(color: c.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),

          InkWell(
            onTap: () => setState(() => _advanced = !_advanced),
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
              child: Row(
                children: [
                  Icon(
                    _advanced
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: c.textSecondary,
                  ),
                  const SizedBox(width: AppSpace.xs),
                  Text(
                    '더 정확한 계산 (선택)',
                    style: AppText.bodyStrong.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          if (_advanced) ...[
            const SizedBox(height: AppSpace.md),
            const _Label('화분 크기'),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final v in PotSize.values)
                  AppChip(
                    label: switch (v) {
                      PotSize.s => 'S · 15cm 이하',
                      PotSize.m => 'M · 15~25cm',
                      PotSize.l => 'L · 25cm 이상',
                    },
                    selected: _potSize == v,
                    onTap: () => setState(() => _potSize = v),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            const _Label('배수구'),
            Wrap(
              spacing: AppSpace.sm,
              children: [
                AppChip(
                  label: '있음',
                  selected: _hasDrainage,
                  onTap: () => setState(() => _hasDrainage = true),
                ),
                AppChip(
                  label: '없음',
                  selected: !_hasDrainage,
                  onTap: () => setState(() => _hasDrainage = false),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            const _Label('놓는 곳 (창 방향·거리)'),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final s in spaces)
                  AppChip(
                    label: s.name,
                    selected: _spaceId == s.id,
                    onTap: () => setState(
                      () => _spaceId = _spaceId == s.id ? null : s.id,
                    ),
                  ),
                AppChip(label: '+ 추가', selected: false, onTap: _addSpace),
              ],
            ),
          ],
          const SizedBox(height: AppSpace.section),
          SafeArea(
            top: false,
            child: AppButton.primary(
              label: '등록하기',
              onPressed: _nickname.text.trim().isEmpty || _saving
                  ? null
                  : _submit,
            ),
          ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.sm),
    child: Text(
      text,
      style: AppText.label.copyWith(color: context.colors.textSecondary),
    ),
  );
}
