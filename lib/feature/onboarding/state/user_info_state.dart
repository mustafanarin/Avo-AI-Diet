final class UserInfoState {
  UserInfoState({this.isLoading = false, this.response, this.error});

  final bool isLoading;
  final String? response;
  final String? error;

  UserInfoState copyWith({
    bool? isLoading,
    String? response,
    String? error,
  }) {
    return UserInfoState(
      isLoading: isLoading ?? false,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}
