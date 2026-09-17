import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/app_locale.dart';
import 'package:plant_app/domain/watering_rules.dart';

void main() {
  group('언어 결정', () {
    test('한국어만 ko, 나머지는 영어', () {
      expect(resolveAppLocale(const Locale('ko', 'KR')), const Locale('ko'));
      expect(resolveAppLocale(const Locale('en', 'US')), const Locale('en'));
      expect(resolveAppLocale(const Locale('ja', 'JP')), const Locale('en'));
      expect(resolveAppLocale(null), const Locale('en'));
    });
  });

  group('온도 단위', () {
    test('미국은 °F, 한국·영국은 °C', () {
      expect(formatTemperature(10, country: 'US'), '50°F');
      expect(formatTemperature(24, country: 'us'), '75°F');
      expect(formatTemperature(10, country: 'KR'), '10°C');
      expect(formatTemperature(10, country: 'GB'), '10°C');
    });
  });

  group('남반구 계절', () {
    test('남반구 나라 판별', () {
      expect(isSouthernHemisphere('AU'), isTrue);
      expect(isSouthernHemisphere('nz'), isTrue);
      expect(isSouthernHemisphere('KR'), isFalse);
      expect(isSouthernHemisphere(null), isFalse);
    });

    test('남반구는 6개월 밀린 달로 계절을 계산', () {
      expect(hemisphereMonth(1, southern: false), 1);
      expect(hemisphereMonth(1, southern: true), 7); // 호주 1월 = 한여름
      expect(hemisphereMonth(7, southern: true), 1); // 호주 7월 = 한겨울
      expect(hemisphereMonth(12, southern: true), 6);
      for (var m = 1; m <= 12; m++) {
        final s = hemisphereMonth(m, southern: true);
        expect(s, inInclusiveRange(1, 12));
      }
    });
  });

  group('번역 파일', () {
    Map<String, dynamic> load(String name) =>
        jsonDecode(File('lib/l10n/$name').readAsStringSync())
            as Map<String, dynamic>;

    test('영어·한국어 키가 빠짐없이 같다', () {
      final en = load('app_en.arb').keys.where((k) => !k.startsWith('@'));
      final ko = load('app_ko.arb').keys.where((k) => !k.startsWith('@'));
      expect(en.toSet().difference(ko.toSet()), isEmpty);
      expect(ko.toSet().difference(en.toSet()), isEmpty);
    });

    test('빈 번역이 없다', () {
      for (final f in ['app_en.arb', 'app_ko.arb']) {
        load(f).forEach((k, v) {
          if (!k.startsWith('@')) {
            expect((v as String).trim(), isNotEmpty, reason: '$f:$k');
          }
        });
      }
    });

    test('영어 번역에 한글이 섞이지 않았다', () {
      final hangul = RegExp(r'[가-힣]');
      load('app_en.arb').forEach((k, v) {
        if (!k.startsWith('@') && v is String) {
          expect(hangul.hasMatch(v), isFalse, reason: k);
        }
      });
    });
  });
}
