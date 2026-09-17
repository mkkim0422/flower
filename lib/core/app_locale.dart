// 글로벌 대응 공통: 언어 결정, 온도 단위, 반구(계절)
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// 지원 언어로 맞춤: 한국어면 ko, 그 외 전부 en
Locale resolveAppLocale(Locale? device) =>
    device?.languageCode == 'ko' ? const Locale('ko') : const Locale('en');

/// BuildContext 가 없는 곳(알림·백그라운드)에서 쓰는 기기 언어 문구
AppLocalizations deviceL10n() => lookupAppLocalizations(
  resolveAppLocale(PlatformDispatcher.instance.locale),
);

bool isKorean(AppLocalizations l) => l.localeName.startsWith('ko');

/// 기기 지역 코드 (예: KR, US, AU). 없으면 null
String? deviceCountry() => PlatformDispatcher.instance.locale.countryCode;

/// 화씨를 쓰는 나라
const _fahrenheitCountries = {
  'US',
  'LR',
  'MM',
  'BS',
  'BZ',
  'KY',
  'PW',
  'FM',
  'MH',
};

bool usesFahrenheit(String? country) =>
    country != null && _fahrenheitCountries.contains(country.toUpperCase());

/// 인구 대부분이 남반구에 사는 나라 (계절이 반대)
const _southernCountries = {
  'AU',
  'NZ',
  'ZA',
  'AR',
  'CL',
  'UY',
  'PY',
  'BO',
  'BR',
  'PE',
  'NA',
  'BW',
  'ZW',
  'ZM',
  'MZ',
  'MG',
  'LS',
  'SZ',
  'MW',
  'AO',
  'FJ',
  'NC',
  'MU',
  'RE',
};

bool isSouthernHemisphere(String? country) =>
    country != null && _southernCountries.contains(country.toUpperCase());

/// 온도 표시: 기기 지역이 화씨 국가면 °F
String formatTemperature(int celsius, {String? country}) {
  if (usesFahrenheit(country ?? deviceCountry())) {
    return '${(celsius * 9 / 5 + 32).round()}°F';
  }
  return '$celsius°C';
}
