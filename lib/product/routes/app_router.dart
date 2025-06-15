import 'package:avo_ai_diet/feature/chat/view/chat_view.dart';
import 'package:avo_ai_diet/feature/favorites/view/favorite_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/name_input_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/user_info_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/welcome_view.dart';
import 'package:avo_ai_diet/feature/profile/cubit/regional_fat_burning_cubit.dart';
import 'package:avo_ai_diet/feature/profile/view/name_edit_view.dart';
import 'package:avo_ai_diet/feature/profile/view/regional_fat_burning.dart';
import 'package:avo_ai_diet/feature/profile/view/user_info_edit_view.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/view/food_detail_view.dart';
import 'package:avo_ai_diet/feature/tabbar/tabbar_view.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  static final GoRouter router = GoRouter(
    routes: _routes,
    initialLocation: RouteNames.welcome,
    errorBuilder: (context, state) => const _ErrorPage(),
  );

  static List<RouteBase> get _routes => [
        GoRoute(
          path: RouteNames.tabbar,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 1200),
            reverseTransitionDuration: const Duration(milliseconds: 1200),
            child: const CustomTabBarView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.tabbarWithIndex,
          pageBuilder: (context, state) {
            final tabIndex = int.tryParse(state.pathParameters['tabIndex'] ?? '0') ?? 0;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 1200),
              reverseTransitionDuration: const Duration(milliseconds: 1200),
              child: CustomTabBarView(initialIndex: tabIndex),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: RouteNames.welcome,
          builder: (context, state) => const WelcomeView(),
        ),
        GoRoute(
          path: RouteNames.nameInput,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const NameInputView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.userInfo,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: UserInfoView(
              userName: state.pathParameters['userName'] ?? '',
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.chat,
          builder: (context, state) => const ChatView(),
        ),
        GoRoute(
          path: RouteNames.favorite,
          builder: (context, state) => const FavoriteView(),
        ),
        GoRoute(
          path: RouteNames.detail,
          builder: (context, state) {
            final foodModel = state.extra! as FoodModel;
            return FoodDetailPage(foodModel: foodModel);
          },
        ),
        GoRoute(
          path: RouteNames.nameEdit,
          builder: (context, state) => const NameEditView(),
        ),
        GoRoute(
          path: RouteNames.userInfoEdit,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 1200),
            reverseTransitionDuration: const Duration(milliseconds: 1200),
            child: const UserInfoEditView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteNames.regionalFat,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<RegionalFatBurningCubit>(),
            child: const RegionalFatBurning(),
          ),
        ),
      ];
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: const Center(
        child: Text('Sayfa bulunamadı!'),
      ),
    );
  }
}
