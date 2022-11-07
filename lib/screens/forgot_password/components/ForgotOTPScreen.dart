import 'dart:async';

import 'package:deaksapp/screens/forgot_password/components/ForgotOTPForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/Auth.dart';
import '../../../size_config.dart';

class ForgotOTPScreen extends StatefulWidget {
  static String routeName = "/forgototpscreen";
  const ForgotOTPScreen({super.key});

  @override
  State<ForgotOTPScreen> createState() => _ForgotOTPScreenState();
}

class _ForgotOTPScreenState extends State<ForgotOTPScreen> {
  TextEditingController changeContactNumber = TextEditingController();
  bool isEnabeld = false;
  String? newContactNumber = "";

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 45), (() {
      setState(() {
        isEnabeld = true;
      });
    }));
    String fullName = Provider.of<Auth>(context, listen: false).getFullName();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "OTP Verify",
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
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        Text(
                          "OTP Verification",
                          style: headingStyle,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                        Text(
                            "Hello $fullName,We sent an OTP to your registerd Number"),
                        buildTimer(),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        const ForgotOTPForm(),
                        // SizedBox(height: SizeConfig.screenHeight * 0.01),
                        GestureDetector(
                          onTap: () {
                            // OTP code resendi
                            if (isEnabeld) {
                              ////print("resend");
                            }
                          },
                          child: Text(
                            "Resend OTP Code",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: isEnabeld ? Colors.blue : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 45.00, end: 0.00),
          duration: const Duration(seconds: 45),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
