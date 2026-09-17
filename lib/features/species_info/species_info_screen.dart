import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/species_l10n.dart';
import '../../core/app_locale.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_card.dart';
import '../../app/widgets/plant_card.dart';
import '../../app/widgets/toxic_badge.dart';
import '../../core/enums.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/species_repository.dart';
import '../add_plant/add_plant_draft.dart';
import '../plant_detail/plant_detail_screen.dart' show temperatureTip;

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
            context.l10n.commonLoadFailed,
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
                context.l10n.infoNotInCatalog,
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
      'succulent' => context.l10n.infoCategorySucculent,
      'herb' => context.l10n.infoCategoryHerb,
      'flower' => context.l10n.infoCategoryFlower,
      'other' => context.l10n.infoCategoryOther,
      _ => context.l10n.infoCategoryFoliage,
    };
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.infoTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          if (s.imageUrl != null) ...[
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: PlantThumb(
                  size: double.infinity,
                  fallbackUrl: s.imageUrl,
                  radius: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.xs),
              child: Text(
                context.l10n.infoPhotoCredit(
                  s.imageAuthor ?? context.l10n.infoUnknownAuthor,
                  s.imageLicense ?? '',
                ),
                style: AppText.label.copyWith(color: c.textTertiary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
          ],
          Text(
            s.displayName(context.l10n),
            style: AppText.headline.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            s.scientificName,
            style: AppText.scientificName.copyWith(color: c.textSecondary),
          ),
          if (s.otherNames(context.l10n).isNotEmpty)
            Text(
              context.l10n.infoOtherNames(
                s.otherNames(context.l10n).join(context.l10n.listSeparator),
              ),
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
          const SizedBox(height: AppSpace.sm),
          Text(
            '$category${s.family == null ? '' : ' · ${s.family}'}',
            style: AppText.caption.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: AppSpace.section),

          // 1. 위험한 식물만 최상단 경고
          if (s.toxicSevere) ...[
            AppCard(
              child: ToxicBadge(
                toxicPet: s.toxicPet,
                childLevel: s.toxicChildLevel,
                note: s.toxicityNoteFor(context.l10n),
              ),
            ),
            const SizedBox(height: AppSpace.cardGap),
          ],

          // 2. 물
          _Section(
            icon: Icons.water_drop_outlined,
            title: context.l10n.infoWater,
            lines: [
              context.l10n.infoWaterBase(s.baseWaterDays),
              switch (s.category) {
                'succulent' => context.l10n.infoWaterSucculent,
                'herb' => context.l10n.infoWaterHerb,
                'flower' => context.l10n.infoWaterFlower,
                _ => context.l10n.infoWaterFoliage,
              },
              context.l10n.infoWaterAuto,
            ],
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 3. 빛
          _Section(
            icon: Icons.wb_sunny_outlined,
            title: context.l10n.infoLight,
            lines: [
              switch (s.lightPref) {
                LightPref.low => context.l10n.infoLightLow,
                LightPref.med => context.l10n.infoLightMed,
                LightPref.high => context.l10n.infoLightHigh,
              },
              switch (s.lightPref) {
                LightPref.low => context.l10n.infoLightLowNote,
                LightPref.med => context.l10n.infoLightMedNote,
                LightPref.high => context.l10n.infoLightHighNote,
              },
            ],
          ),
          const SizedBox(height: AppSpace.cardGap),

          // 4. 온도·습도
          if (s.tempMin != null && s.tempMax != null)
            _Section(
              icon: Icons.thermostat_outlined,
              title: context.l10n.infoTempHumidity,
              lines: [
                temperatureTip(s, context.l10n),
                if (s.category == 'foliage' || s.category == 'other')
                  context.l10n.infoHumidityTip,
              ],
            ),
          if (s.tempMin != null && s.tempMax != null)
            const SizedBox(height: AppSpace.cardGap),

          // 5. 흔한 문제
          if (s.commonIssuesFor(context.l10n).isNotEmpty)
            _Section(
              icon: Icons.error_outline_rounded,
              title: context.l10n.infoCommonIssues,
              lines: s.commonIssuesFor(context.l10n),
            ),
          // 가벼운 자극: 경고 대신 참고 한 줄
          if (!s.toxicSevere &&
              (s.toxicPet || s.toxicChildLevel != ChildToxicity.none))
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.md),
              child: Text(
                context.l10n.toxicMildNote,
                style: AppText.caption.copyWith(color: c.textTertiary),
              ),
            ),
          const SizedBox(height: AppSpace.section),
          if (showRegister)
            SafeArea(
              top: false,
              child: AppButton.primary(
                label: context.l10n.infoAddToMine,
                onPressed: () => context.push(
                  AppRoutes.addEnv,
                  extra: AddPlantDraft(
                    speciesId: s.id,
                    nicknameHint: s.displayName(context.l10n),
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
