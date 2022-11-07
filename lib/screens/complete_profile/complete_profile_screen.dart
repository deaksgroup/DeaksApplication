import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const CompleteProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(children: [
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
        const Body()
      ]),
    );
  }
}
