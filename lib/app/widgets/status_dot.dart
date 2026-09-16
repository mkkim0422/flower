import 'package:flutter/material.dart';

import '../theme.dart';

/// 식물 상태. 색은 AppColors status 토큰.
enum PlantStatus { needCheck, ok, unknown }

/// 상태 점 8px + 라벨 (DESIGN.md 4장). 텍스트 없이 단독 사용 금지.
class StatusDot extends StatelessWidget {
  const StatusDot({super.key, required this.status, required this.label});

  final PlantStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (status) {
      PlantStatus.needCheck => c.statusNeedCheck,
      PlantStatus.ok => c.statusOk,
      PlantStatus.unknown => c.statusUnknown,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.statusDot,
          height: AppSize.statusDot,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpace.xs + AppSpace.xs / 2),
        Text(
          label,
          style: AppText.caption.copyWith(
            color: c.textSecondary,
            fontFeatures: AppText.tabularFeatures,
          ),
        ),
      ],
    );
  }
}
