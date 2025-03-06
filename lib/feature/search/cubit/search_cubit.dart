import 'dart:async';
import 'dart:convert';

import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/state/search_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState()) {
    loadAllFoods();
  }

  List<FoodModel> _allFoods = [];
  Timer? _debounce;

  Future<void> loadAllFoods() async {
    try {
      emit(state.copyWith(isLoading: true));

      _allFoods = await _fetchAllFoods();

      emit(state.copyWith(isLoading: false, results: _allFoods));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Veriler yüklenirken bir hata oluştu: $e',
        ),
      );
    }
  }

  Future<List<FoodModel>> _fetchAllFoods() async {
    final response = await rootBundle.loadString('assets/json/foods.json');
    final data = jsonDecode(response);

    return (data['foods'] as List).map((item) => FoodModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  void searchTextChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      emit(state.copyWith(query: query));

      if (query.isNotEmpty) {
        filterFoods(query);
      } else {
        // if query empty, return all foods
        emit(state.copyWith(results: _allFoods));
      }
    });
  }

  void filterFoods(String query) {
    try {
      final filteredFoods = _allFoods.where((food) => food.name.toLowerCase().contains(query.toLowerCase())).toList();

      emit(state.copyWith(results: filteredFoods));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Besin arama sırasında bir hata oluştu: $e',
        ),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(results: [], query: ''));

    loadAllFoods();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
