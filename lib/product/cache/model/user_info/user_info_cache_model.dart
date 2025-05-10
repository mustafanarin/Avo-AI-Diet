import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_info_cache_model.g.dart';

@HiveType(typeId: 4)
final class UserInfoCacheModel extends Equatable {
  const UserInfoCacheModel({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  @HiveField(0)
  final String gender;
  @HiveField(1)
  final String age;
  @HiveField(2)
  final String height;
  @HiveField(3)
  final String weight;

  UserInfoCacheModel copyWith({
    String? gender,
    String? age,
    String? height,
    String? weight,
    String? goal,
    String? budget,
    String? activityLevel,
  }) {
    return UserInfoCacheModel(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  List<Object?> get props => [gender, age, height, weight];
}
