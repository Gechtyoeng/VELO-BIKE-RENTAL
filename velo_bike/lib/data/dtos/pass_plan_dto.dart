import 'package:velo_bike/models/pass_plan.dart';


class PassPlanDto {
  final String id;
  final String name;
  final String type;
  final double price;
  final int durationDays;
  final String description;

  const PassPlanDto({required this.id, required this.name, required this.type, required this.price, required this.durationDays, required this.description});

  factory PassPlanDto.fromJson(String id, Map<String, dynamic> map) {
    return PassPlanDto(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationDays: map['durationDays'] ?? 0,
      description: map['description'] ?? '',
    );
  }

  PassPlan toModel() {
    return PassPlan(id: id, name: name, type: type, price: price, durationDays: durationDays, description: description);
  }
}
