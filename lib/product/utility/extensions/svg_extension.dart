import 'package:avo_ai_diet/product/constants/enum/general/svg_name.dart';

extension SvgNameExtension on SvgName {
  String _path() {
    switch (this) {
      case SvgName.manDiagram:
        return 'manDiagram';
      case SvgName.womanDiagram:
        return 'womanDiagram';
    }
  }

  String get path => 'assets/svg/${_path()}.svg';
}
