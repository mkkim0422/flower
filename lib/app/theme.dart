// 디자인 토큰 단일 소스. 원본: docs/DESIGN.md
// 화면 코드에서 HEX·px 직접 입력 금지. 반드시 이 파일의 상수를 사용한다.
import 'package:flutter/material.dart';

/// 컬러 토큰 (DESIGN.md 1장). ThemeExtension으로 등록되어
/// `context.colors` 로 라이트/다크 자동 분기된 값을 가져온다.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.statusNeedCheck,
    required this.statusOk,
    required this.statusUnknown,
    required this.warning,
    required this.error,
    required this.accentSoft,
  });

  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color statusNeedCheck;
  final Color statusOk;
  final Color statusUnknown;
  final Color warning;
  final Color error;

  /// 장식용 연한 채우기 (배너·토글 배경·안 선택된 칩·아이콘 배경).
  /// 선택·행동 상태는 primaryContainer(연초록)를 쓴다.
  final Color accentSoft;

  // 라이트 팔레트: 화이트 (2026-09-17 사용자 확정, Modern Cozy 베이지 대체)
  // 흰 배경·흰 카드+테두리, 초록은 행동·선택에만, 장식은 중립 회색(accentSoft).
  static const light = AppColors(
    primary: Color(0xFF2C5E43),
    primaryContainer: Color(0xFFE6F0EA),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF3F4F1),
    outline: Color(0xFFE6E8E3),
    textPrimary: Color(0xFF1B1F1D),
    textSecondary: Color(0xFF5C635F),
    textTertiary: Color(0xFF9AA19C),
    statusNeedCheck: Color(0xFFE05A4E),
    statusOk: Color(0xFF2C5E43),
    statusUnknown: Color(0xFFB5BBB7),
    warning: Color(0xFFD9912B),
    error: Color(0xFFC63C30),
    accentSoft: Color(0xFFF1F2EF),
  );

  static const dark = AppColors(
    primary: Color(0xFF6DBE97),
    primaryContainer: Color(0xFF1F3B2F),
    onPrimary: Color(0xFF0E1A14),
    background: Color(0xFF121614),
    surface: Color(0xFF1B211D),
    surfaceVariant: Color(0xFF242B27),
    outline: Color(0xFF2F3733),
    textPrimary: Color(0xFFECEFEC),
    textSecondary: Color(0xFFA9B0AB),
    textTertiary: Color(0xFF6E7571),
    statusNeedCheck: Color(0xFFF07A6E),
    statusOk: Color(0xFF6DBE97),
    statusUnknown: Color(0xFF5B625E),
    warning: Color(0xFFE8A64A),
    error: Color(0xFFE0665A),
    accentSoft: Color(0xFF242B27),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? statusNeedCheck,
    Color? statusOk,
    Color? statusUnknown,
    Color? warning,
    Color? error,
    Color? accentSoft,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      statusNeedCheck: statusNeedCheck ?? this.statusNeedCheck,
      statusOk: statusOk ?? this.statusOk,
      statusUnknown: statusUnknown ?? this.statusUnknown,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      accentSoft: accentSoft ?? this.accentSoft,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: l(primary, other.primary),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      onPrimary: l(onPrimary, other.onPrimary),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceVariant: l(surfaceVariant, other.surfaceVariant),
      outline: l(outline, other.outline),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      statusNeedCheck: l(statusNeedCheck, other.statusNeedCheck),
      statusOk: l(statusOk, other.statusOk),
      statusUnknown: l(statusUnknown, other.statusUnknown),
      warning: l(warning, other.warning),
      error: l(error, other.error),
      accentSoft: l(accentSoft, other.accentSoft),
    );
  }
}

/// 타이포그래피 토큰 (DESIGN.md 2장). 색은 포함하지 않는다(화면에서 `context.colors`로 지정).
class AppText {
  AppText._();

  static const fontFamily = 'Pretendard';

  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
  );
  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );
  static const bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w500,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );
  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
  );

  /// 학명: caption + 이탤릭 (색은 textSecondary를 화면에서 지정)
  static const scientificName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  /// 숫자(D-day, 확률 %)용: tabular figures
  static const tabularFeatures = [FontFeature.tabularFigures()];
}

/// 간격 토큰 (DESIGN.md 3장). 4pt 그리드: 4·8·12·16·24·32만 사용.
class AppSpace {
  AppSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// 화면 좌우 여백
  static const double screenH = 20;

  /// 섹션 간 간격
  static const double section = 24;

  /// 카드 내부 패딩
  static const double cardPadding = 16;

  /// 카드 간 간격
  static const double cardGap = 12;

  /// 터치 영역 최소
  static const double minTouch = 44;
}

/// 모서리 토큰 (DESIGN.md 3장)
class AppRadius {
  AppRadius._();

  static const double card = 16;
  static const double button = 12;
  static const double input = 12;
  static const double chip = 999;
  static const double thumbnail = 12;
  static const double avatar = 999;
  static const double bottomSheet = 24;
}

/// 컴포넌트 치수 (DESIGN.md 3·4장)
class AppSize {
  AppSize._();

  static const double buttonHeight = 52;
  static const double textButtonHeight = 44;
  static const double inputHeight = 52;
  static const double chipHeight = 28;
  static const double tabBarHeight = 64;
  static const double cameraButton = 56;
  static const double cameraButtonOverlap = 12;
  static const double plantCardHeight = 88;
  static const double plantThumb = 56;
  static const double todayThumb = 40;
  static const double candidateThumb = 64;
  static const double statusDot = 8;
  static const double checkbox = 24;
  static const double emptyIllustration = 120;
  static const double icon = 24;
  static const double tabIcon = 26;
  static const double dragHandleWidth = 36;
  static const double dragHandleHeight = 4;
  static const double inputFocusBorder = 1.5;

  /// 보조 아이콘 크기
  static const double iconSm = 20;
  static const double iconXs = 18;
  static const double iconXxs = 16;

  /// 선택 표시 테두리
  static const double borderThin = 1.5;

  /// 온보딩 페이지 점
  static const double pageDot = 8;
  static const double pageDotActive = 20;

  /// PLT-02 슬라이더 최대 일수·값 표시 폭
  static const int sliderMaxDays = 90;
  static const double sliderValueWidth = 56;

  /// PLT-01 관리 일정 라벨 폭
  static const double scheduleLabelWidth = 48;

  /// 홈 다중 선택 하단 바 높이
  static const double stickyBar = 80;

  /// 세그먼트 토글 내부 패딩
  static const double segmentPadding = 2;
}

/// 그림자 (DESIGN.md 3장). 카드는 그림자 없음. 중앙 카메라 버튼만 y2 blur8 alpha12%.
class AppShadow {
  AppShadow._();

  static const List<BoxShadow> cameraButton = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 2), blurRadius: 8),
  ];
}

/// 모션 (DESIGN.md 6장)
class AppMotion {
  AppMotion._();

  static const bottomSheet = Duration(milliseconds: 250);
  static const bottomSheetCurve = Curves.easeOutCubic;
  static const check = Duration(milliseconds: 150);
  static const double checkScale = 1.15;
}

/// `Theme.of(context)` 확장: `context.colors`
extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// DESIGN.md 토큰 → Flutter ThemeData 매핑
ThemeData buildAppTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.onPrimary,
    primaryContainer: c.primaryContainer,
    onPrimaryContainer: c.primary,
    secondary: c.primary,
    onSecondary: c.onPrimary,
    error: c.error,
    onError: c.onPrimary,
    surface: c.surface,
    onSurface: c.textPrimary,
    surfaceContainerHighest: c.surfaceVariant,
    onSurfaceVariant: c.textSecondary,
    outline: c.outline,
    outlineVariant: c.outline,
  );

  final textTheme = TextTheme(
    headlineSmall: AppText.headline.copyWith(color: c.textPrimary),
    titleMedium: AppText.title.copyWith(color: c.textPrimary),
    bodyLarge: AppText.body.copyWith(color: c.textPrimary),
    bodyMedium: AppText.body.copyWith(color: c.textPrimary),
    bodySmall: AppText.caption.copyWith(color: c.textSecondary),
    labelLarge: AppText.bodyStrong.copyWith(color: c.textPrimary),
    labelMedium: AppText.label.copyWith(color: c.textSecondary),
    labelSmall: AppText.label.copyWith(color: c.textTertiary),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: c.background,
    fontFamily: AppText.fontFamily,
    textTheme: textTheme,
    extensions: [c],
    splashFactory: NoSplash.splashFactory, // 장식 애니메이션 없음 (DESIGN 6장)
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.headline.copyWith(color: c.textPrimary),
      iconTheme: IconThemeData(color: c.textPrimary, size: AppSize.icon),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: c.outline),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.outline, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: c.textPrimary, size: AppSize.icon),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.lg,
      ),
      hintStyle: AppText.body.copyWith(color: c.textTertiary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(
          color: c.primary,
          width: AppSize.inputFocusBorder,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleSize: const Size(
        AppSize.dragHandleWidth,
        AppSize.dragHandleHeight,
      ),
      dragHandleColor: c.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.bottomSheet),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        minimumSize: const Size.fromHeight(AppSize.buttonHeight),
        textStyle: AppText.bodyStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primary,
        minimumSize: const Size(AppSpace.minTouch, AppSize.textButtonHeight),
        textStyle: AppText.bodyStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.primaryContainer,
      selectedColor: c.primary,
      labelStyle: AppText.label.copyWith(color: c.primary),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
      shape: const StadiumBorder(),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
