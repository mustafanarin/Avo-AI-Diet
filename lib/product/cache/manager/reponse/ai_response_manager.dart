import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IAiResponseManager {
  Future<void> saveDietPlan(AiResponse response);
  Future<AiResponse?> getDietPlan();
}

class AiResponseManager implements IAiResponseManager {
  static const String _boxName = 'diet_plan';
  static const String _responseKey = 'response';

  LazyBox<AiResponse>? _box;

  Future<LazyBox<AiResponse>> _getBox() async {
    _box ??= await Hive.openLazyBox<AiResponse>(_boxName);
    return _box!;
  }

  @override
  Future<void> saveDietPlan(AiResponse response) async {
    final box = await _getBox();
    await box.put(_responseKey, response);
  }

  @override
  Future<AiResponse?> getDietPlan() async {
    final box = await _getBox();
    final response = await box.get(
      _responseKey,
      defaultValue: AiResponse(
        dietPlan: 'Sanırım bir hata oluştu, profil sayfasından tekrar deneyiniz.',
        formattedDayMonthYear: '-',
      ),
    );
    return response;
  }
}