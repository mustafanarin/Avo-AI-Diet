final class NameEditState {
  NameEditState({this.name, this.isLoading = false, this.error});

  final bool isLoading;
  final String? name;
  final String? error;

  NameEditState copyWith({
    bool? isLoading,
    String? name,
    String? error,
  }) {
    return NameEditState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      error: error ?? this.error,
    );
  }
}
