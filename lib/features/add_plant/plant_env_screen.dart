import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../core/enums.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/species_repository.dart';
import 'add_plant_draft.dart';

/// ADD-04 환경 입력: 화분 크기 · 배수구 · 공간 · 마지막 물 준 날 · 별명
class PlantEnvScreen extends ConsumerStatefulWidget {
  const PlantEnvScreen({super.key, required this.draft});

  final AddPlantDraft draft;

  @override
  ConsumerState<PlantEnvScreen> createState() => _PlantEnvScreenState();
}

class _PlantEnvScreenState extends ConsumerState<PlantEnvScreen> {
  late final _nickname = TextEditingController(
    text: widget.draft.nicknameHint ?? '',
  );
  PotSize _potSize = PotSize.m;
  bool _hasDrainage = true;
  int? _spaceId;
  DateTime _lastWatered = DateTime.now();
  bool _saving = false;

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
      // 등록 플로우 스택 정리 후 상세로
      context.go(AppRoutes.plant(id));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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

    return Scaffold(
      appBar: AppBar(title: const Text('환경 입력')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          if (species != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(
              species.koNames.first,
              style: AppText.title.copyWith(color: c.textPrimary),
            ),
            Text(
              species.scientificName,
              style: AppText.scientificName.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.lg),
          ],
          _Label('별명'),
          TextField(
            controller: _nickname,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: '예: 거실 몬스테라'),
          ),
          const SizedBox(height: AppSpace.section),

          _Label('화분 크기'),
          _ChipRow<PotSize>(
            values: PotSize.values,
            selected: _potSize,
            label: (v) => switch (v) {
              PotSize.s => 'S · 지름 15cm 이하',
              PotSize.m => 'M · 15~25cm',
              PotSize.l => 'L · 25cm 이상',
            },
            onSelect: (v) => setState(() => _potSize = v),
          ),
          const SizedBox(height: AppSpace.section),

          _Label('배수구'),
          _ChipRow<bool>(
            values: const [true, false],
            selected: _hasDrainage,
            label: (v) => v ? '있음' : '없음',
            onSelect: (v) => setState(() => _hasDrainage = v),
          ),
          const SizedBox(height: AppSpace.section),

          _Label('공간'),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final s in spaces)
                AppChip(
                  label: s.name,
                  selected: _spaceId == s.id,
                  onTap: () =>
                      setState(() => _spaceId = _spaceId == s.id ? null : s.id),
                ),
              AppChip(label: '+ 공간 추가', selected: false, onTap: _addSpace),
            ],
          ),
          if (spaces.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: Text(
                '공간을 정하면 창 방향과 거리로 물주기를 더 정확히 계산해요',
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
            ),
          const SizedBox(height: AppSpace.section),

          _Label('마지막으로 물 준 날'),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(AppRadius.input),
            child: Container(
              height: AppSize.inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat(
                        'yyyy년 M월 d일 (E)',
                        'ko_KR',
                      ).format(_lastWatered),
                      style: AppText.body.copyWith(color: c.textPrimary),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: c.textSecondary,
                    size: AppSize.iconSm,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.section),

          // 계산 미리보기
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
                    '이 환경이면 약 ${preview.days}일마다 흙을 확인하도록 알려드려요',
                    style: AppText.bodyStrong.copyWith(color: c.primary),
                  ),
                ),
              ],
            ),
          ),
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

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelect,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpace.sm,
    runSpacing: AppSpace.sm,
    children: [
      for (final v in values)
        AppChip(
          label: label(v),
          selected: v == selected,
          onTap: () => onSelect(v),
        ),
    ],
  );
}
