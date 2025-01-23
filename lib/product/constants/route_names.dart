import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract final class RouteNames {
  // static const String init = '/';
  static const String welcome = '/welcome';
  static const String nameInput = '/name';
  static const String userInfo = '/user/:userName';
  static const String tabbar = '/tabbar';
  static const String home = '/home/:userName/:targetCal';
  static const String chat = '/chat';

  static String userInfoPath(String userName) => '/user/$userName';

  static String homePath(String userName, int targetCal) => '/home/$userName/$targetCal';
}
