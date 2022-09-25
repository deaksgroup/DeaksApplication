import 'dart:convert';
import 'dart:developer';

import 'package:deaksapp/providers/Slot.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

class Slots with ChangeNotifier {
  List<Slot> slots = [];

  List<Slot> get getSlots {
    return slots;
  }

  Future<void> fetchAndSetSlots() async {
    ////print("slotsFetch");
    var dio = Dio();
    Response response;

    try {
      //404
      response = await dio.get("${globals.url}/slotList");
      // //////////print(response.data.toString());

      final extractedData = response.data;
      if (extractedData == null && extractedData["result"] == null) {
        return;
      }
      // //////////print(extractedData);
      // //////////print(extractedData["result"]);

      List<Map<dynamic, dynamic>> extractedSlots =
          List<Map<dynamic, dynamic>>.from(extractedData["result"]);

      // //////////print(extractedSlots[2]);

      List<Slot> loadedSlots = [];
      for (var slot in extractedSlots) {
        {
          loadedSlots.add(Slot(
            date: slot["date"] ?? "",
            id: slot["_id"] ?? "",
            endTime: slot["endTime"] ?? "",
            hotelId: slot["hotelDetails"] ?? "",
            hotelName: slot["hotelName"] ?? "",
            outletId: slot["outletDetails"] ?? "",
            outletName: slot["outletName"] ?? "",
            payPerHour: slot["payPerHour"] ?? "",
            priority: slot["priority"] ?? "",
            startTime: slot["startTime"] ?? "",
            totalPay: slot["totalPayForSlot"] ?? "",
            slotStatus: slot["status"] ?? "",
          ));
        }
        ;
      }
      //////////print(loadedSlots);

      slots = loadedSlots;

      notifyListeners();
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
  }
}
