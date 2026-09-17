import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'data/db/app_database.dart';
import 'data/db/database_provider.dart';
import 'data/repositories/settings_repository.dart';
import 'domain/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');

  final db = AppDatabase();
  final settings = await db.getSettings();
  final notifications = NotificationService();
  await notifications.init(
    onForegroundAction: (response) =>
        handleNotificationResponse(response, db: db, service: notifications),
  );

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        onboardingDoneProvider.overrideWith((ref) => settings.onboardingDone),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const PlantApp(),
    ),
  );
}
