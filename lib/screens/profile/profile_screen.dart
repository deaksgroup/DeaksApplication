import 'package:flutter/material.dart';
// import 'package:deaksapp/components/coustom_bottom_nav_bar.dart';
import 'package:deaksapp/enums.dart';

import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          )),
      body: Body(),
    );
  }
}
