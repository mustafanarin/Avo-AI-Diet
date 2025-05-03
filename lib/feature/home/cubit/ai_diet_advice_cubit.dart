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
      emit(state.copyWith(response: response, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Maalesef diyetinizi yüklerken bir sorun oluştu, profil sayfasından tekrar diyet oluşturunuz.',
          isLoading: false,
        ),
      );
    }
  }

  void refreshDietPlan() => _loadDietPlan();
}
