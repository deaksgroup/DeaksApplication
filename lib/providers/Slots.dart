import 'dart:convert';
import 'dart:developer';

import 'package:deaksapp/providers/Slot.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

class Slots with ChangeNotifier {
  final String token;
  Slots({required this.token});
  List<Slot> slots = [];
  Slot? shareSlot;

  List<Slot> get getSlots {
    return slots;
  }

  Slot? get getShareSlot {
    return shareSlot;
  }

  Future<void> fetchSingleSlot(String id) async {
    print("fetch Sigle slot");
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      //404
      print(".....");
      response = await dio.get("${globals.url}/getSlot/$id",
          options: Options(headers: headers));
      print(response.data.toString());
      print(response.data);

      final extractedData = response.data;
      if (extractedData == null || extractedData == "") {
        shareSlot = null;
        return;
      }
      print(extractedData);
      // print(extractedData["result"]);

      Map<dynamic, dynamic> extractedSlot =
          Map<dynamic, dynamic>.from(extractedData);

      // //////////print(extractedSlots[2]);

      shareSlot = Slot(
        date: extractedSlot["date"] ?? "",
        id: extractedSlot["id"] ?? "",
        endTime: extractedSlot["endTime"] ?? "",
        hotel: extractedSlot["hotelDetails"] ?? {},
        outlet: extractedSlot["outletDetails"] ?? {},
        hourlyPay: extractedSlot["hourlyPay"] ?? "",
        priority: extractedSlot["priority"] ?? "",
        startTime: extractedSlot["startTime"] ?? "",
        totalPayForSlot: extractedSlot["totalPayForSlot"] ?? "",
        release: extractedSlot["release"].toString(),
        jobRemarks: extractedSlot["jobRemarks"] ?? "",
        vacancy: extractedSlot["vacancy"].toString(),
        confirmedRequests: extractedSlot["confirmedRequests"] ?? [],
        waitingRequests: extractedSlot["waitingRequests"] ?? [],
      );
      print(shareSlot);
      return;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //////////print(e.response!.data);
        //////////print(e.response!.headers);
        //////////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //////////print(e.requestOptions);
        //////////print(e.message);
      }
    }
    return;
  }

  Future<int> fetchAndSetSlots(Map<String, String> searchQuery) async {
    print("slotsFetch");
    print(searchQuery);
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      //404
      response = await dio.post("${globals.url}/getSlotsUser",
          options: Options(headers: headers), data: searchQuery);
      print(response.data.toString());

      final extractedData = response.data;
      print(extractedData);
      if (extractedData == null ||
          response.statusCode == 204 ||
          response.statusCode == 400 ||
          response.statusCode == 500) {
        return response.statusCode ?? 400;
      }
      print(extractedData);
      // print(extractedData["result"]);

      List<Map<dynamic, dynamic>> extractedSlots =
          List<Map<dynamic, dynamic>>.from(extractedData);

      // //////////print(extractedSlots[2]);

      List<Slot> loadedSlots = [];
      for (var slot in extractedSlots) {
        {
          loadedSlots.add(Slot(
            date: slot["date"] ?? "",
            id: slot["id"] ?? "",
            endTime: slot["endTime"] ?? "",
            hotel: slot["hotelDetails"] ?? {},
            outlet: slot["outletDetails"] ?? {},
            hourlyPay: slot["hourlyPay"] ?? "",
            priority: slot["priority"] ?? "",
            startTime: slot["startTime"] ?? "",
            totalPayForSlot: slot["totalPayForSlot"] ?? "",
            release: slot["release"].toString(),
            jobRemarks: slot["jobRemarks"] ?? "",
            vacancy: slot["vacancy"].toString(),
            confirmedRequests: slot["confirmedRequests"] ?? [],
            waitingRequests: slot["waitingRequests"] ?? [],
          ));
        }
        ;
      }

      slots = loadedSlots;

      notifyListeners();
      return response.statusCode ?? 200;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        return e.response!.statusCode ?? 400;
        //////////print(e.response!.data);
        //////////print(e.response!.headers);
        //////////print(e.response!.requestOptions);
      } else {
        return 400;
        // Something happened in setting up or sending the request that triggered an Error
        //////////print(e.requestOptions);
        //////////print(e.message);
      }
    }
  }

  Future<int> subscribeOutlet(String outletId) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      response = await dio.patch("${globals.url}/subscribeOutlet",
          data: {"outlet_id": outletId}, options: Options(headers: headers));
      // extractedData = Map<dynamic, dynamic>.from(response.data);
      print(response.statusCode);
      return response.statusCode ?? 400;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        ////print(e.response!.data);
        ////print(e.response!.headers);
        ////print(e.response!.requestOptions);
        return e.response!.statusCode ?? 400;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ////print(e.requestOptions);
        ////print(e.message);
        return e.response!.statusCode ?? 400;
      }
    }
  }

  Future<int> unSubscribeOutlet(String outletId) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      response = await dio.patch("${globals.url}/unSubscribeOutlet",
          data: {"outlet_id": outletId}, options: Options(headers: headers));
      // extractedData = Map<dynamic, dynamic>.from(response.data);
      print(response.statusCode);
      return response.statusCode ?? 400;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        ////print(e.response!.data);
        ////print(e.response!.headers);
        ////print(e.response!.requestOptions);
        return e.response!.statusCode ?? 400;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ////print(e.requestOptions);
        ////print(e.message);
        return e.response!.statusCode ?? 400;
      }
    }
  }
}
