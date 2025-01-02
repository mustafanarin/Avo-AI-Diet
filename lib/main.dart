import 'package:avo_ai_diet/product/routes/app_router.dart';
import 'package:avo_ai_diet/product/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
    
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 808),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme,
          title: 'Avo AI Diyet',
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
