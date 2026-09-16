import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_card.dart';
import '../../app/widgets/toxic_badge.dart';
import '../../core/enums.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/species_repository.dart';
import '../add_plant/add_plant_draft.dart';

/// INFO-01 도감 정보. 순서 고정: 독성 → 물 → 빛 → 온도 → 흔한 문제 → "내 식물로 등록"
/// (비료·분갈이는 2026-09-16 사용자 지시로 표시하지 않음)
class SpeciesInfoScreen extends ConsumerWidget {
  const SpeciesInfoScreen({
    super.key,
    required this.speciesId,
    this.showRegister = true,
  });

  final int speciesId;
  final bool showRegister;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(speciesByIdProvider(speciesId));
    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            '불러오지 못했어요',
            style: AppText.body.copyWith(color: c.textSecondary),
          ),
        ),
      ),
      data: (s) {
        if (s == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                '도감에 없는 품종이에요',
                style: AppText.body.copyWith(color: c.textSecondary),
              ),
            ),
          );
        }
        return _Body(s: s, showRegister: showRegister);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.s, required this.showRegister});

  final SpeciesRow s;
  final bool showRegister;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final category = switch (s.category) {
      'succulent' => '다육·선인장',
      'herb' => '허브',
      'flower' => '꽃',
      'other' => '기타',
      _ => '관엽',
    };
    return Scaffold(
      appBar: AppBar(title: const Text('도감')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          Text(
            s.koNames.first,
            style: AppText.headline.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            s.scientificName,
            style: AppText.scientificName.copyWith(color: c.textSecondary),
          ),
          if (s.koNames.length > 1)
            Text(
              '다른 이름: ${s.koNames.skip(1).join(', ')}',
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
          const SizedBox(height: AppSpace.sm),
          Text(
            '$category${s.family == null ? '' : ' · ${s.family}'}',
            style: AppText.caption.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: AppSpace.section),

          // 1. 독성 (항상 최상단)
          AppCard(
            child: ToxicBadge(toxicPet: s.toxicPet, toxicChild: s.toxicChild),
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 2. 물
          _Section(
            icon: Icons.water_drop_outlined,
            title: '물',
            lines: [
              '기본 ${s.baseWaterDays}일마다',
              switch (s.category) {
                'succulent' => '흙이 속까지 완전히 마른 뒤 흠뻑. 과습이 가장 흔한 실패 원인이에요',
                'herb' => '겉흙이 마르면 바로. 마르면 잎이 금방 처져요',
                'flower' => '겉흙이 마르면. 꽃이 피는 동안은 조금 더 자주 살펴 주세요',
                _ => '손가락 두 마디 깊이까지 말랐을 때 화분 밑으로 흘러나올 만큼. 받침에 고인 물은 버려 주세요',
              },
              '앱은 계절과 놓는 곳에 따라 이 주기를 자동으로 조정해요',
            ],
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 3. 빛
          _Section(
            icon: Icons.wb_sunny_outlined,
            title: '빛',
            lines: [
              switch (s.lightPref) {
                LightPref.low => '빛이 적은 곳에서도 잘 자라요 (반음지)',
                LightPref.med => '밝은 간접광 (커튼 친 창가, 창에서 1m 안쪽)',
                LightPref.high => '햇빛 많이 (남향·동향 창가)',
              },
              switch (s.lightPref) {
                LightPref.low => '직사광선은 잎을 태울 수 있어요',
                LightPref.med => '한여름 직사광선은 피해 주세요',
                LightPref.high => '빛이 부족하면 웃자라고 색이 옅어져요',
              },
            ],
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 4. 온도·습도
          if (s.tempMin != null && s.tempMax != null)
            _Section(
              icon: Icons.thermostat_outlined,
              title: '온도·습도',
              lines: [
                '${s.tempMin}~${s.tempMax}°C',
                s.tempMin! <= 5
                    ? '추위에 강한 편이에요. 실내에서는 찬바람이 직접 닿지 않게만 해 주세요'
                    : '겨울에는 ${s.tempMin}°C 아래로 내려가지 않게 창가에서 떨어뜨려 주세요',
                if (s.category == 'foliage' || s.category == 'other')
                  '건조한 겨울 실내에서는 잎에 분무하거나 가습기를 곁에 두면 좋아요',
              ],
            ),
          if (s.tempMin != null && s.tempMax != null)
            const SizedBox(height: AppSpace.cardGap),

          // 5. 흔한 문제
          if (s.commonIssues.isNotEmpty)
            _Section(
              icon: Icons.error_outline_rounded,
              title: '흔한 문제',
              lines: s.commonIssues,
            ),
          const SizedBox(height: AppSpace.section),
          if (showRegister)
            SafeArea(
              top: false,
              child: AppButton.primary(
                label: '내 식물로 등록',
                onPressed: () => context.push(
                  AppRoutes.addEnv,
                  extra: AddPlantDraft(
                    speciesId: s.id,
                    nicknameHint: s.koNames.first,
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSize.iconSm, color: c.primary),
              const SizedBox(width: AppSpace.sm),
              Text(title, style: AppText.title.copyWith(color: c.textPrimary)),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.xs),
              child: Text(
                l,
                style: AppText.body.copyWith(color: c.textPrimary),
              ),
            ),
        ],
      ),
    );
  }
}
