import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  const SearchState({
    this.isLoading = false,
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  final bool isLoading;
  final List<FoodModel> results;
  final String query;
  final String? errorMessage;

  SearchState copyWith({
    bool? isLoading,
    List<FoodModel>? results,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, query, results, errorMessage];
}
