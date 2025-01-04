import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:avo_ai_diet/services/secure_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt
    ..registerLazySingleton<SecureStorageService>(SecureStorageService.new)
    ..registerLazySingleton(() => GeminiService(getIt<SecureStorageService>()));
}
