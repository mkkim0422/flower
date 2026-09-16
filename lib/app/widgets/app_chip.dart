import 'package:flutter/material.dart';

import '../theme.dart';

/// 선택형 칩 (DESIGN.md 4장 태그·칩). primaryContainer / 선택 시 primary 채움.
/// 터치 영역은 최소 44 확보.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSize.chipHeight + AppSpace.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppText.bodyStrong.copyWith(
            color: selected ? c.onPrimary : c.primary,
          ),
        ),
      ),
    );
  }
}
