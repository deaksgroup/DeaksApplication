import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Sign In",
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
