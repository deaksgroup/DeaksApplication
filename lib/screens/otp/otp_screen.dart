import 'package:deaksapp/providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/size_config.dart';
import 'package:provider/provider.dart';

import '../pagestate/pagestate.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        actions: [
          TextButton(
              onPressed: (() {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const PageState()),
                    ModalRoute.withName("/pagestate"));
              }),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.blue),
              ))
        ],
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
