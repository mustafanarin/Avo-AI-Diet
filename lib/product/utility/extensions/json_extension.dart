import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';

extension JsonNameExtension on JsonName {
  String _path() {
    switch (this) {
      case JsonName.avoAnimation:
        return 'avoAnimation';
      case JsonName.avoWalk:
        return 'avoWalk';
      case JsonName.foods:
        return 'foods';
      case JsonName.writing:
        return 'writing';
    }
  }

  String get path => 'assets/json/${_path()}.json';
}
