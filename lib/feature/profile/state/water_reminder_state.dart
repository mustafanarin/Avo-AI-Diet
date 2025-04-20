final class WaterReminderState {
  WaterReminderState({this.isEnabled = false});

  final bool isEnabled;

  WaterReminderState copyWith({
    bool? isEnabled,
  }) {
    return WaterReminderState(
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
