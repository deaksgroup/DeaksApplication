import 'package:flutter/material.dart';
import 'package:deaksapp/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 1,
      )),
    );
  }
}
