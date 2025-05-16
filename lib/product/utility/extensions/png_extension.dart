import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';

extension PngNameExtension on PngName {
  String _path() {
    switch (this) {
      case PngName.noSearchAvo:
        return 'noSearchAvo';
      case PngName.noFavoriteAvo:
        return 'noFavoriteAvo';
      case PngName.welcomeAvo:
        return 'welcomeAvo';
      case PngName.appName:
        return 'appName';
    }
  }

  String get path => 'assets/png/${_path()}.png';
}
