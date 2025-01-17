import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract final class RouteNames {
  // static const String init = '/';
  static const String welcome = '/welcome';
  static const String nameInput = '/name';
  static const String userInfo = '/user';
  static const String tabbar = '/tabbar';
  static const String home = '/home/:name/:calorie';
  static const String chat = '/chat';

  static String homePath(String userName, int targetCal) => '/home/$userName/$targetCal';
}
