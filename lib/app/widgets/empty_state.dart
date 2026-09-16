import 'package:flutter/material.dart';

import '../theme.dart';
import 'app_button.dart';

/// 빈 상태 (DESIGN.md 4장): 일러스트 120 + 제목 title + 설명 body + Primary 버튼 1개
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    this.icon = Icons.eco_outlined,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onAction;

  /// 단색 라인 일러스트 대체 아이콘. 추후 SVG 일러스트로 교체.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSize.emptyIllustration, color: c.textTertiary),
            const SizedBox(height: AppSpace.xl),
            Text(
              title,
              style: AppText.title.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              description,
              style: AppText.body.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.xl),
            AppButton.primary(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}
