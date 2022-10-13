import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/providers/firebase_dynamic_links.dart';
import 'package:deaksapp/screens/DeleteAccount/DeleteAccount.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';

import 'package:deaksapp/screens/subscriptions/subscriptionsScreen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pagestate/pagestate.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        String? productId = queryParams["id"];
        print(productId);
        print(dynamicLinkData);

        // Navigator.pushNamed(context, dynamicLinkData.link.path,
        //     arguments: {"productId": int.parse(productId!)});
      } else {
        // Navigator.pushNamed(
        //   context,
        //   dynamicLinkData.link.path,
        // );
        print("elese");
        print(dynamicLinkData);
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  File profilePic = new File("");

  Future<void> loadimage() async {
    print("loadimage");
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profilePicPath')) {
      print("image");
      final extractedUserData =
          await jsonDecode(prefs.getString('profilePicPath').toString())
              as Map<dynamic, dynamic>;
      final userProfilePath = Map<dynamic, dynamic>.from(extractedUserData);
      profilePic = await File(userProfilePath["profilePicPath"]);
      setState(() {
        print(userProfilePath["profilePicPath"]);
        // profilePic = await  File(userProfilePath["profilePicPath"]);
      });
    }
  }

  Future<void> openlink(String link) async {
    var androidLink = Uri.parse(link);

    var iosLink = Uri.parse(link);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(iosLink)) {
        await launchUrl(iosLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Sorry! Unable open URL")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(iosLink)) {
        await launchUrl(iosLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Sorry! Unable open URL")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    File profilePic =
        Provider.of<ProfileFetch>(context, listen: false).getProfilePicture();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          GestureDetector(
              onTap: () async {
                String generatedDeepLink =
                    await FirebaseDynamicLinkService.createdynamiclink(
                        false, "67676767");

                log(generatedDeepLink);
              },
              child: Icon(Icons.share)),
          ProfileMenu(
            text: "My Info",
            icon: "assets/icons/User Icon.svg",
            press: () => {Navigator.pushNamed(context, MyDetails.routeName)},
          ),
          ProfileMenu(
            text: "Subscriptions",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                {Navigator.pushNamed(context, Subscriptions.routeName)},
          ),
          ProfileMenu(
            text: "Support",
            icon: "assets/icons/Bell.svg",
            press: () {
              var link = "https://deaks-app-fe.vercel.app/support-channel";
              openlink(link);
            },
          ),
          ProfileMenu(
            text: "Terms and Condtions",
            icon: "assets/icons/Settings.svg",
            press: () {
              var link = "https://deaks-app-fe.vercel.app/terms-condition";
              openlink(link);
            },
          ),
          ProfileMenu(
            text: "Privacy Policy",
            icon: "assets/icons/Question mark.svg",
            press: () {
              var link = "https://deaks-app-fe.vercel.app/privacy-policy";
              openlink(link);
            },
          ),
          ProfileMenu(
            text: "Delete Account",
            icon: "assets/icons/Question mark.svg",
            press: () {
              Navigator.pushNamed(context, DeleteAccount.routeName);
            },
          ),
          SizedBox(
            height: 15,
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PageState()),
                  ModalRoute.withName("/pagestate"));
            },
          ),
        ],
      ),
    );
  }
}
