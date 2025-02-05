class ChatState {
  ChatState({ this.isLoading = false,  this.response,  this.error});

  final bool isLoading;
  final String? response;
  final String? error;

  ChatState copyWith({
    bool? isLoading,
    String? response,
    String? error,
  }) {
    return ChatState(
      isLoading: isLoading ?? false,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}
