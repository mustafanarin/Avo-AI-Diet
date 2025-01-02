import 'package:avo_ai_diet/feature/home/view/home_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/name_input_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/user_info_view.dart';
import 'package:avo_ai_diet/feature/onboarding/view/welcome_view.dart';
import 'package:avo_ai_diet/feature/tabbar/tabbar_view.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  // static final GlobalKey<NavigatorState> _rootNavigatorKey =
  // GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // navigatorKey: _rootNavigatorKey,
    routes: _routes,
    initialLocation: RouteNames.tabbar,
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
          builder: (context, state) => UserInfoView(),
        ),
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => HomeView(
            userName: state.pathParameters['userName'] ?? '',
            targetCal: double.tryParse(state.pathParameters['targetCal'] ?? '0') ?? 0.0,
          ),
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
    return const Scaffold(
      body: Center(
        child: Text('Sayfa bulunamadı!'),
      ),
    );
  }
}
