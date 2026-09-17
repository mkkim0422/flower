import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plant_app/app/app.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/db/database_provider.dart';
import 'package:plant_app/data/repositories/settings_repository.dart';
import 'package:plant_app/data/seed/species_seed.dart';
import 'package:plant_app/features/add_plant/add_method_screen.dart';
import 'package:plant_app/features/my/my_screen.dart';
import 'package:plant_app/features/onboarding/onboarding_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ko_KR');
  });

  Widget app(AppDatabase db, {bool onboardingDone = true}) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      onboardingDoneProvider.overrideWith((ref) => onboardingDone),
      // 테스트에서는 에셋 로드 대신 빈 시드
      speciesSeedProvider.overrideWith((ref) async => 0),
    ],
    child: const PlantApp(),
  );

  testWidgets('온보딩 미완료면 ONB-01 로 리다이렉트', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ko', 'KR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.runAsync(() async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(app(db, onboardingDone: false));
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('내 식물, 잘 자라게'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await db.close();
    });
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('3탭 스캐폴드가 뜨고 탭 전환·식물 추가 진입이 된다', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ko', 'KR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.runAsync(() async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(app(db));
      await tester.pumpAndSettle();

      // HOME-01 빈 상태
      expect(find.text('오늘'), findsOneWidget);
      expect(find.text('첫 식물을 등록해 보세요'), findsOneWidget);

      // 카메라 탭
      await tester.tap(find.byIcon(Icons.photo_camera_rounded));
      await tester.pumpAndSettle();
      expect(find.text('잎 전체가 나오게 찍어 주세요'), findsOneWidget);

      // MY 탭
      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(MyScreen), findsOneWidget);

      // 홈 → 식물 추가 (ADD-01)
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('식물 추가'));
      await tester.pumpAndSettle();
      expect(find.byType(AddMethodScreen), findsOneWidget);
      expect(find.text('이름으로 검색'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await db.close();
    });
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('영어 기기에서는 영어로 보인다', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.runAsync(() async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(app(db));
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Add your first plant'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await db.close();
    });
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('지원하지 않는 언어(일본어)는 영어로 보인다', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja', 'JP')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.runAsync(() async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(app(db));
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await db.close();
    });
  }, timeout: const Timeout(Duration(seconds: 60)));
}
