import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:deaksapp/screens/MyDetailsPage/MyDetailsPage.dart';
import 'package:deaksapp/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/Profile.dart';
import 'Body.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class JobDetailsScreen extends StatefulWidget {
  static String routeName = "/jobDetailsScreen";

  const JobDetailsScreen({
    super.key,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isLading = false;
  void showAlert() {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Not Verified!"),
        content: const Text(
            "Your Account needs to be verified before applying a job.Please sumbit your details for verification."),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Skip"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: const Text("Update"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MyDetailsPage.routeName);
            },
          ),
        ],
      ),
    );
  }

  void askConfirmation(String slotId) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Confirm your booking"),
        content: const Text("Please confirm again for applying for this job"),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);
              applyJob(slotId);
            },
          ),
        ],
      ),
    );
  }

  Future<void> applyJob(String slotId) async {
    setState(() {
      _isLading = true;
    });
    //print(slotId);
    Provider.of<Jobs>(context, listen: false).applyJob(slotId).then(
          (value) => {
            //print("Hello"),
            //print(value),
            Flushbar(
              margin: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(5),
              message: value == 200
                  ? "Booking Succesfull"
                  : "Something went wrong! Please try again.",
              duration: const Duration(seconds: 3),
            )..show(context),
            setState(() {
              _isLading = false;
            })
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    List<DisplaySlot> displaySlots = args[1] as List<DisplaySlot>;
    DisplaySlot displaySlot = args[0] as DisplaySlot;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Body(
          displaySlot: displaySlot,
          displaySlots: displaySlots,
        ),
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(.3),
                blurRadius: 30.0,
              ),
            ],
          ),
          child: Container(
            width: 100,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Map<String, String> profile =
                      Provider.of<ProfileFetch>(context, listen: false)
                          .getProfile;
                  if (!Provider.of<Auth>(context, listen: false).isAuth) {
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  } else if (profile["accountStatus"] == "UNAUTHORIZED") {
                    showAlert();
                  } else {
                    askConfirmation(displaySlot.slotId);
                  }
                },
                child: _isLading
                    ? const Center(
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    : const Text("Book Now")),
          ),
        ),
      ),
    );
  }
}
