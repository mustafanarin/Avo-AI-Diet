import 'package:avo_ai_diet/firebase_options.dart';
import 'package:avo_ai_diet/product/cache/model/daily_calorie/daily_calorie_model.dart';
import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/product/cache/model/water_reminder/water_reminder_model.dart';
import 'package:avo_ai_diet/product/routes/app_router.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:avo_ai_diet/services/notification_service.dart';
// AppRouter import'unu buraya ekleyin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

final class AppInitialize {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Hive.initFlutter();
    Hive
      ..registerAdapter(AiResponseAdapter())
      ..registerAdapter(NameAndCalModelAdapter())
      ..registerAdapter(FavoriteMessageModelAdapter())
      ..registerAdapter(DailyCalorieModelAdapter())
      ..registerAdapter(UserInfoCacheModelAdapter())
      ..registerAdapter(WaterReminderModelAdapter());

    await initializeDateFormatting('tr_TR');

    await setupServiceLocator();

    await AppRouter.setInitialLocation();

    final notificationService = getIt<INotificationService>();
    await notificationService.init();
  }
}
