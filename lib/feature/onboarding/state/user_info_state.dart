final class UserInfoState {
  UserInfoState({
    this.isLoading = false, 
    this.response, 
    this.error,
    this.isNavigating = false,
  });

  final bool isLoading;
  final String? response;
  final String? error;
  final bool isNavigating;

  UserInfoState copyWith({
    bool? isLoading,
    String? response,
    String? error,
    bool? isNavigating,
  }) {
    return UserInfoState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }
}