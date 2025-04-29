import 'package:avo_ai_diet/feature/profile/state/regional_fat_burning_state.dart';
import 'package:avo_ai_diet/product/cache/manager/user_info/user_info_manager.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class RegionalFatBurningCubit extends Cubit<RegionalFatBurningState> {
  RegionalFatBurningCubit(
    this._geminiService,
    this._manager,
  ) : super(RegionalFatBurningState());

  final IGeminiService _geminiService;
  final IUserInfoManager _manager;

  // Tavsiye alma işlemi
  Future<void> getAdvice(List<String> selectedRegions) async {
    if (selectedRegions.isEmpty) return;

    emit(state.copyWith(isLoading: true));

    try {
      // Kullanıcı bilgilerini al
      final userInfo = await _getUserInfo();
      if (userInfo == null) {
        throw Exception('Kullanıcı bilgileri bulunamadı');
      }

      // Yapay zekadan tavsiye al
      final advice = await _geminiService.getRegionalFatBurningAdvice(
        userInfo,
        selectedRegions,
      );

      emit(
        state.copyWith(
          isLoading: false,
          advice: advice,
          adviceReceived: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Tavsiye alınırken bir hata oluştu: $e',
        ),
      );
    }
  }

  Future<UserInfoCacheModel?> _getUserInfo() async {
    try {
      return await _manager.getUserInfo();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Kullanıcı bilgileri alınamadı: $e',
        ),
      );
      return null;
    }
  }

  // Tavsiye sıfırlama
  void resetAdvice() {
    emit(RegionalFatBurningState());
  }
}
