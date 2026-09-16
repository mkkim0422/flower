import 'package:flutter/material.dart';

import '../theme.dart';

/// 카드 (DESIGN.md 3장): surface, radius 16, outline 1px, 그림자 없음, 내부 패딩 16.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpace.cardPadding),
    this.filled = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// true 면 primaryContainer 배경 (선택·강조 상태)
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: filled ? c.primaryContainer : c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: filled ? c.primaryContainer : c.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
