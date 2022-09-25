import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Body.dart';

class MyDetails extends StatefulWidget {
  static String routeName = "/mydetails";
  const MyDetails({
    super.key,
  });

  @override
  State<MyDetails> createState() => _MyDetailsState();
}

bool isEditable = false;
String ButtonText = "Edit";

class _MyDetailsState extends State<MyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  if (!isEditable) {
                    setState(() {
                      isEditable = true;
                      ButtonText = "Cancel";
                    });
                  } else {
                    setState(() {
                      isEditable = false;
                      ButtonText = "Edit";
                    });
                  }
                },
                child: Text(ButtonText))
          ],
          centerTitle: true,
          title: Text(
            "My Info",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          )),
      body: Body(
        press: () {
          setState(() {});
        },
        isEditable: isEditable,
      ),
    );
  }
}
