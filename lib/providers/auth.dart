import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop4you/models/http_exception.dart';

class Auth with ChangeNotifier {
  // mixins

  String _token;
  Map<String, dynamic> _user;
  bool _showSensitive;

  /* Since the token we using will not expire, so we don't need these so far. */
  // DateTime _expiryDate;
  // Timer _authTime;

  

  void setSensitive(bool input) {
    if (input == showSensitive) {
      return;
    }

    _showSensitive = input;
    notifyListeners();
  }

  bool get showSensitive {
    return _showSensitive == true;
  }

  String get token {
    return _token;
  }

  String get userId {
    if (_user != null) {
      return _user["id"];
    }
    return null;
  }

  bool get isLogin {
    return token != null;
  }

  bool get isAdmin {
    if (_user != null) {
      return _user["role"] == "admin";
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    // The urlSeg can be "login" or "signup"

    final url = "https://shop4you-au.appspot.com/user/$urlSeg";
    try {
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
        },
        body: "email=$email&password=$password",
      );

      final resData = json.decode(res.body);
      if (res.statusCode >= 400) {
        throw HttpException(resData['error'], resData['msg']);
      }

      // Adding data
      _token = resData["token"];
      _user = resData["user"];

      notifyListeners();

      // Saving both user and token
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("user", json.encode(_user));
      prefs.setString("token", _token);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signupUser(String email, String password) async {
    return _authenticate(email, password, "signup");
  }

  Future<void> loginUser(String email, String password) async {
    return _authenticate(email, password, "login");
  }

  // Try to login by the sharePref
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("user") || !prefs.containsKey("token")) {
      return false;
    }

    _user = json.decode(prefs.getString("user")) as Map<String, Object>;

    _token = prefs.getString("token");

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    prefs.remove("user");
    prefs.remove("token");

    // delete the data stored in the sharedPref
  }
}
