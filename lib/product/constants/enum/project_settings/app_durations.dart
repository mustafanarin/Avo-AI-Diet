enum _DurationValues {
  smallMilliseconds(200),
  one(1);

  const _DurationValues(this.value);

  final int value;
}

final class AppDurations extends Duration {
  AppDurations. oneSeconds() : super(seconds: _DurationValues.one.value);
  AppDurations.smallMilliseconds() : super(
    milliseconds: _DurationValues.smallMilliseconds.value,);
  
}
