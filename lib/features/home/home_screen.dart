import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../app/widgets/empty_state.dart';
import '../../data/db/database_provider.dart';

/// HOME-01. M0에서는 스캐폴드 + 빈 상태만. 오늘 확인·내 식물 목록은 M1.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final db = ref.watch(databaseProvider);
    final plantCount = db.select(db.plants).watch().map((rows) => rows.length);
    final dateLabel = DateFormat('M월 d일 EEEE', 'ko_KR').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpace.lg),
              Text('오늘', style: AppText.headline.copyWith(color: c.textPrimary)),
              const SizedBox(height: AppSpace.xs),
              Text(
                dateLabel,
                style: AppText.caption.copyWith(color: c.textSecondary),
              ),
              Expanded(
                child: StreamBuilder<int>(
                  stream: plantCount,
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    if (count == 0) {
                      return EmptyState(
                        title: '첫 식물을 등록해 보세요',
                        description: '사진을 찍으면 어떤 식물인지 알려드려요',
                        actionLabel: '사진 찍기',
                        onAction: null, // M2 CAM-01 연결
                      );
                    }
                    // M1: 오늘 확인 카드 + 내 식물 목록
                    return Center(
                      child: Text(
                        '내 식물 $count',
                        style: AppText.title.copyWith(color: c.textPrimary),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
