import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:deaksapp/globals.dart' as globals;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  final String name;
  final String email;

  final String contactNumber;

  final String subscriptions;
  final String joinDate;
  final String profilePicture;
  final String accountStatus;
  final String bookingName;
  final String numberIsVerified;
  final String Sex;
  final String city;
  final String unitNumber;
  final String floorNumber;
  final String street;
  final String zipCode;
  final String NRIC;
  final String PayNow;
  final String bankAccNo;
  final String bankName;
  final String DOB;
  final String emergencyContact;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String jobStatus;
  final String deaksStaffID;
  final String verificationStatus;
  final String residentStatus;
  final String FSInstitute;
  final String FSIDNumber;

  Profile(
      {required this.name,
      required this.email,
      required this.contactNumber,
      required this.subscriptions,
      required this.joinDate,
      required this.profilePicture,
      required this.accountStatus,
      required this.bookingName,
      required this.numberIsVerified,
      required this.Sex,
      required this.city,
      required this.unitNumber,
      required this.floorNumber,
      required this.street,
      required this.zipCode,
      required this.NRIC,
      required this.PayNow,
      required this.bankAccNo,
      required this.bankName,
      required this.DOB,
      required this.emergencyContact,
      required this.emergencyContactName,
      required this.emergencyContactRelation,
      required this.jobStatus,
      required this.deaksStaffID,
      required this.verificationStatus,
      required this.residentStatus,
      required this.FSInstitute,
      required this.FSIDNumber});
}

class ProfileFetch with ChangeNotifier {
  File profilePic = new File("");
  final String token;
  Map<String, String> profile;
  ProfileFetch({required this.profile, required this.token});

  Map<String, String> get getProfile {
    return profile;
  }

  File getProfilePicture() {
    return profilePic;
  }

  Future<void> fetchAndSetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('profilePicPath')) {
      final extractedUserData =
          await jsonDecode(prefs.getString('profilePicPath').toString())
              as Map<dynamic, dynamic>;
      final userProfilePath = Map<dynamic, dynamic>.from(extractedUserData);
      profilePic = new File(userProfilePath["profilePicPath"]);
      notifyListeners();
    }

    log("profielfetch");
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;

    Map<String, dynamic> headers = {
      "secret_token": token,
    };

    try {
      //404
      response = await dio.get("${globals.url}/profile",
          options: Options(headers: headers));
      // print(response.data.toString());

      final extractedData = response.data;
      if (extractedData == null) {
        return;
      }
      // ////print(extractedData);
      // ////print(extractedData["result"]);
      // ////print("Profileftech...");
      Map<dynamic, dynamic> extractedProfile =
          Map<dynamic, dynamic>.from(extractedData);
      // ////print(extractedProfile);
      //  Map<dynamic, dynamic> e = {"id": 3};
      Map<String, String> convertedProfile = extractedProfile
          .map((key, value) => MapEntry(key.toString(), value.toString()));
      profile = convertedProfile;
      ////print(convertedProfile);
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

  Future<Map<dynamic, dynamic>> submitProfile(Map<String, dynamic>? userData,
      File? profilePicture, List<File> attaireImges) async {
    profilePic = profilePic;
    var dio = Dio();

    Response response;
    Map<String, String> convertedUserData = userData!
        .map((key, value) => MapEntry(key.toString(), value.toString()));
    FormData formData = FormData.fromMap({
      "data": convertedUserData,
      "profile": await MultipartFile.fromFile(
        // profilePicture?.path != null ? profilePicture!.path : "",
        // filename: profilePicture?.path.toString().split("/").last,
        attaireImges[0].path,
        filename: attaireImges[0].path.toString().split("/").last,
        contentType: MediaType('image', 'jpg'),
      ),
      "attaire": await MultipartFile.fromFile(
        attaireImges[0].path,
        filename: attaireImges[0].path.toString().split("/").last,
        contentType: MediaType('image', 'jpg'),
      ),
      "attaire": await MultipartFile.fromFile(
        attaireImges[1].path,
        filename: attaireImges[1].path.toString().split("/").last,
        contentType: MediaType('image', 'jpg'),
      ),
      "type": "image/jpg"
    });

    Map<dynamic, dynamic> extractedData = {};

    Map<String, dynamic> headers = {
      "secret_token": token,
      "Content-Type": "multipart/form-data"
    };

    // Map<String, String> convertedUserData = userData!
    //     .map((key, value) => MapEntry(key.toString(), value.toString()));

    try {
      //404
      response = await dio.patch("http://localhost:5001/api/updateUserInfo",
          data: formData, options: Options(headers: headers));
      // ////print(response.data.toString());
      print("here");
      final extractedData = response.data;
      if (extractedData == null || extractedData["result"] == null) {
        return extractedData;
      }
      print("not reaching");
      // ////print(extractedData);
      // ////print(extractedData["result"]);
      ////print("ProfileftechFterAubmission...");
      Map<dynamic, dynamic> extractedProfile =
          Map<dynamic, dynamic>.from(extractedData);
      ////print(extractedData);
      Map<dynamic, dynamic> extractedProfileDetails =
          Map<dynamic, dynamic>.from(extractedProfile["result"]);
      // ////print(extractedData);
      ////print("Hello");
      // ////print(extractedProfile["result"]);
      ////print("Hello");
      //  Map<dynamic, dynamic> e = {"id": 3};
      Map<String, String> convertedProfile = extractedProfileDetails
          .map((key, value) => MapEntry(key.toString(), value.toString()));
      profile = convertedProfile;
      notifyListeners();
      return extractedData;
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

  Future<void> subscribe(String outletId) async {
    Map<dynamic, dynamic> extractedData = {};
    var dio = Dio();
    Response response;

    Map<String, dynamic> headers = {
      "secret_token": token,
    };

    try {
      response = await dio.patch("${globals.url}/profile",
          options: Options(headers: headers));
    } on DioError catch (e) {}
  }
}
