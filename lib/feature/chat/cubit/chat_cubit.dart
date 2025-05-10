import 'dart:developer';

import 'package:avo_ai_diet/feature/chat/state/chat_state.dart';
import 'package:avo_ai_diet/product/cache/manager/user_info/user_info_manager.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._service, this._manager) : super(const ChatState()) {
    _initializeUserInfo();
  }

  final IGeminiService _service;
  final IUserInfoManager _manager;
  UserInfoCacheModel? _cachedUserInfo;

  final List<Map<String, String>> _recentConversation = [];
  final int _maxConversationPairs = 3;

  Future<void> _initializeUserInfo() async {
    try {
      _cachedUserInfo = await _manager.getUserInfo();
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Kullanıcı bilgileri alınamadı: $e',
        ),
      );
    }
  }

  // To add a starting message
  void initialize(String welcomeMessage) {
    if (_recentConversation.isEmpty) {
      _recentConversation.add({
        'role': 'Avo',
        'message': welcomeMessage,
      });
    }
  }

  Future<void> chatWithAi(String userMessage) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Add user message to history
      _recentConversation.add({
        'role': 'Kullanıcı',
        'message': userMessage,
      });

      // Create limited history
      final limitedHistory = _buildLimitedConversationHistory();
      log('Sending limited history: $limitedHistory');

      // Load user information if it is not loaded before
      if (_cachedUserInfo == null) {
        _cachedUserInfo = await _manager.getUserInfo();
        if (_cachedUserInfo == null) {
          throw Exception('Kullanıcı bilgileri bulunamadı');
        }
      }

      final response = await _service.aiChat(
        userMessage,
        limitedHistory,
        _cachedUserInfo!,
      );

      // Add AI response to history
      _recentConversation.add({
        'role': 'Avo',
        'message': response,
      });

      // Limit history
      _limitConversationHistory();

      emit(state.copyWith(isLoading: false, response: response));
    } on Exception catch (e) {
      final errorMessage = 'Avo ile konuşurken bir sorun oluştu: $e';
      log(errorMessage);
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }

  // Creates limited conversation history
  String _buildLimitedConversationHistory() {
    var history = '';
    for (final message in _recentConversation) {
      history += '\n${message['role']}: ${message['message']}';
    }
    return history;
  }

  // Limits past messages
  void _limitConversationHistory() {
    while (_recentConversation.length > _maxConversationPairs * 2) {
      // delete old user and AI message pair
      _recentConversation.removeRange(0, 2);
    }
  }
}
