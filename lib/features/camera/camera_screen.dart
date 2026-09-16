import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// CAM-01. M0 플레이스홀더. 촬영/앨범·식별 파이프라인은 M2.
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpace.lg),
              Text('카메라', style: AppText.headline.copyWith(color: c.textPrimary)),
              const SizedBox(height: AppSpace.xs),
              Text(
                '잎 전체가 나오게 찍어 주세요',
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
