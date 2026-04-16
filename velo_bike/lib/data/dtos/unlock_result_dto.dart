import '../../models/unlock_result.dart';

class UnlockResultDTO {
  static UnlockResult fromJson(Map<String, dynamic> json) {
    return UnlockResult(
      success: json['success'],
      message: json['message'],
    );
  }
}