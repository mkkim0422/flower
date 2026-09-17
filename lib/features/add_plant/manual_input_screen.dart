import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import 'add_plant_draft.dart';

/// ADD-03 직접 입력 — 이름만 입력, 품종 미지정(기본 주기 7일)
class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key, this.draft});

  final AddPlantDraft? draft;

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  late final _controller = TextEditingController(
    text: widget.draft?.nicknameHint ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    context.push(
      AppRoutes.addEnv,
      extra: AddPlantDraft(
        nicknameHint: name,
        photoPath: widget.draft?.photoPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.commonManualEntry)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpace.sm),
            Text(
              context.l10n.manualPlantName,
              style: AppText.label.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.sm),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _next(),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: context.l10n.manualHint),
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              context.l10n.manualInfo,
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
            const Spacer(),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.lg),
                child: AppButton.primary(
                  label: context.l10n.commonNext,
                  onPressed: _controller.text.trim().isEmpty ? null : _next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
