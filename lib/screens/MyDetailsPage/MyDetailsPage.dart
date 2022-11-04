import '../MyDetailsPage/PageBody.dart';
import 'package:flutter/material.dart';

class MyDetailsPage extends StatelessWidget {
  static String routeName = "/mydetails";
  const MyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Personal Data",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          )),
      body: const SafeArea(child: PageBody()),
    );
  }
}
