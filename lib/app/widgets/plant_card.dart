import 'dart:io';

import 'package:flutter/material.dart';

import '../theme.dart';
import 'status_dot.dart';

/// 식물 썸네일 (사진 없으면 surfaceVariant + 잎 아이콘)
class PlantThumb extends StatelessWidget {
  const PlantThumb({
    super.key,
    required this.size,
    this.photoPath,
    this.radius = AppRadius.thumbnail,
  });

  final double size;
  final String? photoPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final file = photoPath == null ? null : File(photoPath!);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: file != null && file.existsSync()
            ? Image.file(file, fit: BoxFit.cover)
            : ColoredBox(
                color: c.surfaceVariant,
                child: Icon(
                  Icons.eco_outlined,
                  size: size * 0.45,
                  color: c.textTertiary,
                ),
              ),
      ),
    );
  }
}

/// 식물 카드 (홈 목록) — DESIGN.md 4장. 높이 88, 좌우 패딩 16, outline 테두리.
class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.nickname,
    required this.speciesName,
    required this.status,
    required this.statusLabel,
    this.photoPath,
    this.onTap,
  });

  final String nickname;
  final String speciesName;
  final PlantStatus status;
  final String statusLabel;
  final String? photoPath;
  final VoidCallback? onTap;

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
        child: SizedBox(
          height: AppSize.plantCardHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.cardPadding),
            child: Row(
              children: [
                PlantThumb(size: AppSize.plantThumb, photoPath: photoPath),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname,
                        style: AppText.title.copyWith(color: c.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpace.xs / 2),
                      Text(
                        speciesName,
                        style: AppText.caption.copyWith(color: c.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                StatusDot(status: status, label: statusLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
