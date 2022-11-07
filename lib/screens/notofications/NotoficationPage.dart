import 'package:deaksapp/providers/Notification.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

class NotoficationPage extends StatefulWidget {
  static String routeName = "/notoficationpage";

  final Map<dynamic, dynamic> payload;

  NotoficationPage({super.key, required this.payload});

  @override
  State<NotoficationPage> createState() => _NotoficationPageState();
}

class _NotoficationPageState extends State<NotoficationPage> {
  bool _isInIt = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInIt) {}
    _isInIt = false;
    super.didChangeDependencies();
  }

  void askConfirmation(Map<dynamic, dynamic> notify) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text(notify["title"]),
        content: Text(notify["body"]),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(notify["action1"]),
            onPressed: () {
              Navigator.of(context).pop();
              Map<String, String> responseData = {
                "tokenNumber": notify["tokenNumber"],
                "slotId": notify["slotId"],
                "response": notify["action1"],
              };
              sendNotificationResponse(responseData);
            },
          ),
          BasicDialogAction(
            title: Text(notify["action2"]),
            onPressed: () {
              Navigator.of(context).pop();
              Map<String, String> responseData = {
                "tokenNumber": notify["tokenNumber"],
                "slotId": notify["slotId"],
                "response": notify["action2"],
              };
              sendNotificationResponse(responseData);
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendNotificationResponse(
      Map<String, String> responseData) async {
    Provider.of<NotificationFetch>(context, listen: false)
        .sendNotificationResponse(responseData)
        .then((value) => {
              // Flushbar(
              //   margin: EdgeInsets.all(8),
              //   borderRadius: BorderRadius.circular(5),
              //   message: value["message"],
              //   duration: Duration(seconds: 3),
              // )..show(context),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Notofications",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
              ),
            )),
        body: widget.payload["title"] != null
            ? BasicDialogAlert(
                title: Text(widget.payload["title"]),
                content: Text(widget.payload["body"]),
                actions: <Widget>[
                  BasicDialogAction(
                    title: Text(widget.payload["action1"]),
                    onPressed: () {
                      Navigator.of(context)
                          .popAndPushNamed(PageState.routeName);
                      Map<String, String> responseData = {
                        "tokenNumber": widget.payload["tokenNumber"],
                        "slotId": widget.payload["slotId"],
                        "response": widget.payload["action1"],
                      };
                      sendNotificationResponse(responseData);
                    },
                  ),
                  BasicDialogAction(
                    title: Text(widget.payload["action2"]),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => true);
                      Map<String, String> responseData = {
                        "tokenNumber": widget.payload["tokenNumber"],
                        "slotId": widget.payload["slotId"],
                        "response": widget.payload["action2"],
                      };
                      sendNotificationResponse(responseData);
                    },
                  ),
                ],
              )
            : const Center(
                child: Text("You dont have any new notifications!"),
              ));
  }
}
