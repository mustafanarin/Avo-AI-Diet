part of '../search_view.dart';

class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection({
    required this.onFoodTap,
  });

  final Function(FoodModel) onFoodTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const _LoadingState();
        } else if (state.query.isNotEmpty && state.results.isEmpty) {
          return const _NoResultsState();
        } else if (state.errorMessage != null) {
          return _ErrorState(errorMessage: state.errorMessage!);
        } else if (state.results.isEmpty) {
          return const _EmptyState();
        } else {
          return _ResultsList(
            results: state.results,
            onFoodTap: onFoodTap,
          );
        }
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(
          color: ProjectColors.forestGreen,
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset(
              PngName.noSearchAvo.path,
              height: 150.h,
            ),
            const Text(ProjectStrings.noResults),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Text(errorMessage),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: Text(ProjectStrings.noFood),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.onFoodTap,
  });

  final List<FoodModel> results;
  final Function(FoodModel) onFoodTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final food = results[index];
          return _FoodCard(
            food: food,
            onTap: () => onFoodTap(food),
          );
        },
        childCount: results.length,
      ),
    );
  }
}
