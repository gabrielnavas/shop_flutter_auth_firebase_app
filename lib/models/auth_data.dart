import 'package:shop_flutter_app/data/store.dart';

class AuthData {
  final String email;
  final String token;
  final String userId;
  final DateTime expiryDate;

  static const _userDataKey = 'userData';

  const AuthData({
    required this.email,
    required this.token,
    required this.userId,
    required this.expiryDate,
  });

  static Future<bool> saveToStore(AuthData authData) {
    return Store.saveMap(AuthData._userDataKey, {
      "email": authData.email,
      "token": authData.token,
      "userId": authData.userId,
      "expiryDate": authData.expiryDate.toIso8601String(),
    });
  }

  static Future<AuthData?> loadFromStore() async {
    final data = await Store.getMap(AuthData._userDataKey);
    if (data == null) {
      return null;
    }
    return AuthData(
      email: data["email"],
      token: data["token"],
      userId: data["userId"],
      expiryDate: DateTime.parse(data["expiryDate"]),
    );
  }

  static Future<bool> logout() {
    return Store.remove(AuthData._userDataKey);
  }
}
