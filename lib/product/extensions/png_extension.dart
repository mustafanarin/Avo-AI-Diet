import 'package:avo_ai_diet/product/constants/enum/png_name.dart';

extension PngNameExtension on PngName {
  String _path() {
    switch (this) {
      case PngName.avo:
        return 'avo';
    }
  }

  String get path => 'assets/png/${_path()}.png';
}
