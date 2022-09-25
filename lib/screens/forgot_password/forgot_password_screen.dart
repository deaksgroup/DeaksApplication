import 'package:flutter/material.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Forgot Password",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          )),
      body: Stack(children: [
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
        Body()
      ]),
    );
  }
}
