class NameAndCalState {
  NameAndCalState({this.isLoading = false, this.name, this.targetCal, this.error});

  final bool isLoading;
  final String? name;
  final double? targetCal;
  final String? error;

  NameAndCalState copyWith({
    bool? isLoading,
    String? name,
    double? targetCal,
    String? error,
  }) {
    return NameAndCalState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      targetCal: targetCal ?? this.targetCal,
      error: error ?? this.error,
    );
  }
}
