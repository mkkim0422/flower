import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../core/enums.dart';
import '../../data/repositories/diary_repository.dart';
import '../../data/repositories/plant_repository.dart';
import '../../domain/image_prep.dart';

/// DIA-01 일기 작성: 사진(촬영/앨범) · 메모 · 상태 태그 · 대표 사진 설정
class DiaryWriteScreen extends ConsumerStatefulWidget {
  const DiaryWriteScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<DiaryWriteScreen> {
  final _memo = TextEditingController();
  final _picker = ImagePicker();
  final Set<DiaryTag> _tags = {};
  String? _photoPath;
  bool? _setAsCover; // null = 자동(대표 사진 없으면 true)
  bool _busy = false;

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final x = await _picker.pickImage(source: source, imageQuality: 92);
      if (x == null) return;
      final jpeg = await prepareForIdentification(await x.readAsBytes());
      final path = await savePhotoLocally(jpeg);
      if (mounted) setState(() => _photoPath = path);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진을 가져오지 못했어요')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (_busy) return;
    if (_photoPath == null && _memo.text.trim().isEmpty && _tags.isEmpty) {
      return;
    }
    setState(() => _busy = true);
    try {
      final plant = await ref
          .read(plantRepositoryProvider)
          .getById(widget.plantId);
      await ref
          .read(diaryRepositoryProvider)
          .add(
            plantId: widget.plantId,
            photoPath: _photoPath,
            memo: _memo.text,
            tags: _tags.toList(),
          );
      final cover = _setAsCover ?? (plant?.plant.photoPath == null);
      if (_photoPath != null && cover) {
        await ref
            .read(plantRepositoryProvider)
            .updateBasic(id: widget.plantId, photoPath: Value(_photoPath));
      }
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final plant = ref.watch(plantByIdProvider(widget.plantId)).value;
    final hasCover = plant?.plant.photoPath != null;
    final cover = _setAsCover ?? !hasCover;
    final canSave =
        _photoPath != null || _memo.text.trim().isNotEmpty || _tags.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(plant == null ? '일기 쓰기' : '${plant.plant.nickname} 일기'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          // 사진
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Material(
              color: c.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.card),
              clipBehavior: Clip.antiAlias,
              child: _photoPath == null
                  ? Row(
                      children: [
                        Expanded(
                          child: _PickTile(
                            icon: Icons.photo_camera_rounded,
                            label: '사진 찍기',
                            onTap: _busy
                                ? null
                                : () => _pick(ImageSource.camera),
                          ),
                        ),
                        VerticalDivider(width: 1, color: c.outline),
                        Expanded(
                          child: _PickTile(
                            icon: Icons.photo_library_outlined,
                            label: '앨범',
                            onTap: _busy
                                ? null
                                : () => _pick(ImageSource.gallery),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(_photoPath!), fit: BoxFit.cover),
                        Positioned(
                          top: AppSpace.sm,
                          right: AppSpace.sm,
                          child: IconButton.filledTonal(
                            onPressed: () => setState(() => _photoPath = null),
                            icon: const Icon(Icons.close_rounded),
                            tooltip: '사진 지우기',
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_photoPath != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: cover,
              activeThumbColor: c.primary,
              title: Text(
                '대표 사진으로 설정',
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
              onChanged: (v) => setState(() => _setAsCover = v),
            ),
          const SizedBox(height: AppSpace.lg),

          Text('상태', style: AppText.label.copyWith(color: c.textSecondary)),
          const SizedBox(height: AppSpace.sm),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final t in DiaryTag.values)
                AppChip(
                  label: t.label,
                  selected: _tags.contains(t),
                  onTap: () => setState(() {
                    if (!_tags.remove(t)) _tags.add(t);
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.section),

          Text('메모', style: AppText.label.copyWith(color: c.textSecondary)),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: _memo,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: '오늘 식물은 어땠나요?'),
          ),
          const SizedBox(height: AppSpace.section),
          SafeArea(
            top: false,
            child: AppButton.primary(
              label: '저장',
              onPressed: canSave && !_busy ? _save : null,
            ),
          ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSpace.xxl, color: c.primary),
          const SizedBox(height: AppSpace.sm),
          Text(label, style: AppText.bodyStrong.copyWith(color: c.primary)),
        ],
      ),
    );
  }
}
