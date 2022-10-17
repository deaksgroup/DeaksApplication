import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Notification.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotoficationPage extends StatefulWidget {
  static String routeName = "/notoficationpage";
  const NotoficationPage({super.key});

  @override
  State<NotoficationPage> createState() => _NotoficationPageState();
}

class _NotoficationPageState extends State<NotoficationPage> {
  List<Map<dynamic, dynamic>> notifications = [];

  Future<void> loadLocalNotitifications() async {
    Provider.of<NotificationFetch>(context, listen: false)
        .loadLocalNotitifications()
        .then((value) => {
              print("here"),
              setState(() {
                notifications = [];
                notifications = value;
              }),
              print(value.toString()),
              print(notifications),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () {
                    loadLocalNotitifications();
                  },
                  child: Text("load"))
            ],
            centerTitle: true,
            title: Text(
              "Notofications",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
              ),
            )),
        body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: ((context, index) {
              return NotoficationCard(
                notification: notifications[index],
              );
            })));
  }
}

class NotoficationCard extends StatefulWidget {
  final Map<dynamic, dynamic> notification;
  const NotoficationCard({
    super.key,
    required this.notification,
  });

  @override
  State<NotoficationCard> createState() => _NotoficationCardState();
}

class _NotoficationCardState extends State<NotoficationCard> {
  void showAlert() {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text("Not Verified!"),
        content: Text(
            "Your Account needs to be verified before applying a job.Please sumbit your details for verification."),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Skip"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Update"),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, MyDetails.routeName);
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendNotificationResponse(String response) async {
    Map<String, String> responseData = {
      "tokenNumber": widget.notification["notificationNumer"].toString(),
      "slotId": widget.notification["slotId"].toString(),
      "response": response.toString(),
    };
    Provider.of<NotificationFetch>(context, listen: false)
        .sendNotificationResponse(responseData)
        .then((value) => {
              Flushbar(
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(5),
                message: value["message"],
                duration: Duration(seconds: 3),
              )..show(context),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(
              255,
              243,
              218,
              1,
            ),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.shade400.withOpacity(.3),
              blurRadius: 5.0,
            ),
          ]),
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      height: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.notification["title"]),
          SizedBox(
            height: 10,
          ),
          Text(widget.notification["body"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  sendNotificationResponse(widget.notification["action1"]);
                },
                child: Text(widget.notification["action1"]),
              ),
              TextButton(
                  onPressed: () {
                    sendNotificationResponse(widget.notification["action2"]);
                  },
                  child: Text(widget.notification["action2"]))
            ],
          ),
        ],
      ),
    );
  }
}
