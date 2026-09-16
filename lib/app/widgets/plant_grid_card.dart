import 'package:flutter/material.dart';

import '../theme.dart';
import 'plant_card.dart';
import 'status_dot.dart';

/// 앨범형 식물 카드 (2열 그리드). 정사각 사진 + 별명 + 상태.
class PlantGridCard extends StatelessWidget {
  const PlantGridCard({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (_, box) => PlantThumb(
                  size: box.maxWidth,
                  photoPath: photoPath,
                  radius: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    speciesName,
                    style: AppText.caption.copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpace.xs),
                  StatusDot(status: status, label: statusLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
