class RegionalFatBurningState {
  RegionalFatBurningState({
    this.isLoading = false,
    this.advice = '',
    this.error = '',
    this.adviceReceived = false,
  });

  final bool isLoading;
  final String advice;
  final String error;
  final bool adviceReceived;

  RegionalFatBurningState copyWith({
    bool? isLoading,
    String? advice,
    String? error,
    bool? adviceReceived,
  }) {
    return RegionalFatBurningState(
      isLoading: isLoading ?? this.isLoading,
      advice: advice ?? this.advice,
      error: error ?? this.error,
      adviceReceived: adviceReceived ?? this.adviceReceived,
    );
  }
}
