import 'dart:developer';

import 'package:avo_ai_diet/feature/chat/state/chat_state.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._service) : super(ChatState());

  final GeminiService _service;

  Future<void> chatWithAi(String text, String conversationHistory) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _service.aiChat(text,conversationHistory);
      log(response);
      emit(state.copyWith(isLoading: false, response: response));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false));
      throw Exception('Avo ile konuşşurken bir sorun oluştu: $e');
    }
  }
}
