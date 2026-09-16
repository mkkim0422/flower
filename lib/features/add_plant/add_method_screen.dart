import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';

/// ADD-01 식물 추가 방법 선택
class AddMethodScreen extends StatelessWidget {
  const AddMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('식물 추가')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          const SizedBox(height: AppSpace.sm),
          Text(
            '어떻게 등록할까요?',
            style: AppText.body.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpace.lg),
          _MethodCard(
            icon: Icons.photo_camera_rounded,
            title: '사진으로 식별',
            subtitle: '잎 전체가 나오게 찍으면 품종을 찾아드려요',
            onTap: () => context.go(AppRoutes.camera),
          ),
          const SizedBox(height: AppSpace.cardGap),
          _MethodCard(
            icon: Icons.search_rounded,
            title: '이름으로 검색',
            subtitle: '국내 유통명이나 학명으로 찾아요',
            onTap: () => context.push(AppRoutes.addSearch),
          ),
          const SizedBox(height: AppSpace.cardGap),
          _MethodCard(
            icon: Icons.edit_outlined,
            title: '직접 입력',
            subtitle: '품종을 몰라도 이름만으로 등록해요',
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
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: c.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.cardPadding),
          child: Row(
            children: [
              Container(
                width: AppSize.plantThumb,
                height: AppSize.plantThumb,
                decoration: BoxDecoration(
                  color: c.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.thumbnail),
                ),
                child: Icon(icon, color: c.primary),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.title.copyWith(color: c.textPrimary)),
                    const SizedBox(height: AppSpace.xs / 2),
                    Text(subtitle,
                        style: AppText.caption.copyWith(color: c.textSecondary)),
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
