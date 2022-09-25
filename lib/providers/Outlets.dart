import 'dart:convert';

import 'package:deaksapp/providers/Outlet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

class Outlets with ChangeNotifier {
  List<Outlet> outlets = [];

  List<Outlet> get getOutlets {
    return outlets;
  }

  Outlet getOutletDetails(outletId) {
    return outlets.firstWhere((olt) => olt.id == outletId);
  }

  Future<void> fetchAndSetOulets() async {
    var dio = Dio();
    Response response;

    try {
      //404
      response = await dio.get("${globals.url}/outletList");
      // //////print(response.data.toString());

      final data = json.decode(response.data);
      if (data == null) {
        return;
      }
      List<Map<dynamic, dynamic>> extractedData =
          List<Map<dynamic, dynamic>>.from(data);
      //////print("hello22");

      List<Outlet> loadedOutlets = [];

      for (var outlet in extractedData) {
        //////print("1111111");
        loadedOutlets.add(Outlet(
            outletName: outlet["outletName"] ?? "",
            id: outlet["_id"] ?? "",
            hotelName: outlet["hotelName"] ?? "",
            hotelId: outlet["hoteldetails"] ?? "",
            outletImages: outlet["outletImages"] ?? [],
            groomingImages: outlet["groomingImages"] ?? [],
            howToImages: outlet["howToImages"] ?? [],
            jobRemarks: outlet["jobRemarks"] ?? "",
            adminNumber: outlet["outletAdminNo"] ?? "",
            youtubeLink: outlet["youtubeLink"] ?? "",
            paymentDescription: outlet["payment"] ?? ""));
      }
      outlets = loadedOutlets;
      notifyListeners();
      // //////print(extractedData);
      // //////print(extractedData["result"]);

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
  }
}
