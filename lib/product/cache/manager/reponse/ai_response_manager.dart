import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IAiResponseManager {
  Future<void> saveDietPlan(AiResponse response);
  Future<AiResponse?> getDietPlan();
}


@singleton
class AiResponseManager implements IAiResponseManager {
  LazyBox<AiResponse>? _box;

  Future<LazyBox<AiResponse>> _getBox() async {
    _box ??= await Hive.openLazyBox<AiResponse>('diet_plan');
    return _box!;
  }

  @override
  Future<void> saveDietPlan(AiResponse response) async {
    final box = await _getBox();
    await box.put('response', response);
  }

  @override
  Future<AiResponse?> getDietPlan() async {
    final box = await _getBox();
    final response = await box.get(
      'response',
      defaultValue: AiResponse(
        dietPlan: 'Sanırım bir hata oluştu...',
        formattedDayMonthYear: '-',
      ),
    );
    return response;
  }
}
