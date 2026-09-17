import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_locale.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_chip.dart';
import '../../core/enums.dart';
import '../../data/repositories/space_repository.dart';

/// SPC-02 공간 추가/편집: 이름 · 창 방향 · 창과의 거리. 저장 시 id 를 pop 으로 반환.
class SpaceEditScreen extends ConsumerStatefulWidget {
  const SpaceEditScreen({super.key, this.spaceId});

  final int? spaceId;

  @override
  ConsumerState<SpaceEditScreen> createState() => _SpaceEditScreenState();
}

class _SpaceEditScreenState extends ConsumerState<SpaceEditScreen> {
  final _name = TextEditingController();
  WindowDir _dir = WindowDir.s;
  WindowDist _dist = WindowDist.near;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.spaceId != null) {
      ref.read(spaceRepositoryProvider).byId(widget.spaceId!).then((s) {
        if (s != null && mounted) {
          setState(() {
            _name.text = s.name;
            _dir = s.windowDir;
            _dist = s.windowDist;
            _loaded = true;
          });
        }
      });
    } else {
      _loaded = true;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(spaceRepositoryProvider);
      int id;
      if (widget.spaceId == null) {
        id = await repo.create(name: name, windowDir: _dir, windowDist: _dist);
      } else {
        id = widget.spaceId!;
        await repo.update(
          id: id,
          name: name,
          windowDir: _dir,
          windowDist: _dist,
        );
      }
      if (mounted) context.pop(id);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.spaceDeleteQ),
        content: Text(context.l10n.spaceDeleteBody),
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
    if (ok == true && widget.spaceId != null) {
      await ref.read(spaceRepositoryProvider).delete(widget.spaceId!);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isEdit = widget.spaceId != null;
    final dirIsNone = _dir == WindowDir.none;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? context.l10n.spaceEditTitle : context.l10n.spaceAddTitle,
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: c.error),
              onPressed: _delete,
            ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
              children: [
                const SizedBox(height: AppSpace.sm),
                Text(
                  context.l10n.spaceName,
                  style: AppText.label.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.sm),
                TextField(
                  controller: _name,
                  autofocus: !isEdit,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: context.l10n.spaceNameHint,
                  ),
                ),
                const SizedBox(height: AppSpace.section),
                Text(
                  context.l10n.spaceWindowDir,
                  style: AppText.label.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.sm),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: [
                    for (final d in WindowDir.values)
                      AppChip(
                        label: d.label(context.l10n),
                        selected: _dir == d,
                        onTap: () => setState(() => _dir = d),
                      ),
                  ],
                ),
                if (!dirIsNone) ...[
                  const SizedBox(height: AppSpace.section),
                  Text(
                    context.l10n.spaceWindowDist,
                    style: AppText.label.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Wrap(
                    spacing: AppSpace.sm,
                    runSpacing: AppSpace.sm,
                    children: [
                      for (final d in WindowDist.values)
                        AppChip(
                          label: d.label(context.l10n),
                          selected: _dist == d,
                          onTap: () => setState(() => _dist = d),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpace.md),
                Text(
                  context.l10n.spaceLightInfo,
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.section),
                SafeArea(
                  top: false,
                  child: AppButton.primary(
                    label: isEdit
                        ? context.l10n.commonSave
                        : context.l10n.spaceAdd,
                    onPressed: _name.text.trim().isEmpty || _saving
                        ? null
                        : _save,
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
              ],
            ),
    );
  }
}
