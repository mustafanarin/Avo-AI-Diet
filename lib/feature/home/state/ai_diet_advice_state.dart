import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';

final class AiDietAdviceState {
  AiDietAdviceState({this.response, this.isLoading = false, this.error});

  final AiResponse? response;
  final bool isLoading;
  final String? error;

  AiDietAdviceState copyWith({
    AiResponse? response,
    bool? isLoading,
    String? error,
  }) {
    return AiDietAdviceState(
      response: response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
