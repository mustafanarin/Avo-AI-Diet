import 'package:avo_ai_diet/product/cache/model/daily_calorie/daily_calorie_model.dart';
import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

final class AppInitialize {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();

    await Hive.initFlutter();
    Hive
      ..registerAdapter(AiResponseAdapter())
      ..registerAdapter(NameAndCalModelAdapter())
      ..registerAdapter(FavoriteMessageModelAdapter())
      ..registerAdapter(DailyCalorieModelAdapter());
    await initializeDateFormatting('tr_TR');

    await setupServiceLocator();
  }
}
