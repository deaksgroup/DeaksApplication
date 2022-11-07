import 'package:deaksapp/screens/newPasswordForm/newPasswordForm.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/constants.dart';
import 'package:deaksapp/size_config.dart';

class NewPasswordScreen extends StatelessWidget {
  static String routeName = "/newpasswordscreen";

  const NewPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Set Password",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 15,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
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
                      const Text(
                        "Complete your details.",
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: SizeConfig.screenHeight * 0.08),
                      const NewPasswordForm(),

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
