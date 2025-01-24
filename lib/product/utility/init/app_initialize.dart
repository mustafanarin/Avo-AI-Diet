import 'package:avo_ai_diet/product/model/ai_response.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

final class AppInitialize {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();

    await Hive.initFlutter();
    Hive.registerAdapter(AiResponseAdapter());

    await setupServiceLocator();
  }
}
