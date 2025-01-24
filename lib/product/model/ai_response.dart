import 'package:hive_flutter/hive_flutter.dart';

part 'ai_response.g.dart';

@HiveType(typeId: 0)
class AiResponse {
  AiResponse({required this.dietPlan, required this.createdAt});

  @HiveField(0)
  final String dietPlan;
  @HiveField(1)
  final DateTime createdAt;
}
