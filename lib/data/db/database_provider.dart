import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// 앱 전역 DB 인스턴스. 테스트에서는 `overrideWithValue`로 인메모리 DB 주입.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
