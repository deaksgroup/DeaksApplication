import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowFlushBar extends StatefulWidget {
  BuildContext context;
  final String message;

  ShowFlushBar({super.key, required this.context, required this.message});

  @override
  State<ShowFlushBar> createState() => _ShowFlushBarState();
}

class _ShowFlushBarState extends State<ShowFlushBar> {
  @override
  Widget build(BuildContext context) {
    //print("flushbarr");
    return Flushbar(
      title: "Hey Ninja",
      message: widget.message,
      duration: Duration(seconds: 3),
    )..show(widget.context);
  }
}
