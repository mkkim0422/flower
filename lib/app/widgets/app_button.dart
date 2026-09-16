import 'package:flutter/material.dart';

import '../theme.dart';

enum AppButtonKind { primary, secondary, text, destructive }

/// 버튼 (DESIGN.md 4장). Primary는 화면당 1개, 전체 폭.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.icon,
    this.expanded = true,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  }) : kind = AppButtonKind.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  }) : kind = AppButtonKind.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  }) : kind = AppButtonKind.text;

  const AppButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  }) : kind = AppButtonKind.destructive;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final (Color bg, Color fg, double height) = switch (kind) {
      AppButtonKind.primary => (c.primary, c.onPrimary, AppSize.buttonHeight),
      AppButtonKind.secondary => (
        c.primaryContainer,
        c.primary,
        AppSize.buttonHeight,
      ),
      AppButtonKind.text => (
        Colors.transparent,
        c.primary,
        AppSize.textButtonHeight,
      ),
      AppButtonKind.destructive => (
        Colors.transparent,
        c.error,
        AppSize.textButtonHeight,
      ),
    };

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppSize.iconSm, color: fg),
          const SizedBox(width: AppSpace.sm),
        ],
        Text(label),
      ],
    );

    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: 0.08)),
      minimumSize: WidgetStatePropertyAll(
        Size(expanded ? double.infinity : AppSpace.minTouch, height),
      ),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(height)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpace.lg),
      ),
      textStyle: const WidgetStatePropertyAll(AppText.bodyStrong),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
    );

    final button = switch (kind) {
      AppButtonKind.primary || AppButtonKind.secondary => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      AppButtonKind.text || AppButtonKind.destructive => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
