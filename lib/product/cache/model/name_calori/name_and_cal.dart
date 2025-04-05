import 'package:hive_flutter/hive_flutter.dart';
part 'name_and_cal.g.dart';

@HiveType(typeId: 1)
class NameAndCalModel {
  NameAndCalModel({required this.userName, required this.targetCal});

  @HiveField(0)
  final String userName;

  @HiveField(1)
  final double targetCal;

  NameAndCalModel copyWith({
    String? userName,
    double? targetCal,
  }) {
    return NameAndCalModel(
      userName: userName ?? this.userName,
      targetCal: targetCal ?? this.targetCal,
    );
  }
}
