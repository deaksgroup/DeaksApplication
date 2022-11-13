import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deaksapp/globals.dart' as globals;

// class Notification {
//   final Map<dynamic, dynamic> notifications;
//   Notification({required this.notifications});
// }

class NotificationFetch with ChangeNotifier {
  List<Map<dynamic, dynamic>> notifications = [];
  final String token;
  NotificationFetch({required this.token});

  Future<List<Map<dynamic, dynamic>>> loadLocalNotitifications() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userNotifications');
    if (prefs.containsKey('userNotifications')) {
      final List<dynamic> extracteddata =
          await jsonDecode(prefs.getString('userNotifications').toString())
              as List<dynamic>;
      notifications = List<Map<dynamic, dynamic>>.from(extracteddata);
      notifyListeners();
      return notifications;
    }
    return notifications;
  }

  Future<Map<dynamic, dynamic>> sendNotificationResponse(
      Map<String, String> responseMessage) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;

    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      //404

      response = await dio.post("${globals.url}/notificationResponse",
          options: Options(headers: headers), data: responseMessage);

      final responseData = response.data;
      if (responseData == null) {
        return extractedData;
      }

      extractedData = Map<dynamic, dynamic>.from(responseData);
      return extractedData;

      // Map<String, String> convertedProfile = extractedProfile
      //     .map((key, value) => MapEntry(key.toString(), value.toString()));
      // profile = convertedProfile;
      ////print(convertedProfile);
      // notifyListeners();
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        ////print(e.response!.data);
        ////print(e.response!.headers);
        ////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ////print(e.requestOptions);
        ////print(e.message);
      }
    }
    return extractedData;
  }
}
