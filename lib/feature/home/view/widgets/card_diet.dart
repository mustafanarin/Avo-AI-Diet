part of '../home_view.dart';

class _ModernDietCard extends HookWidget {
  const _ModernDietCard();

  @override
  Widget build(BuildContext context) {
    final showShadow = useState(false);

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            final shouldShowShadow = scrollNotification.metrics.pixels > 10;
            if (showShadow.value != shouldShowShadow) {
              showShadow.value = shouldShowShadow;
            }
            return true;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocConsumer<AiDietAdviceCubit, AiDietAdviceState>(
              listener: (context, state) {
                if (state.error != null) {
                  ProjectToastMessage.showError(context, state.error!);
                }
              },
              builder: (context, state) {
                // Loading State
                if (state.isLoading) {
                  return _LoadingWidget();
                }

                // Error State
                if (state.error != null) {
                  return _ErrorDietWidget(
                    errorMessage: state.error!,
                    onCreateNew: () => _navigateToProfile(context),
                  );
                }

                // Success State
                if (state.response != null) {
                  return _SuccessDietCard(response: state.response!);
                }

                // Fallback
                return _LoadingWidget();
              },
            ),
          ),
        ),

        // Shadow effect
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: showShadow.value ? 1 : 0,
            duration: AppDurations.smallMilliseconds(),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ProjectColors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(BuildContext context) {
    context.push(RouteNames.userInfoEdit);
  }
}
