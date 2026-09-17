import 'package:flutter/material.dart';

import '../../core/enums.dart';
import '../theme.dart';

/// 독성 배지 (도감 정보 첫 줄) — DESIGN.md 4장. 반려동물(ASPCA) + 아이 3단계.
class ToxicBadge extends StatelessWidget {
  const ToxicBadge({
    super.key,
    required this.toxicPet,
    required this.childLevel,
    this.note,
  });

  final bool toxicPet;
  final ChildToxicity childLevel;

  /// 원인·증상·대처 설명 (있으면 배지 아래 표시)
  final String? note;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (label, icon, color) = switch ((toxicPet, childLevel)) {
      (true, ChildToxicity.toxic) => (
        '반려동물·아이에게 독성',
        Icons.warning_rounded,
        c.warning,
      ),
      (true, ChildToxicity.irritant) => (
        '반려동물에게 독성 · 아이는 삼키면 입·피부 자극',
        Icons.warning_rounded,
        c.warning,
      ),
      (true, ChildToxicity.none) => (
        '반려동물에게 독성 · 아이에게는 안전',
        Icons.warning_rounded,
        c.warning,
      ),
      (false, ChildToxicity.toxic) => (
        '아이에게 독성',
        Icons.warning_rounded,
        c.warning,
      ),
      (false, ChildToxicity.irritant) => (
        '삼키면 입·피부 자극 (주의)',
        Icons.info_rounded,
        c.textSecondary,
      ),
      (false, ChildToxicity.none) => (
        '독성 없음',
        Icons.check_circle_rounded,
        c.statusOk,
      ),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: AppSize.icon),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.bodyStrong.copyWith(color: c.textPrimary),
              ),
              if (note != null && note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpace.xs),
                  child: Text(
                    note!,
                    style: AppText.caption.copyWith(color: c.textSecondary),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
