import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../app/widgets/plant_card.dart';
import '../../core/enums.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/species_l10n.dart';
import '../../data/repositories/species_repository.dart';
import 'add_plant_draft.dart';

/// ADD-04 등록 마무리 (2026-09-16 사용자 지시로 간소화)
/// 이름 → 마지막 물 준 날(오늘/어제/직접 선택) → 주기(자동, 직접 수정 가능) → [선택] 더 정확한 계산 → 메모
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
  final _memo = TextEditingController();
  static const _potSize = PotSize.m; // 화분·배수구·공간 입력은 제외(사용자 지시) → 기본값
  static const _hasDrainage = true;
  int? _spaceId;
  DateTime _lastWatered = DateTime.now();
  int? _manualDays; // null = 자동
  bool _editInterval = false;
  bool _saving = false;

  @override
  void dispose() {
    _nickname.dispose();
    _memo.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastWatered,
      firstDate: now.subtract(const Duration(days: 60)),
      lastDate: now,
    );
    if (picked != null) setState(() => _lastWatered = picked);
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
            memo: _memo.text,
            manualDays: _manualDays,
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
    final speciesId = widget.draft.speciesId;
    final species = speciesId == null
        ? null
        : ref.watch(speciesByIdProvider(speciesId)).value;
    final auto = ref
        .read(plantRepositoryProvider)
        .computeFor(
          species: species,
          space: null,
          potSize: _potSize,
          hasDrainage: _hasDrainage,
        )
        .days;
    final days = _manualDays ?? auto;
    final ago = _daysAgo(_lastWatered);
    final customDate = ago > 1;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.registerTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          Row(
            children: [
              PlantThumb(
                size: AppSize.candidateThumb,
                photoPath: widget.draft.photoPath,
                fallbackUrl: species?.imageUrl,
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species?.displayName(context.l10n) ??
                          widget.draft.scientificName ??
                          context.l10n.speciesUnknown,
                      style: AppText.title.copyWith(color: c.textPrimary),
                    ),
                    if (species != null)
                      Text(
                        species.scientificName,
                        style: AppText.scientificName.copyWith(
                          color: c.textSecondary,
                        ),
                      )
                    else if (widget.draft.scientificName != null)
                      Text(
                        context.l10n.registerNotInCatalog,
                        style: AppText.caption.copyWith(color: c.textSecondary),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.section),

          _Label(context.l10n.registerName),
          TextField(
            controller: _nickname,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: context.l10n.registerNameHint,
            ),
          ),
          const SizedBox(height: AppSpace.section),

          _Label(context.l10n.registerLastWatered),
          Row(
            children: [
              Expanded(
                child: AppChip(
                  label: context.l10n.commonToday,
                  selected: ago == 0,
                  onTap: () => setState(() => _lastWatered = DateTime.now()),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: AppChip(
                  label: context.l10n.commonYesterday,
                  selected: ago == 1,
                  onTap: () => setState(
                    () => _lastWatered = DateTime.now().subtract(
                      const Duration(days: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: AppChip(
                  label: customDate
                      ? DateFormat.MMMd(
                          context.l10n.localeName,
                        ).format(_lastWatered)
                      : context.l10n.commonPickDate,
                  selected: customDate,
                  onTap: _pickDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.section),

          // 주기: 자동값 + 직접 수정
          Container(
            padding: const EdgeInsets.all(AppSpace.cardPadding),
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: c.primary),
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: Text(
                        '${context.l10n.registerInterval(days)}${_manualDays == null ? '' : context.l10n.registerIntervalManual}',
                        style: AppText.bodyStrong.copyWith(color: c.primary),
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.registerEditInterval,
                      onPressed: () =>
                          setState(() => _editInterval = !_editInterval),
                      icon: Icon(
                        _editInterval
                            ? Icons.expand_less_rounded
                            : Icons.edit_outlined,
                        color: c.primary,
                        size: AppSize.iconSm,
                      ),
                    ),
                  ],
                ),
                if (_editInterval) ...[
                  const SizedBox(height: AppSpace.sm),
                  Row(
                    children: [
                      _StepButton(
                        icon: Icons.remove_rounded,
                        onTap: days > 1
                            ? () => setState(() => _manualDays = days - 1)
                            : null,
                      ),
                      Expanded(
                        child: Text(
                          context.l10n.commonDays(days),
                          textAlign: TextAlign.center,
                          style: AppText.headline.copyWith(
                            color: c.primary,
                            fontFeatures: AppText.tabularFeatures,
                          ),
                        ),
                      ),
                      _StepButton(
                        icon: Icons.add_rounded,
                        onTap: days < AppSize.sliderMaxDays
                            ? () => setState(() => _manualDays = days + 1)
                            : null,
                      ),
                    ],
                  ),
                  if (_manualDays != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton.text(
                        label: context.l10n.registerBackToAuto(auto),
                        onPressed: () => setState(() => _manualDays = null),
                      ),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),

          const SizedBox(height: AppSpace.md),

          _Label(context.l10n.registerMemo),
          TextField(
            controller: _memo,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(hintText: context.l10n.memoHint),
          ),
          const SizedBox(height: AppSpace.section),
          SafeArea(
            top: false,
            child: AppButton.primary(
              label: context.l10n.registerSubmit,
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

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: onTap == null ? c.surfaceVariant : c.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSpace.minTouch,
          height: AppSpace.minTouch,
          child: Icon(icon, color: onTap == null ? c.textTertiary : c.primary),
        ),
      ),
    );
  }
}
