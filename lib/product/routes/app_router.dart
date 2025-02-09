import 'package:avo_ai_diet/feature/chat/view/chat_view.dart';
import 'package:avo_ai_diet/feature/favorites/favorite_view.dart';
import 'package:avo_ai_diet/feature/home/view/home_view.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/view/name_input_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/user_info_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/welcome_view.dart';
import 'package:avo_ai_diet/feature/tabbar/tabbar_view.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  // static final GlobalKey<NavigatorState> _rootNavigatorKey =
  // GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // navigatorKey: _rootNavigatorKey,
    routes: _routes,
    initialLocation: RouteNames.favorite,
    errorBuilder: (context, state) => const _ErrorPage(),
  );

  static List<RouteBase> get _routes => [
        GoRoute(
          path: RouteNames.tabbar,
          builder: (context, state) => const CustomTabBarView(),
        ),
        GoRoute(
          path: RouteNames.welcome,
          builder: (context, state) => const WelcomeView(),
        ),
        GoRoute(
          path: RouteNames.nameInput,
          builder: (context, state) => const NameInputView(),
        ),
        GoRoute(
          path: RouteNames.userInfo,
          builder: (context, state) => UserInfoView(
            userName: state.pathParameters['userName'] ?? '',
          ),
        ),
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => BlocProvider.value(
            value: getIt<UserInfoCubit>(),
            child: const HomeView(),
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
      ];

  //  For navigation in non-context areas
  // static void navigateToHome() {
  //   _rootNavigatorKey.currentState?.pushNamed('/home');
  // }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Sayfa bulunamadı!'),
      ),
    );
  }
}
