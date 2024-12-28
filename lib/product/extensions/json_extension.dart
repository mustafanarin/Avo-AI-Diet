import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';

extension PngNameExtension on JsonName {
  String _path() {
    switch (this) {
      case JsonName.avoAnimation:
        return 'avoAnimation';
    }
  }

  String get path => 'assets/json/${_path()}.json';
}
