import 'package:avo_ai_diet/feature/search/cubit/search_cubit.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/state/search_state.dart';
import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/icon_data_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

final class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // to track page changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when the page becomes visible again
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _focusNode.unfocus();
    }
    super.didChangeAppLifecycleState(state);
  }

  // Let's close the keyboard when it becomes visible and is built
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => getIt<SearchCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            // TODOresizeToAvoidBottomInset
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: _focusNode.unfocus,
              behavior: HitTestBehavior.translucent,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 100,
                    floating: true,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: ProjectColors.backgroundCream,
                    centerTitle: false,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(left: 16),
                      title: Text(
                        ProjectStrings.searchFood,
                        style: context.textTheme().titleLarge,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ProjectColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ProjectColors.forestGreen.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: ProjectColors.forestGreen,
                          ),
                          iconColor: ProjectColors.forestGreen,
                          hintText: ProjectStrings.enterFoodName,
                          filled: true,
                          fillColor: ProjectColors.white,
                          suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                              return state.query.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _controller.clear();
                                        context.read<SearchCubit>().clearSearch();
                                        _focusNode.unfocus(); // Close keyboard using FocusNode
                                      },
                                      icon: const Icon(Icons.clear),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        onChanged: (value) => context.read<SearchCubit>().searchTextChanged(value),
                      ),
                    ),
                  ),
                  BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ProjectColors.forestGreen,
                            ),
                          ),
                        );
                      } else if (state.query.isNotEmpty && state.results.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(
                                  flex: 2,
                                ),
                                Image.asset(
                                  PngName.noSearchAvo.path,
                                  height: 150.h,
                                ),
                                const Text(ProjectStrings.noResults),
                                const Spacer(
                                  flex: 6,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state.errorMessage != null) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(state.errorMessage!),
                          ),
                        );
                      } else if (state.results.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text(ProjectStrings.noFood),
                          ),
                        );
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final food = state.results[index];
                              return _FoodCard(
                                food: food,
                                onTap: () {
                                  _focusNode.unfocus();
                                  context.push(RouteNames.detail, extra: food);
                                },
                              );
                            },
                            childCount: state.results.length,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.food,
    required this.onTap,
  });

  final FoodModel food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ProjectColors.successGreen.withValues(alpha: 0.3),
                ),
                child: Icon(
                  food.getIconData(),
                  color: ProjectColors.forestGreen,
                  size: 30.sp,
                ),
              ),
              title: Text(
                food.name,
                style: context.textTheme().titleMedium,
              ),
              subtitle: Text(
                food.unitType == 'gram' ? ProjectStrings.oneHundredGram : '1 ${food.unitType}',
                style: context.textTheme().bodySmall?.copyWith(
                      color: ProjectColors.grey600,
                    ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ProjectColors.forestGreen.withValues(alpha: 0.1),
                ),
                child: Text(
                  '${food.calorie} kcal',
                  style: context.textTheme().titleMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // protein
                  _NutritionInfoBox(
                    icon: FontAwesomeIcons.drumstickBite,
                    value: food.protein,
                    color: ProjectColors.green,
                  ),
                  // carb
                  _NutritionInfoBox(
                    icon: FontAwesomeIcons.breadSlice,
                    value: food.carbohydrate,
                    color: ProjectColors.sandyBrown,
                  ),
                  // fat
                  _NutritionInfoBox(
                    icon: FontAwesomeIcons.droplet,
                    value: food.fat,
                    color: ProjectColors.shadow,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionInfoBox extends StatelessWidget {
  const _NutritionInfoBox({
    required this.value,
    required this.icon,
    required this.color,
  });

  final double value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            '${value}g',
            style: context.textTheme().bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
