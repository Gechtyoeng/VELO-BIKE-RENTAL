import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_bike/config/firebase_config.dart';
import 'package:velo_bike/data/dtos/pass_plan_dto.dart';
import 'package:velo_bike/data/dtos/user_pass_dto.dart';
import 'package:velo_bike/data/repositories/pass/pass_repository.dart';
import 'package:velo_bike/models/pass_plan.dart';
import 'package:velo_bike/models/user_pass.dart';

class FirebasePassRepo extends PassRepository {
  @override
  Future<List<UserPass>> getUserPasses(String userId) async {
    final uri = FirebaseConfig.baseUri.replace(path: '/userPasses.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user passes');
    }

    final decoded = json.decode(response.body);
    if (decoded == null) return [];

    final data = decoded as Map<String, dynamic>;

    return data.entries.map((entry) => UserPassDto.fromJson(entry.key, entry.value).toModel()).where((pass) => pass.userId == userId).toList();
  }

  @override
  Future<List<PassPlan>> getPassPlans() async {
    final uri = FirebaseConfig.baseUri.replace(path: '/passPlans.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch pass plans');
    }

    final decoded = json.decode(response.body);
    if (decoded == null) return [];

    final data = decoded as Map<String, dynamic>;

    return data.entries.map((entry) => PassPlanDto.fromJson(entry.key, entry.value).toModel()).toList();
  }

  @override
  Future<UserPass> buyPass(String userId, PassPlan plan) async {
    final uri = FirebaseConfig.baseUri.replace(path: '/userPasses.json');

    final now = DateTime.now();
    final endDate = now.add(Duration(days: plan.durationDays));

    final body = {
      "userId": userId,
      "planId": plan.id,
      "status": "active",
      "startDate": now.toIso8601String(),
      "endDate": endDate.toIso8601String(),

      "totalRides": plan.durationDays,
      "usedRides": 0,
    };

    final response = await http.post(uri, body: json.encode(body));

    if (response.statusCode != 200) {
      throw Exception("Failed to buy pass");
    }

    final decoded = json.decode(response.body);

    final newId = decoded['name']; // Firebase returns generated id

    return UserPass(id: newId, userId: userId, planId: plan.id, status: "active", startDate: now, endDate: endDate, totalRides: plan.durationDays, usedRides: 0);
  }

  @override
  Future<void> updateUserPass(UserPass pass) async {
    final uri = FirebaseConfig.baseUri.replace(path: '/userPasses/${pass.id}.json');

    final body = {
      "userId": pass.userId,
      "planId": pass.planId,
      "status": pass.status,
      "startDate": pass.startDate.toIso8601String(),
      "endDate": pass.endDate.toIso8601String(),
      //update rides
      "totalRides": pass.totalRides,
      "usedRides": pass.usedRides,
    };

    final response = await http.put(uri, body: json.encode(body));

    if (response.statusCode != 200) {
      throw Exception("Failed to update pass");
    }
  }
}
