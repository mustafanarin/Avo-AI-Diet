import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';

extension JsonNameExtension on JsonName {
  String _path() {
    switch (this) {
      case JsonName.avoAnimation:
        return 'avoAnimation';
      case JsonName.avoWalk:
        return 'avoWalk';
    }
  }

  String get path => 'assets/json/${_path()}.json';
}
