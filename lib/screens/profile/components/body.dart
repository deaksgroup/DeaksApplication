import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/screens/DeleteAccount/DeleteAccount.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';
import 'package:deaksapp/screens/PrivacyPolicy/PrivacyPolicy.dart';
import 'package:deaksapp/screens/TermsAndCondtion/TermsAndCondtions.dart';
import 'package:deaksapp/screens/support/Support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pagestate/pagestate.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfileMenu(
            text: "My Info",
            icon: "assets/icons/User Icon.svg",
            press: () => {Navigator.pushNamed(context, MyDetails.routeName)},
          ),
          ProfileMenu(
            text: "Support",
            icon: "assets/icons/Bell.svg",
            press: () {
              Navigator.pushNamed(context, Support.routeName);
            },
          ),
          ProfileMenu(
            text: "Terms and Condtions",
            icon: "assets/icons/Settings.svg",
            press: () {
              Navigator.pushNamed(context, TermsAndCondition.routeName);
            },
          ),
          ProfileMenu(
            text: "Privacy Policy",
            icon: "assets/icons/Question mark.svg",
            press: () {
              Navigator.pushNamed(context, PrivacyPolicy.routeName);
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
