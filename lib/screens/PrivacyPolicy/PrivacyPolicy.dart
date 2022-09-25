import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  static String routeName = "/privacypolicy";
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Future<void> openlink() async {
    var link = "https://deaks-app-fe.vercel.app/privacy-policy";
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
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
              ),
            )),
        body: Center(
          child: TextButton(
            child: Text("Open PrivacyPolicy."),
            onPressed: () {
              openlink();
            },
          ),
        ));
  }
}
