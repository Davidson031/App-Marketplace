import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

import '../data/store.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuthenticated {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuthenticated ? _token : null;
  }

  String? get userId {
    return isAuthenticated ? _userId : null;
  }

  Future<void> authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      Store.saveMap('userData', {
        'token' : _token,
        'email' : _email,
        'userId' : _userId,
        'expiryDate' : _expiryDate!.toIso8601String(),
      });


      _autoLogout();

      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {

    if(isAuthenticated){ return; }

    final userData = await Store.getMap('userData');

    if(userData.isEmpty){ return; }

    final expiryDate = DateTime.parse(userData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){ return; }

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();


  }


  void logout() {
    _logoutTimer?.cancel();
    _logoutTimer = null;

    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }

}
