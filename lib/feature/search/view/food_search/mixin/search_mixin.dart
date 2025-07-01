import 'package:avo_ai_diet/feature/search/cubit/search_cubit.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/view/food_search/search_view.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

mixin SearchViewMixin on State<SearchView> {
  // Controllers
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupLifecycleObserver();
  }

  @override
  void dispose() {
    _disposeControllers();
    _removeLifecycleObserver();
    super.dispose();
  }

  // Lifecycle management
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      focusNode.unfocus();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    focusNode.unfocus();
  }

  // Initialization
  void _initializeControllers() {
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  void _setupLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
  }

  void _disposeControllers() {
    controller.dispose();
    focusNode.dispose();
  }

  void _removeLifecycleObserver() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
  }

  // Search actions
  void onSearchChanged(BuildContext context, String value) {
    context.read<SearchCubit>().searchTextChanged(value);
  }

  void onSearchCleared(BuildContext context) {
    controller.clear();
    context.read<SearchCubit>().clearSearch();
    focusNode.unfocus();
  }

  void onFoodTapped(BuildContext context, FoodModel food) {
    focusNode.unfocus();
    context.push(RouteNames.detail, extra: food);
  }

  // Keyboard management
  void closeKeyboard() {
    focusNode.unfocus();
  }
}
