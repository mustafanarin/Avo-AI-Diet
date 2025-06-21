import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IRateLimitService {
  Future<bool> canMakeRequest({required int dailyLimit});
  Future<void> incrementRequestCount();
  Future<void> checkAndIncrementRequestLimit({required int dailyLimit});
}

@singleton
class RateLimitService implements IRateLimitService {
  // Format: "user_requests_YYYY-MM-DD"
  static const String _requestCountPrefix = 'user_requests_';

  @override
  Future<bool> canMakeRequest({required int dailyLimit}) async {
    try {
      // Format: YYYY-MM-DD
      final today = _getTodayString();

      final currentCount = await _getCurrentRequestCount(today);

      return currentCount < dailyLimit;
    } catch (e) {
      print('Rate limit check error: $e');
      return true;
    }
  }

  @override
  Future<void> incrementRequestCount() async {
    try {
      final today = _getTodayString();
      final userKey = '$_requestCountPrefix$today';
      final prefs = await SharedPreferences.getInstance();

      final currentCount = prefs.getInt(userKey) ?? 0;

      // Increase the number of requests by 1 and save
      await prefs.setInt(userKey, currentCount + 1);
    } catch (e) {
      print('Request count increment error: $e');
    }
  }

  @override
  Future<void> checkAndIncrementRequestLimit({required int dailyLimit}) async {
    // can user request AI
    final canMakeRequest = await this.canMakeRequest(dailyLimit: dailyLimit);

    if (!canMakeRequest) {
      throw GeminiException(
        message: '🎯 Günlük ücretsiz AI sorgu limitiniz ($dailyLimit) doldu.\n Yarın tekrar deneyiniz.',
      );
    }

    // Increase the number of requests if the limit is not exceeded
    await incrementRequestCount();
  }

  String _getTodayString() {
    // split('T')[0] = "2025-06-21"
    return DateTime.now().toIso8601String().split('T')[0];
  }

  Future<int> _getCurrentRequestCount(String today) async {
    final userKey = '$_requestCountPrefix$today';

    final prefs = await SharedPreferences.getInstance();

    final count = prefs.getInt(userKey) ?? 0;

    return count;
  }
}
