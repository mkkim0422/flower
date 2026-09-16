import 'package:flutter/material.dart';

import '../theme.dart';

/// 독성 배지 (도감 정보 첫 줄) — DESIGN.md 4장
class ToxicBadge extends StatelessWidget {
  const ToxicBadge({super.key, required this.toxicPet, required this.toxicChild});

  final bool toxicPet;
  final bool toxicChild;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final toxic = toxicPet || toxicChild;
    final label = switch ((toxicPet, toxicChild)) {
      (true, true) => '반려동물·아이에게 독성',
      (true, false) => '반려동물에게 독성',
      (false, true) => '아이에게 독성',
      (false, false) => '독성 없음',
    };
    return Row(
      children: [
        Icon(
          toxic ? Icons.warning_rounded : Icons.check_circle_rounded,
          color: toxic ? c.warning : c.statusOk,
          size: AppSize.icon,
        ),
        const SizedBox(width: AppSpace.sm),
        Text(label, style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
      ],
    );
  }
}
