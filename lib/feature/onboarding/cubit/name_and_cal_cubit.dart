import 'package:avo_ai_diet/feature/onboarding/state/name_and_cal_state.dart';
import 'package:avo_ai_diet/product/cache/manager/name_and_cal/name_and_cal_manager.dart';
import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class NameAndCalCubit extends Cubit<NameAndCalState> {
  NameAndCalCubit(this._manager) : super(NameAndCalState()) {
    _loadInitialData();
  }
  final INameAndCalManager _manager;

  Future<void> _loadInitialData() async {
    final cachedData = await _manager.getNameCalori();
    if (cachedData != null) {
      emit(NameAndCalState(name: cachedData.userName, targetCal: cachedData.targetCal));
    }
  }

  Future<void> submitNameAndCal(NameAndCalModel model) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _manager.saveNameCalori(model);
      emit(
        state.copyWith(
          isLoading: false,
          name: model.userName,
          targetCal: model.targetCal,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Bilgiler kaydedilirken bir hata oluştu: $e',
        ),
      );
    }
  }

  Future<void> refreshData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final nameCalData = await _manager.getNameCalori();
      if (nameCalData != null) {
        emit(
          state.copyWith(
            name: nameCalData.userName,
            targetCal: nameCalData.targetCal,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Veriler yüklenirken bir sorun oluştu',
          isLoading: false,
        ),
      );
    }
  }
}
