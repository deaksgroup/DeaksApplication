import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> openlink(BuildContext context, String link) async {
  var androidLink = Uri.parse(link);

  var iosLink = Uri.parse(link);
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    // for iOS phone only
    if (await canLaunchUrl(iosLink)) {
      await launchUrl(iosLink, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry! Unable open URL")));
    }
  } else {
    // android , web
    if (await canLaunchUrl(androidLink)) {
      await launchUrl(iosLink, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry! Unable open URL")));
    }
  }
}
