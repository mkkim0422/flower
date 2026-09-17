import 'package:flutter/material.dart';

import '../../core/app_locale.dart';
import '../theme.dart';
import 'plant_card.dart';

/// 오늘 확인 카드 (홈 상단) — 체크박스(원형 24) + 썸네일 40 + 별명 bodyStrong + 공간명 caption
class TodayCheckTile extends StatelessWidget {
  const TodayCheckTile({
    super.key,
    required this.nickname,
    required this.spaceName,
    required this.selected,
    required this.onToggle,
    required this.onTap,
    this.photoPath,
  });

  final String nickname;
  final String? spaceName;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: selected ? c.primaryContainer : c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: selected ? c.primary : c.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.cardPadding,
            vertical: AppSpace.md,
          ),
          child: Row(
            children: [
              _RoundCheckbox(selected: selected, onTap: onToggle),
              const SizedBox(width: AppSpace.md),
              PlantThumb(size: AppSize.todayThumb, photoPath: photoPath),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (spaceName != null)
                      Text(
                        spaceName!,
                        style: AppText.caption.copyWith(color: c.textSecondary),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundCheckbox extends StatefulWidget {
  const _RoundCheckbox({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RoundCheckbox> createState() => _RoundCheckboxState();
}

class _RoundCheckboxState extends State<_RoundCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: AppMotion.check,
  );

  @override
  void didUpdateWidget(covariant _RoundCheckbox old) {
    super.didUpdateWidget(old);
    if (!old.selected && widget.selected) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // 체크 완료: scale 1 → 1.15 → 1 (DESIGN.md 6장)
    final scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1, end: AppMotion.checkScale),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: AppMotion.checkScale, end: 1),
        weight: 1,
      ),
    ]).animate(_ctrl);

    return Semantics(
      checked: widget.selected,
      label: context.l10n.semanticsSelect,
      child: InkWell(
        onTap: widget.onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSpace.minTouch,
          height: AppSpace.minTouch,
          child: Center(
            child: ScaleTransition(
              scale: scale,
              child: Container(
                width: AppSize.checkbox,
                height: AppSize.checkbox,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selected ? c.primary : Colors.transparent,
                  border: Border.all(
                    color: widget.selected ? c.primary : c.textTertiary,
                    width: AppSize.borderThin,
                  ),
                ),
                child: widget.selected
                    ? Icon(
                        Icons.check_rounded,
                        size: AppSize.iconXxs,
                        color: c.onPrimary,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
