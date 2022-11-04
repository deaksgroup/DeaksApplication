import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Body.dart';

class MyDetails extends StatefulWidget {
  static String routeName = "/mydetailsss";
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(.1),
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
                child: Text(
                  ButtonText,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ))
          ],
          centerTitle: true,
          title: Text(
            "Personal Data",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          )),
      body: SafeArea(
        child: Body(
          isEditable: isEditable,
        ),
      ),
    );
  }
}
