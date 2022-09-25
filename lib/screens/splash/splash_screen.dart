import 'package:flutter/material.dart';
import 'package:deaksapp/screens/splash/components/body.dart';
import 'package:deaksapp/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 1,
      )),
    );
  }
}
