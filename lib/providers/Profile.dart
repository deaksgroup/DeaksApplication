import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

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
  File profilePic = File("");
  List<File> attaireImages = [];
  List<String> attaireImagesURLKeys = [];
  final String token;
  String profileURlKey = "";
  Map<String, String> profile;
  List<Map<dynamic, dynamic>> subscriptions = [];
  ProfileFetch({required this.profile, required this.token});

  Map<String, String> get getProfile {
    return profile;
  }

  File getProfilePicture() {
    return profilePic;
  }

  String getProfileUrlKey() {
    return profileURlKey;
  }

  List<String> getAttaireImagesUrlKey() {
    return attaireImagesURLKeys;
  }

  List<File> getAttaireiamges() {
    return attaireImages;
  }

  void setProfilePic(File profilepIc) {
    profilePic = profilepIc;
  }

  void setAttaireIamges(List<File> attaImages) {
    attaireImages = attaImages;
  }

  List<Map<dynamic, dynamic>> get getSubscriptions {
    return subscriptions;
  }

  Future<void> fetchAndSetProfile() async {
    var dio = Dio();
    Response response;

    Map<String, dynamic> headers = {
      "secret_token": token,
    };

    try {
      //404
      response = await dio.get("${globals.url}/getUserInfo",
          options: Options(headers: headers));
      // print(response.data.toString());

      final extractedData = response.data;

      if (response.statusCode != 200) {
        return;
      }
      if (extractedData == null) {
        return;
      }

      // ////print(extractedData["result"]);
      // ////print("Profileftech...");
      Map<dynamic, dynamic> extractedProfile =
          Map<dynamic, dynamic>.from(extractedData);
      //  Map<dynamic, dynamic> e = {"id": 3};
      Map<String, String> convertedProfile = extractedProfile
          .map((key, value) => MapEntry(key.toString(), value.toString()));
      subscriptions =
          List<Map<dynamic, dynamic>>.from(extractedProfile["subscriptions"]);

      profile = convertedProfile;
      profileURlKey = convertedProfile["profilePicture"] ?? "";

      attaireImagesURLKeys =
          List<String>.from(extractedProfile["attirePictures"]!);

      // List<dynamic>.from(convertedProfile["attaireImages"]);
      ////print(convertedProfile);
      // notifyListeners();
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
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
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profilePicPath')) {
      final extractedUserData =
          await jsonDecode(prefs.getString('profilePicPath').toString())
              as Map<dynamic, dynamic>;
      final userProfilePath = Map<dynamic, dynamic>.from(extractedUserData);
      profilePic = File(userProfilePath["profilePicPath"]);
    }

    if (prefs.containsKey('attaireImagesPaths')) {
      // attaireImages = List<File>.from(extractedUserData);
      // attaireImages = File(userProfilePath["profilePicPath"]);
    }
    profilePic = profilePic;
    var dio = Dio();

    Response response;

    FormData formData = FormData.fromMap({
      "data": userData,
      "profile": profilePicture != null && profilePicture.isAbsolute
          ? await MultipartFile.fromFile(
              profilePicture.path,
              filename: profilePicture.path.toString().split("/").last,
              contentType: MediaType('image', 'jpg'),
            )
          : "",
      "attaire": [
        attaireImges.isNotEmpty && attaireImges[0].isAbsolute
            ? MultipartFile.fromFileSync(attaireImges[0].path,
                filename: attaireImges[0].path.toString().split("/").last,
                contentType: MediaType('image', 'jpg'))
            : "",
        attaireImges.isNotEmpty && attaireImges[1].isAbsolute
            ? MultipartFile.fromFileSync(attaireImges[1].path,
                filename: attaireImges[1].path.toString().split("/").last,
                contentType: MediaType('image', 'jpg'))
            : "",
      ],
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
      response = await dio.patch("${globals.url}/updateUserInfoApp",
          data: formData, options: Options(headers: headers));
      // ////print(response.data.toString());
      final extractedData = response.data;
      if (extractedData == null) {
        return extractedData;
      }
      Map<dynamic, dynamic> extractedProfile =
          Map<dynamic, dynamic>.from(extractedData);

      Map<String, String> convertedProfile = extractedProfile
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

  // Future<void> cancelSubscription(String outletId) async {
  //   var dio = Dio();
  //   Response response;

  //   Map<String, dynamic> headers = {
  //     "secret_token": token,
  //   };
  //   try {
  //     response = await dio.patch("${globals.url}/profile",
  //         options: Options(headers: headers));
  //   } on DioError catch (e) {}
  // }

  // Future<void> subscribe(String outletId) async {
  //   var dio = Dio();
  //   Response response;

  //   Map<String, dynamic> headers = {
  //     "secret_token": token,
  //   };

  //   try {
  //     response = await dio.patch("${globals.url}/profile",
  //         options: Options(headers: headers));
  //   } on DioError catch (e) {}
  // }
}
