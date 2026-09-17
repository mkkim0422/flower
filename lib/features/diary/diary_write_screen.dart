import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_locale.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.commonPhotoLoadFailed)),
        );
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
        title: Text(
          plant == null
              ? context.l10n.diaryWriteTitle
              : context.l10n.diaryWriteTitleFor(plant.plant.nickname),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          // 사진: 없으면 버튼 2개, 있으면 미리보기
          if (_photoPath == null)
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: context.l10n.commonTakePhoto,
                    icon: Icons.photo_camera_rounded,
                    onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: AppButton.secondary(
                    label: context.l10n.commonAlbum,
                    icon: Icons.photo_library_outlined,
                    onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  ),
                ),
              ],
            )
          else
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(_photoPath!), fit: BoxFit.cover),
                    Positioned(
                      top: AppSpace.sm,
                      right: AppSpace.sm,
                      child: IconButton.filledTonal(
                        onPressed: () => setState(() => _photoPath = null),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: context.l10n.diaryRemovePhoto,
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
                context.l10n.diarySetCover,
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
              onChanged: (v) => setState(() => _setAsCover = v),
            ),
          const SizedBox(height: AppSpace.lg),

          Text(
            context.l10n.diaryLabel,
            style: AppText.label.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: _memo,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: context.l10n.diaryHint),
          ),
          const SizedBox(height: AppSpace.section),
          SafeArea(
            top: false,
            child: AppButton.primary(
              label: context.l10n.commonSave,
              onPressed: canSave && !_busy ? _save : null,
            ),
          ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}
