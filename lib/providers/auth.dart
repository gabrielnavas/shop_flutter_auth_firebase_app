import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_flutter_app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/exceptions/http_exception.dart';

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

class AuthData {
  final String email;
  final String token;
  final String uid;
  final DateTime expiryDate;

  const AuthData({
    required this.email,
    required this.token,
    required this.uid,
    required this.expiryDate,
  });
}

class Auth with ChangeNotifier {
  final String _urlSignup =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$keyWeb";

  final String _urlSignin =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$keyWeb";

  AuthData? _authData;

  bool isAuth() {
    if (_authData == null) {
      return false;
    }

    return _authData!.expiryDate.isAfter(DateTime.now());
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
    _authenticateFromBody(body);
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
    notifyListeners();
    _authenticateFromBody(body);
  }

  void _authenticateFromBody(dynamic body) {
    DateTime now = DateTime.now();

    // if has 1 hour = body["expiresIn"] == "3600"
    Duration durationExpiration = Duration(
      seconds: int.parse(body["expiresIn"] as String),
    );

    // now + 3600
    DateTime expiryDateWithAdd = now.add(durationExpiration);

    _authData = AuthData(
      email: body["email"] as String,
      token: body["idToken"] as String,
      uid: body["localId"] as String,
      expiryDate: expiryDateWithAdd,
    );
  }
}
