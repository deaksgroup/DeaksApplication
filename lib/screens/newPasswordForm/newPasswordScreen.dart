import 'package:deaksapp/screens/newPasswordForm/newPasswordForm.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/socal_card.dart';
import 'package:deaksapp/constants.dart';
import 'package:deaksapp/size_config.dart';

import '../sign_up/components/sign_up_form.dart';

class NewPasswordScreen extends StatelessWidget {
  static String routeName = "/newpasswordscreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Set Password",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 15,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/icons/DeaksLogoBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(.3)),
          ),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.07), // 4%
                      Text("Set New Password", style: headingStyle),
                      Text(
                        "Complete your details.",
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: SizeConfig.screenHeight * 0.08),
                      NewPasswordForm(),

                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
