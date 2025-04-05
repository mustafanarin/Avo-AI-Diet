import 'package:avo_ai_diet/feature/profile/state/name_edit_state.dart';
import 'package:avo_ai_diet/product/cache/manager/name_and_cal/name_and_cal_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class NameEditCubit extends Cubit<NameEditState> {
  NameEditCubit(this._manager) : super(NameEditState());

  final INameAndCalManager _manager;

  Future<void> updateName(String name) async {
    emit(state.copyWith(isLoading: true));
    try {
      final currentData = await _manager.getNameCalori();
      if (currentData != null) {
        final updateModel = currentData.copyWith(userName: name);
        await _manager.saveNameCalori(updateModel);
        emit(state.copyWith(name: name, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: 'İsim güncellerken bir sorun oluştu, lütfen tekrar deneyin!'));
    }
  }
}
