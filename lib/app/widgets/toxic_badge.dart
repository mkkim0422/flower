import 'package:flutter/material.dart';

import '../../core/app_locale.dart';
import '../../core/enums.dart';
import '../theme.dart';

/// 위험 경고 (2026-09-17 사용자 결정: 정말 위험한 식물만 경고).
/// 가벼운 자극·안전한 식물에는 이 위젯을 띄우지 않는다.
class ToxicBadge extends StatelessWidget {
  const ToxicBadge({
    super.key,
    required this.toxicPet,
    required this.childLevel,
    this.note,
  });

  final bool toxicPet;
  final ChildToxicity childLevel;

  /// 원인·증상·대처 설명
  final String? note;

  String _label(AppLocalizations l) {
    if (childLevel == ChildToxicity.toxic) {
      return toxicPet ? l.dangerPetAndChild : l.dangerChild;
    }
    return l.dangerPet;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.warning_rounded, color: c.warning, size: AppSize.icon),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _label(context.l10n),
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
