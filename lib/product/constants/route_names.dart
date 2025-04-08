import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract final class RouteNames {
  // static const String init = '/';
  static const String welcome = '/welcome';
  static const String nameInput = '/name';
  static const String userInfo = '/user/:userName';
  static const String tabbar = '/tabbar';
  static const String chat = '/chat';
  static const String favorite = '/favorite';
  static const String detail = '/detail';
  static const String nameEdit = '/nameEdit';
  static const String userInfoEdit = '/userInfoEdit';
  static const String tabbarWithIndex = '/tabbar/:tabIndex';


  static String userInfoPath(String userName) => '/user/$userName';
  static String tabbarWithIndexPath(int index) => '/tabbar/$index';
}
