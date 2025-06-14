import 'dart:developer';

import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/feature/onboarding/state/user_info_state.dart';
import 'package:avo_ai_diet/product/cache/manager/reponse/ai_response_manager.dart';
import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
final class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit(this._service, this._manager) : super(UserInfoState());

  final IGeminiService _service;
  final IAiResponseManager _manager;

  // Simple process control
  bool _isProcessing = false;

  Future<void> submitUserInfo(UserInfoModel userInfo) async {
    if (_isProcessing) return;

    try { 
      _isProcessing = true;
      emit(state.copyWith(isLoading: true));

      final response = await _service.getUserDiet(userInfo);
      log(response);

      await _manager.saveDietPlan(
        AiResponse(
          dietPlan: response,
          formattedDayMonthYear: DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now()),
        ),
      );

      emit(state.copyWith(response: response, isLoading: false));
    } on GeminiException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.'));
    } finally {
      _isProcessing = false;
    }
  }
}
