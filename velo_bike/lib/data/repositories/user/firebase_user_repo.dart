import 'package:velo_bike/config/firebase_config.dart';
import 'package:velo_bike/data/dtos/user_dto.dart';
import 'package:velo_bike/data/repositories/user/user_repository.dart';
import 'package:velo_bike/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseUserRepo extends UserRepository {
  @override
  Future<User?> getUserById(String userId) async {
    final uri = FirebaseConfig.baseUri.replace(
      path: '/users/$userId.json',
    );

    final response = await http.get(uri);

     if (response.statusCode != 200) {
      throw Exception('Failed to fetch user');
    }

    final decoded = json.decode(response.body);

    if (decoded == null) {
      return null;
    }

    final dto = UserDto.fromJson(userId, decoded);
    return dto.toModel();
  }
}