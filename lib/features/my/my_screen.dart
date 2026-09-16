import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// MY-01. M0 플레이스홀더. 통계·백업·알림 설정은 M3/M4.
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

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
              Text(
                'MY',
                style: AppText.headline.copyWith(color: c.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
