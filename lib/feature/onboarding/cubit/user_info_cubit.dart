import 'dart:developer';

import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_state.dart';
import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit(this._service) : super(UserInfoState());

  final GeminiService _service;

  Future<void> submitUserInfo(UserInfoModel userInfo) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _service.getUserDiet(userInfo);
      log(response);

      emit(state.copyWith(isLoading: false, response: response));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
