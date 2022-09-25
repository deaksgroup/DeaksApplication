import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
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
