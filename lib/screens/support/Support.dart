import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  static String routeName = "/supportchannel";
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  Future<void> openlink() async {
    var link = "https://deaks-app-fe.vercel.app/support-channel";
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
              "Support",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
              ),
            )),
        body: Center(
          child: TextButton(
            child: Text("Open Support Channel."),
            onPressed: () {
              openlink();
            },
          ),
        ));
  }
}
