import 'dart:developer';

import 'package:avo_ai_diet/feature/chat/state/chat_state.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._service) : super(const ChatState());

  final GeminiService _service;

  Future<void> chatWithAi(String text, String conversationHistory) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _service.aiChat(text, conversationHistory);
      log(response);
      emit(state.copyWith(isLoading: false, response: response));
    } on Exception catch (e) {
      final errorMessage = 'There was a problem talking to Avo: $e';
      log(errorMessage);
      emit(state.copyWith(isLoading: false));
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }
}
