import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

import 'Hotel.dart';

class Hotels with ChangeNotifier {
  List<Hotel> hotels = [];

  List<Hotel> get getHotels {
    return hotels;
  }

  Hotel getHotelDetails(hotelId) {
    return hotels.firstWhere((hotel) {
      ////////print(hotel.id);
      ////////print(hotelId);
      return hotel.id == hotelId;
    });
  }

  Future<void> fetchAndSetHotels() async {
    var dio = Dio();
    Response response;

    try {
      //404
      response = await dio.get("${globals.url}/hotelList");
      // ////////print(response.data.toString());

      final data = json.decode(response.data);
      if (data == null) {
        return;
      }
      List<Map<dynamic, dynamic>> extractedData =
          List<Map<dynamic, dynamic>>.from(data);
      ////////print("hello22");

      List<Hotel> loadedHotels = [];

      for (var hotel in extractedData) {
        ////////print("1111111");
        loadedHotels.add(Hotel(
          id: hotel["_id"] ?? "",
          hotelName: hotel["hotelName"] ?? "",
          logo: hotel["hotelEmblem"] ?? "",
          googleMapLink: hotel["googleMapLink"] ?? "",
          appleMapLink: hotel["appleMapLink"] ?? "",
        ));
      }
      ////////print(loadedHotels);
      hotels = loadedHotels;
      notifyListeners();
      // ////////print(extractedData);
      // ////////print(extractedData["result"]);

    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        ////////print(e.response!.data);
        ////////print(e.response!.headers);
        ////////print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ////////print(e.requestOptions);
        ////////print(e.message);
      }
    }
  }
}
