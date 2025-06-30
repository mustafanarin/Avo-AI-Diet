enum _DurationValues {
  smallMilliseconds(200),
  mediumMilliseconds(600),
  transitionMilliseconds(1200),
  xLargeMilliseconds(1500),
  one(1),
  thirty(30),
  sixty(60);

  const _DurationValues(this.value);
  final int value;
}

final class AppDurations extends Duration {
  AppDurations.oneSeconds() : super(seconds: _DurationValues.one.value);

  AppDurations.smallMilliseconds()
      : super(
          milliseconds: _DurationValues.smallMilliseconds.value,
        );

  AppDurations.transitionMilliseconds()
      : super(
          milliseconds: _DurationValues.transitionMilliseconds.value,
        );

  AppDurations.mediumMilliseconds() : super(milliseconds: _DurationValues.mediumMilliseconds.value);

  AppDurations.xLargeMilliseconds() : super(milliseconds: _DurationValues.xLargeMilliseconds.value);

  // GeminiService duration values
  AppDurations.requestTimeout() : super(seconds: _DurationValues.thirty.value);

  AppDurations.fetchTimeout() : super(seconds: _DurationValues.sixty.value);

  AppDurations.minimumFetchInterval() : super(hours: _DurationValues.one.value);
}
