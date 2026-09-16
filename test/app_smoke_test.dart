import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plant_app/app/app.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/db/database_provider.dart';
import 'package:plant_app/features/my/my_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ko_KR');
  });

  testWidgets('3탭 스캐폴드가 뜨고 탭 전환이 된다', (tester) async {
    // Drift는 실제 비동기 I/O·타이머를 쓰므로 fakeAsync 대신 runAsync로 실행한다.
    await tester.runAsync(() async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const PlantApp(),
        ),
      );
      await tester.pumpAndSettle();

      // HOME-01 기본 진입 + 빈 상태
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

      // 홈으로 복귀
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.text('오늘'), findsOneWidget);

      // 스트림 구독 해제 후 DB 종료
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await db.close();
    });
  }, timeout: const Timeout(Duration(seconds: 60)));
}
