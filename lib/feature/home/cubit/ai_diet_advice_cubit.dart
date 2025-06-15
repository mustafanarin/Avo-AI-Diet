import 'package:avo_ai_diet/feature/home/state/ai_diet_advice_state.dart';
import 'package:avo_ai_diet/product/cache/manager/reponse/ai_response_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class AiDietAdviceCubit extends Cubit<AiDietAdviceState> {
  AiDietAdviceCubit(this._manager) : super(AiDietAdviceState()) {
    _loadDietPlan();
  }

  final IAiResponseManager _manager;

  Future<void> _loadDietPlan() async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _manager.getDietPlan();

      if (response == null) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Diyet planı yüklenirken bir hata oluştu. Lütfen profil sayfasından yeni bir plan oluşturun.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          response: response,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Diyet planı yüklenirken bir hata oluştu. Lütfen profil sayfasından yeni bir plan oluşturun.',
        ),
      );
    }
  }

  Future<void> refreshDietPlan() async {
    await _loadDietPlan();
  }
}
