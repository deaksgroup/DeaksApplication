import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deaksapp/globals.dart' as globals;

class Auth with ChangeNotifier {
  String _token = "";
  DateTime _expiryDate = DateTime.now();
  String _userName = "";
  String _email = "";
  String _password = "";
  String _fullName = "";
  bool _setPassword = false;
  bool _numberIsVerified = false;
  String _contactNumber = "";
  Timer? _authTimer;

  void setEmailAndPassword(String email, String password) {
    _email = email;
    _password = password;
    return;
  }

  void setFullNameAndContactNumber(String fullName, String contactNumber) {
    _fullName = fullName.toString();
    _contactNumber = contactNumber.toString();
    return;
  }

  void setContactNumber(String? contactNumber) {
    _contactNumber = contactNumber.toString();
    notifyListeners();
    return;
  }

  void setEmail(String? email) {
    _email = email.toString();
  }

  void setPassword(String? newPassword) {
    _password = newPassword.toString();
  }

  String getContactNumber() {
    return _contactNumber;
  }

  String getFullName() {
    return _userName;
  }

  bool get isAuth {
    return token.isNotEmpty && !_setPassword;
  }

  bool get isNumberVerified {
    return _numberIsVerified;
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != "") {
      return _token;
    }
    return "";
  }

  String get userId {
    return _userName;
  }

  Future<Map<dynamic, dynamic>> loginUser(Map<String, String> loginData) async {
    // log("message");
    Map<dynamic, dynamic> extracteddata = {};
    var dio = Dio();
    Response response;

    try {
      //404
      response = await dio.post("${globals.url}/userLogin", data: loginData);
      // //////print(response.data.toString());

      final data = response.data;
      if (data == null) {
        return extracteddata;
      }
      Map<dynamic, dynamic> extractedData = Map<dynamic, dynamic>.from(data);

      if (extractedData["token"] != null) {
        _token = extractedData["token"];
        _expiryDate = DateTime.now().add(const Duration(minutes: 8000));
        _userName = extractedData["user"]["name"] ?? "";
        _email = extractedData["user"]["email"] ?? "";
        _numberIsVerified = extractedData["user"]["numberIsVerified"] ?? false;
        _contactNumber = extractedData["user"]["contactNumber"] ?? "";
      }
      ////print(extractedData);
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': _userName,
          'expiryDate': _expiryDate.toIso8601String(),
          "email": _email,
          "contactNumber": _contactNumber,
          "numberIsVerified": _numberIsVerified.toString(),
        },
      );
      await prefs.setString('userData', userData);
      // log(userData);
      ////print("Hello");
      return extractedData;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //////print(e.response!.data);
        //////print(e.response!.headers);
        //////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //////print(e.requestOptions);
        //////print(e.message);
      }
    }
    return extracteddata;
  }

  Future<Map<dynamic, dynamic>> signUpUser() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserPushToken =
        await jsonDecode(prefs.getString('userPushToken').toString())
            as Map<dynamic, dynamic>;
    var dio = Dio();
    Response response;
    Map<dynamic, dynamic> extractedData = {};
    Map<String, String> signUpData = {
      "email": _email,
      "password": _password,
      "name": _fullName,
      "contactNumber": _contactNumber,
      "userPushToken": extractedUserPushToken["userPushToken"].toString(),
    };

    try {
      //404
      response =
          await dio.post("${globals.url}/registerUser", data: signUpData);
      //////print(response.data);

      final data = response.data;
      if (data == null) {
        return extractedData;
      }
      extractedData = Map<dynamic, dynamic>.from(data);

      if (extractedData["token"] != null) {
        _token = extractedData["token"];
        _expiryDate = DateTime.now().add(const Duration(minutes: 8000));
        _userName = extractedData["user"]["name"] ?? "";
        _email = extractedData["user"]["email"] ?? "";
        _numberIsVerified = extractedData["user"]["numberIsVerified"] ?? false;
        _contactNumber = extractedData["user"]["contactNumber"] ?? "";
      } else {
        return extractedData;
      }
      _autoLogout();
      ////print(extractedData);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': _userName,
          'expiryDate': _expiryDate.toIso8601String(),
          "email": _email,
          "contactNumber": _contactNumber,
          "numberIsVerified": _numberIsVerified.toString(),
        },
      );
      prefs.setString('userData', userData);

      return extractedData;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //////print(e.response!.data);
        //////print(e.response!.headers);
        //////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //////print(e.requestOptions);
        //////print(e.message);
      }
    }
    return extractedData;
  }

  Future<Map<dynamic, dynamic>> verifyOtpCreate() async {
    Map<dynamic, dynamic> extractedData = {};
    Map<String, dynamic> headers = {
      "secret_token": _token,
    };
    var dio = Dio();
    Response response = await dio.post("${globals.url}/verifyNumberCreate",
        data: {"contactNumber": _contactNumber},
        options: Options(headers: headers));
    extractedData = Map<dynamic, dynamic>.from(response.data);

    return extractedData;
  }

  Future<Map<dynamic, dynamic>> verifyOtp(String otp) async {
    Map<String, dynamic> headers = {
      "secret_token": _token,
    };
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    ////print(_contactNumber);
    Response response = await dio.post("${globals.url}/verifyNumberCheck",
        data: {"otp": otp, "contactNumber": _contactNumber},
        options: Options(headers: headers));

    //////print(response.data);
    extractedData = Map<dynamic, dynamic>.from(response.data);
    if (extractedData["errorCode"] == 0) {
      //////print(extractedData["errorCode"]);
      _numberIsVerified = true;
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': _userName,
          'expiryDate': _expiryDate.toIso8601String(),
          "email": _email,
          "contactNumber": _contactNumber,
          "numberIsVerified": _numberIsVerified.toString(),
        },
      );
      prefs.setString('userData', userData);
      return extractedData;
    } else {
      return extractedData;
    }
  }

  Future<Map<dynamic, dynamic>> setNewPassword() async {
    Map<String, dynamic> headers = {
      "secret_token": _token,
    };
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();

    Response response = await dio.post("${globals.url}/setNewPassword",
        data: {"newPassword": _password}, options: Options(headers: headers));

    //////print(response.data);
    extractedData = Map<dynamic, dynamic>.from(response.data);

    if (response.data == null) {
      return extractedData;
    }
    if (extractedData["errorCode"] == 0) {
      //////print(extractedData["errorCode"]);
      _numberIsVerified = true;
      _setPassword = false;
      _autoLogout();
      notifyListeners();

      return extractedData;
    } else {
      return extractedData;
    }
  }

  Future<Map<dynamic, dynamic>> verifyForgotOtp(String otp) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();

    Response response = await dio.post(
      "${globals.url}/forgotPasswordOTPVerify",
      data: {"otp": otp, "email": _email},
    );

    //////print(response.data);
    final data = response.data;
    if (data == null) {
      return extractedData;
    }
    extractedData = Map<dynamic, dynamic>.from(data);

    if (extractedData["token"] != null) {
      _token = extractedData["token"];
      _expiryDate = DateTime.now().add(const Duration(minutes: 8000));
      _userName = extractedData["user"]["name"] ?? "";
      _email = extractedData["user"]["email"] ?? "";
      _numberIsVerified = extractedData["user"]["numberIsVerified"] ?? false;
      _contactNumber = extractedData["user"]["contactNumber"] ?? "";
      _setPassword = true;
    } else {
      return extractedData;
    }
    if (extractedData["errorCode"] == 0) {
      //////print(extractedData["errorCode"]);
      _numberIsVerified = true;
      _autoLogout();
      // notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': _userName,
          'expiryDate': _expiryDate.toIso8601String(),
          "email": _email,
          "contactNumber": _contactNumber,
          "numberIsVerified": _numberIsVerified.toString(),
        },
      );
      prefs.setString('userData', userData);
      return extractedData;
    } else {
      return extractedData;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      //////print("1");
      return false;
    }

    // //////print(prefs.getString('userData'));
    final extractedUserData =
        await jsonDecode(prefs.getString('userData').toString())
            as Map<dynamic, dynamic>;
    //////print(extractedUserData);

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    // log(extractedUserData['expiryDate']);

    if (extractedUserData["numberIsVerified"] == "false") {
      //log("1");
      _numberIsVerified = false;
    } else {
      _numberIsVerified = true;
      //log("2");
    }
    // log("autologing");
    if (expiryDate.isBefore(DateTime.now())) {
      //////print("2");

      return false;
    }

    _token = extractedUserData['token'];
    _userName = extractedUserData['userName'];
    _expiryDate = expiryDate;
    _email = extractedUserData['email'];
    _contactNumber = extractedUserData['contactNumber'];

    // log("autologing");

    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<Map<dynamic, dynamic>> deleteAccount(String? password) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Map<String, dynamic> headers = {
      "secret_token": _token,
    };
    Response response = await dio.patch(
      "${globals.url}/deleteAccount",
      data: {"password": password},
      options: Options(headers: headers),
    );

    //////print(response.data);
    final data = response.data;
    if (data == null) {
      return extractedData;
    }
    extractedData = Map<dynamic, dynamic>.from(data);
    return extractedData;
  }

  Future<void> logout() async {
    //////print("LogoUt");
    _token = "";
    _userName = "";
    _expiryDate = DateTime.now();
    _email = "";
    _numberIsVerified = false;
    _contactNumber = "";
    _authTimer = Timer(const Duration(seconds: 0), (() {}));
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = Timer(const Duration(seconds: 0), (() {}));
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    //////print("autoLogoUt");
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<Map<dynamic, dynamic>> forgotPassword() async {
    var dio = Dio();
    Response response;
    Map<dynamic, dynamic> extractedData = {};

    Map<String, String> userData = {
      "email": _email,
    };

    try {
      //404
      response =
          await dio.post("${globals.url}/forgotPassword", data: userData);
      //////print(response.data);

      final data = response.data;
      if (data == null) {
        return extractedData;
      }
      extractedData = Map<dynamic, dynamic>.from(data);

      return extractedData;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //////print(e.response!.data);
        //////print(e.response!.headers);
        //////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //////print(e.requestOptions);
        //////print(e.message);
      }
    }
    return extractedData;
  }
}
