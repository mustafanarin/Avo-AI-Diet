import 'package:avo_ai_diet/feature/favorites/view/favorite_view.dart';
import 'package:avo_ai_diet/feature/home/view/home_view.dart';
import 'package:avo_ai_diet/feature/profile/view/profile/profile_view.dart';
import 'package:avo_ai_diet/feature/search/view/food_search/search_view.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final class CustomTabBarView extends HookWidget {
  const CustomTabBarView({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialIndex);
    final selectedIndex = useState(initialIndex);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final showBottomBar = keyboardHeight == 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => selectedIndex.value = index,
        children: const [
          HomeView(),
          SearchView(),
          FavoriteView(),
          ProfileView(),
        ],
      ),
      floatingActionButton: showBottomBar
          ? Container(
              height: 65.h,
              width: 65.w,
              margin: EdgeInsets.only(top: 15.h),
              child: FloatingActionButton(
                heroTag: null,
                elevation: 0,
                backgroundColor: ProjectColors.green,
                child: const Icon(Icons.eco, color: ProjectColors.white, size: 30),
                onPressed: () {
                  context.push(RouteNames.chat);
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: showBottomBar
          ? Container(
              decoration: BoxDecoration(
                color: ProjectColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ProjectColors.grey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: ProjectColors.green,
                  unselectedItemColor: ProjectColors.grey,
                  selectedFontSize: 12.sp,
                  unselectedFontSize: 12.sp,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined, size: 22),
                      label: ProjectStrings.home,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_outlined, size: 22),
                      label: ProjectStrings.search,
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox.shrink(),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_outline, size: 22),
                      label: ProjectStrings.favorites,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline, size: 22),
                      label: ProjectStrings.profile,
                    ),
                  ],
                  currentIndex: _getBottomNavIndex(selectedIndex.value),
                  onTap: (index) {
                    if (index == 2) return;
                    final pageIndex = _getPageIndex(index);
                    selectedIndex.value = pageIndex;
                    pageController.jumpToPage(pageIndex);
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // Changes the PageView index to the BottomNavigationBar index
  int _getBottomNavIndex(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 0; // Home
      case 1:
        return 1; // Search
      case 2:
        return 3; // Favorites
      case 3:
        return 4; // Profile
      default:
        return 0;
    }
  }

  // Changes the BottomNavigationBar index to the PageView index
  int _getPageIndex(int bottomNavIndex) {
    switch (bottomNavIndex) {
      case 0:
        return 0; // Home
      case 1:
        return 1; // Search
      case 3:
        return 2; // Favorites
      case 4:
        return 3; // Profile
      default:
        return 0;
    }
  }
}
