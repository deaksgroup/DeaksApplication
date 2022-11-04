import 'package:deaksapp/providers/Slot.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

class Jobs with ChangeNotifier {
  final String token;
  List<Slot> _jobs = [];
  Jobs({required this.token});

  List<Slot> get getJobs {
    return _jobs;
  }

  Future<int> applyJob(String slotId) async {
    try {
      Map<dynamic, dynamic> extractedData = {};
      var dio = Dio();
      Response response;

      Map<String, dynamic> headers = {
        "secret_token": token,
      };
      response = await dio.patch("${globals.url}/ApplyJob",
          data: {"slot_id": slotId}, options: Options(headers: headers));
      // extractedData = Map<dynamic, dynamic>.from(response.data);
      int? status = response.statusCode ?? 0;

      return status;
    } catch (error) {
      return 400;
    }
    ////print("applyjib");
  }

  Future<int> cancelJob(String slotId) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      response = await dio.patch("${globals.url}/cancelJob",
          data: {"slot_id": slotId}, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return response.statusCode ?? 200;
      } else {
        return response.statusCode ?? 400;
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        return e.response!.statusCode ?? 400;
        ////print(e.response!.data);
        ////print(e.response!.headers);
        ////print(e.response!.requestOptions);
      } else {
        return 400;
        // Something happened in setting up or sending the request that triggered an Error
        ////print(e.requestOptions);
        ////print(e.message);
      }
    }
  }

  Future<void> fetchAndSetJobs() async {
    print("fetchAndSetJObs");
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      //404
      response = await dio.get("${globals.url}/jobListing",
          options: Options(headers: headers));
      // ////print(response.data.toString());

      final extractedData = response.data;
      if (extractedData == null || response.statusCode != 200) {
        return;
      }
      // ////print(extractedData);
      // ////print(extractedData["result"]);

      ////print("1111");
      List<Map<dynamic, dynamic>> extractedSlots =
          List<Map<dynamic, dynamic>>.from(extractedData);

      ////print("2222");
      // ////print(extractedSlots[2]);

      List<Slot> loadedJobs = [];
      for (var job in extractedSlots) {
        {
          loadedJobs.add(Slot(
            date: job["date"] ?? "",
            id: job["id"] ?? "",
            endTime: job["endTime"] ?? "",
            hotel: job["hotelDetails"] ?? {},
            outlet: job["outletDetails"] ?? {},
            hourlyPay: job["hourlyPay"] ?? "",
            priority: job["priority"] ?? "",
            startTime: job["startTime"] ?? "",
            totalPayForSlot: job["totalPayForSlot"] ?? "",
            release: job["release"].toString(),
            jobRemarks: job["jobRemarks"] ?? "",
            vacancy: job["vacancy"].toString(),
            confirmedRequests: job["confirmedRequests"] ?? [],
            waitingRequests: job["waitingRequests"] ?? [],
          ));
        }
        ;
      }
      // ////print(loadedSlots);

      _jobs = loadedJobs;
      notifyListeners();
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
  }
}
