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

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController contactNumber = TextEditingController();
TextEditingController accountStatus = TextEditingController();
TextEditingController Sex = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController unitNumber = TextEditingController();
TextEditingController street = TextEditingController();
TextEditingController blockNumber = TextEditingController();
TextEditingController zipCode = TextEditingController();
TextEditingController NRIC = TextEditingController();
TextEditingController PayNow = TextEditingController();
TextEditingController bankAccNo = TextEditingController();
TextEditingController bankName = TextEditingController();
TextEditingController DOB = TextEditingController();
TextEditingController emergencyContact = TextEditingController();
TextEditingController emergencyContactName = TextEditingController();
TextEditingController emergencyContactRelation = TextEditingController();
TextEditingController verificationStatus = TextEditingController();
TextEditingController residentStatus = TextEditingController();
TextEditingController FSInstitute = TextEditingController();
TextEditingController FSIDNumber = TextEditingController();
// TextEditingController residentStatus = TextEditingController();
// TextEditingController residentStatus = TextEditingController();
// TextEditingController residentStatus = TextEditingController();


