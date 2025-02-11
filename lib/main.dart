import 'package:avo_ai_diet/feature/favorites/cubit/favorites_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cubit.dart';
import 'package:avo_ai_diet/product/routes/app_router.dart';
import 'package:avo_ai_diet/product/theme/app_theme.dart';
import 'package:avo_ai_diet/product/utility/init/app_initialize.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await AppInitialize.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UserInfoCubit>()),
        BlocProvider(create: (context) => getIt<NameAndCalCubit>()),
        BlocProvider(create: (context) => getIt<FavoritesCubit>())
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 808),
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getLightTheme,
            title: 'Avo AI Diyet',
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
