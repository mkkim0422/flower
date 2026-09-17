import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_card.dart';

/// ADD-01 식물 추가 방법 선택
class AddMethodScreen extends StatelessWidget {
  const AddMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          const SizedBox(height: AppSpace.sm),
          Text(
            context.l10n.addHowTo,
            style: AppText.body.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.lg),
          _MethodCard(
            icon: Icons.photo_camera_rounded,
            title: context.l10n.addByPhoto,
            subtitle: context.l10n.addByPhotoSub,
            onTap: () => context.go(AppRoutes.camera),
          ),
          const SizedBox(height: AppSpace.cardGap),
          _MethodCard(
            icon: Icons.search_rounded,
            title: context.l10n.commonSearchByName,
            subtitle: context.l10n.addByNameSub,
            onTap: () => context.push(AppRoutes.addSearch),
          ),
          const SizedBox(height: AppSpace.cardGap),
          _MethodCard(
            icon: Icons.edit_outlined,
            title: context.l10n.commonManualEntry,
            subtitle: context.l10n.addManualSub,
            onTap: () => context.push(AppRoutes.addManual),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: AppSize.plantThumb,
            height: AppSize.plantThumb,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.thumbnail),
            ),
            child: Icon(icon, color: c.primary),
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.title.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpace.xs / 2),
                Text(
                  subtitle,
                  style: AppText.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c.textTertiary),
        ],
      ),
    );
  }
}
