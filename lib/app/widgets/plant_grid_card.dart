import 'package:flutter/material.dart';

import '../theme.dart';
import 'plant_card.dart';
import 'status_dot.dart';

/// 앨범형 식물 카드 (2열 그리드). 정사각 사진 + 별명 + 상태.
class PlantGridCard extends StatelessWidget {
  /// 글자 영역 높이 (패딩 + bodyStrong 22 + 간격 4 + 상태 18) × 글자 배율 + 테두리
  static double textBlockHeight(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return AppSpace.md * 2 + (22 + AppSpace.xs + 18) * scale + 2;
  }

  /// 타일 폭 → 타일 전체 높이 (사진 정사각 + 글자 영역)
  static double extentFor(BuildContext context, double tileWidth) =>
      tileWidth + textBlockHeight(context);

  const PlantGridCard({
    super.key,
    required this.nickname,
    required this.speciesName,
    required this.status,
    required this.statusLabel,
    this.photoPath,
    this.fallbackUrl,
    this.onTap,
  });

  final String? fallbackUrl;

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
            Expanded(
              child: LayoutBuilder(
                builder: (_, box) => SizedBox(
                  width: box.maxWidth,
                  height: box.maxHeight,
                  child: PlantThumb(
                    size: box.maxWidth,
                    photoPath: photoPath,
                    fallbackUrl: fallbackUrl,
                    radius: 0,
                  ),
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
