import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_flutter_app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/auth_data.dart';

class ErrorMap {
  final Map<String, String> _errors = {
    'EMAIL_EXISTS': 'Email já em uso, tente com outro.',
    'OPERATION_NOT_ALLOWED': 'Autenticação foi desabilitada.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Você foi bloqueado temporariamente, tente novamente mais tarde.',
    'EMAIL_NOT_FOUND': 'Email e/ou senha não estão corretos.',
    'INVALID_PASSWORD': 'Email e/ou senha não estão corretos.',
    'USER_DISABLED': 'Conta desabilitada.',
    'INVALID_LOGIN_CREDENTIALS': 'Email e/ou senha não estão corretos.',
  };

  String getMessage(String key) {
    String? message = _errors[key];
    if (message == null) {
      return 'Ocorreu um erro, tente novamente mais tarde.';
    }
    return message;
  }
}

class Auth with ChangeNotifier {
  final String _urlSignup =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$keyWeb";

  final String _urlSignin =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$keyWeb";

  AuthData? authData;
  Timer? _logoutTimer;

  Future<void> tryAutoLogin() {
    return AuthData.loadFromStore().then((authDataFromStore) {
      if (authDataFromStore == null) {
        return;
      }
      authData = authDataFromStore;
    });
  }

  bool isAuth() {
    if (authData == null) {
      return false;
    }

    return authData!.expiryDate.isAfter(DateTime.now());
  }

  Future<void> autenticate(String email, String password) async {
    final resp = await http.post(
      Uri.parse(_urlSignin),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    if (resp.statusCode >= 400) {
      final dynamic body = jsonDecode(resp.body);

      if (body == null) {
        throw HttpException(
          message: "Ocorreu um problema. Tente novamente mais tarde",
          status: resp.statusCode,
        );
      }

      if (body["error"] != null) {
        String message = ErrorMap().getMessage(body["error"]["message"]);
        throw HttpException(
          message: message,
          status: resp.statusCode,
        );
      }
    }

    final dynamic body = jsonDecode(resp.body);
    if (body == null) {
      throw HttpException(
        message: "Ocorreu um problema. Tente novamente mais tarde",
        status: resp.statusCode,
      );
    }

    await _authenticateFromBody(body);
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    final resp = await http.post(
      Uri.parse(
        _urlSignup,
      ),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    if (resp.statusCode >= 400) {
      final dynamic body = jsonDecode(resp.body);

      if (body == null) {
        throw HttpException(
          message: "Ocorreu um problema. Tente novamente mais tarde",
          status: resp.statusCode,
        );
      }

      if (body["error"] != null) {
        String message = ErrorMap().getMessage(body["error"]["message"]);
        throw HttpException(
          message: message,
          status: resp.statusCode,
        );
      }
    }

    final dynamic body = jsonDecode(resp.body);
    if (body == null) {
      throw HttpException(
        message: "Ocorreu um problema. Tente novamente mais tarde",
        status: resp.statusCode,
      );
    }

    await _authenticateFromBody(body);
    notifyListeners();
  }

  Future<void> logout() async {
    final isLogout = await AuthData.logout();
    if (!isLogout) {
      return;
    }
    authData = null;
    _logoutTimer = null;
    _clearLogoutTimer();
    notifyListeners();
  }

  void _initAutoLogout() {
    if (authData == null) {
      return;
    }

    _clearLogoutTimer();

    DateTime now = DateTime.now();
    Duration expireIn = authData!.expiryDate.difference(now);
    _logoutTimer = Timer(Duration(seconds: expireIn.inSeconds), logout);
  }

  Future<void> _authenticateFromBody(dynamic body) async {
    DateTime now = DateTime.now();

    // if has 1 hour = body["expiresIn"] == "3600"
    Duration durationExpiration = Duration(
      seconds: int.parse(body["expiresIn"] as String),
    );

    // now + 3600
    DateTime expiryDateWithAdd = now.add(durationExpiration);

    authData = AuthData(
      email: body["email"] as String,
      token: body["idToken"] as String,
      userId: body["localId"] as String,
      expiryDate: expiryDateWithAdd,
    );

    await AuthData.saveToStore(authData!);
    _initAutoLogout();
  }

  void _clearLogoutTimer() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }
  }
}
