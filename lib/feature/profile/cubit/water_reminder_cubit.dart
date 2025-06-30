import 'package:avo_ai_diet/feature/profile/state/water_reminder_state.dart';
import 'package:avo_ai_diet/product/cache/manager/water_reminder/water_reminder_manager.dart';
import 'package:avo_ai_diet/services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class WaterReminderCubit extends Cubit<WaterReminderState> {
  WaterReminderCubit(this._notificationService, this._reminderManager) : super(WaterReminderState()) {
    _loadSettings();
  }

  final INotificationService _notificationService;
  final IWaterReminderManager _reminderManager;

  Future<void> _loadSettings() async {
    final isEnabled = await _reminderManager.getWaterReminderState();
    emit(state.copyWith(isEnabled: isEnabled));
  }

  Future<void> toggleWaterReminder(bool isEnabled) async {
    emit(state.copyWith(isEnabled: isEnabled));
    await _reminderManager.saveWaterReminderState(isEnabled);

    if (isEnabled) {
      await _notificationService.scheduleWaterReminder();
    } else {
      await _notificationService.cancelWaterReminder();
    }
  }

  Future<void> showPreviewNotification() async {
    await _notificationService.showPreviewNotification();
  }
}