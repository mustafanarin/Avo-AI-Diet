import 'package:avo_ai_diet/feature/favorites/view/favorite_view.dart';
import 'package:avo_ai_diet/feature/home/view/home_view.dart';
import 'package:avo_ai_diet/feature/profile/view/profile_view.dart';
import 'package:avo_ai_diet/feature/search/view/search_view.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final class CustomTabBarView extends HookWidget {
  const CustomTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final selectedIndex = useState(0);

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          HomeView(),
          SearchView(),
          SizedBox.shrink(),
          FavoriteView(),
          ProfileView(),
        ],
      ),
      floatingActionButton: Container(
        height: 65.h,
        width: 65.w,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: ProjectColors.green,
          child: const Icon(Icons.eco, color: ProjectColors.white, size: 30),
          onPressed: () {
            context.push(RouteNames.chat);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: ProjectColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: ProjectColors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: ProjectStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: ProjectStrings.search,
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: ProjectStrings.favorites,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: ProjectStrings.profile,
            ),
          ],
          currentIndex: selectedIndex.value,
          selectedItemColor: ProjectColors.green,
          unselectedItemColor: ProjectColors.grey,
          onTap: (index) {
            if (index == 2) return;
            selectedIndex.value = index;
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
