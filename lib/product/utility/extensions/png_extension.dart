import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';

extension PngNameExtension on PngName {
  String _path() {
    switch (this) {
      case PngName.avo:
        return 'avo';
      case PngName.noSearchAvo:
        return 'noSearchAvo';
      case PngName.noFavoriteAvo:
        return 'noFavoriteAvo';
    }
  }

  String get path => 'assets/png/${_path()}.png';
}
