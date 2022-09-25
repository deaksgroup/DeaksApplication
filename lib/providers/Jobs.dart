import 'package:deaksapp/providers/Job.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;

class Jobs with ChangeNotifier {
  final String token;
  List<Job> _jobs = [];
  Jobs({required this.token});

  List<Job> get getJobs {
    return _jobs;
  }

  Future<Map<dynamic, dynamic>> applyJob(String slotId) async {
    ////print("applyjib");
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;

    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    response = await dio.post("${globals.url}/applyjob",
        data: {"slotId": slotId}, options: Options(headers: headers));
    extractedData = Map<dynamic, dynamic>.from(response.data);

    return extractedData;
  }

  Future<void> fetchAndSetJobs() async {
    var dio = Dio();
    Response response;
    Map<String, dynamic> headers = {
      "secret_token": token,
    };
    try {
      //404
      response = await dio.get("${globals.url}/jobList",
          options: Options(headers: headers));
      // ////print(response.data.toString());

      final extractedData = response.data;
      if (extractedData == null && extractedData["result"] == null ||
          extractedData["errorCode"] == 1) {
        return;
      }
      // ////print(extractedData);
      // ////print(extractedData["result"]);

      ////print("1111");
      List<Map<dynamic, dynamic>> extractedSlots =
          List<Map<dynamic, dynamic>>.from(extractedData?["result"]);

      ////print("2222");
      // ////print(extractedSlots[2]);

      List<Job> loadedJobs = [];
      for (var job in extractedSlots) {
        {
          loadedJobs.add(Job(
            date: job["date"] ?? "",
            id: job["_id"] ?? "",
            endTime: job["endTime"] ?? "",
            hotelId: job["hotelDetails"] ?? "",
            hotelName: job["hotelName"] ?? "",
            outletId: job["outletDetails"] ?? "",
            outletName: job["outletName"] ?? "",
            payPerHour: job["payPerHour"] ?? "",
            priority: job["priority"] ?? "",
            startTime: job["startTime"] ?? "",
            totalPay: job["totalPayForSlot"] ?? "",
            slotStatus: job["status"] ?? "",
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
