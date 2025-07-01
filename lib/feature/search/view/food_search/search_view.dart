import 'package:avo_ai_diet/feature/search/cubit/search_cubit.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/state/search_state.dart';
import 'package:avo_ai_diet/feature/search/view/food_search/mixin/search_mixin.dart';
import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/icon_data_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part './widgets/food_card.dart';
part './widgets/search_bar.dart';
part './widgets/search_results.dart';

final class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with SearchViewMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => getIt<SearchCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () => focusNode.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  _SearchBarSection(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) => onSearchChanged(context, value),
                    onClear: () => onSearchCleared(context),
                  ),
                  _SearchResultsSection(
                    onFoodTap: (food) => onFoodTapped(context, food),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
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
    );
  }
}
