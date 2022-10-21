import 'package:deaksapp/providers/Slot.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';
import 'package:deaksapp/screens/sign_in/sign_in_screen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/Profile.dart';
import 'Body.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class shreJobDetailsScreen extends StatefulWidget {
  static String routeName = "/shareJobScreen";
  const shreJobDetailsScreen({super.key});

  @override
  State<shreJobDetailsScreen> createState() => _shreJobDetailsScreenState();
}

class _shreJobDetailsScreenState extends State<shreJobDetailsScreen> {
  bool _isInIt = true;
  DisplaySlot? displaySlot;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    Slot? slot = Provider.of<Slots>(context, listen: false).getShareSlot;

    if (slot != null) {
      displaySlot = DisplaySlot(
          slotId: slot.id,
          jobRemarks2: slot.jobRemarks,
          jobRemarks1: slot.outlet["jobRemarks"],
          outletId: slot.outlet["id"],
          outletName: slot.outlet["outletName"],
          outletImages: slot.outlet["outletImages"] ?? [],
          paymentDetails: slot.outlet["payment"] ?? [],
          groomingImages: slot.outlet["groomingImages"] ?? [],
          howToImages: slot.outlet["howToImages"] ?? [],
          adminNumber: slot.outlet["outletAdminNo"] ?? "",
          youtubeLink: slot.outlet["youtubeLink"] ?? "",
          hotelId: slot.hotel["id"] ?? "",
          hotelName: slot.hotel["hotelName"] ?? "",
          hotelLogo: slot.hotel["hotelLogo"] ?? "",
          googleMapLink: slot.hotel["googleMapLink"] ?? "",
          appleMapLink: slot.hotel["appleMapLink"] ?? "",
          date: slot.date,
          startTime: slot.startTime,
          endTime: slot.endTime,
          payPerHour: slot.hourlyPay,
          totalPay: slot.totalPayForSlot,
          priority: slot.priority,
          confirmedRequests: slot.confirmedRequests,
          waitingListRequests: slot.waitingRequests,
          release: slot.release,
          vacancy: slot.vacancy);
    }
    _isInIt = false;

    super.didChangeDependencies();
  }

  bool _isLading = false;
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
              Navigator.pushNamed(context, MyDetails.routeName);
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
        title: Text("Confirm your booking"),
        content: Text("Please confirm again for applying for this job"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Confirm"),
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
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(5),
              message: value == 200
                  ? "Booking Succesfull"
                  : "Something went wrong! Please try again.",
              duration: Duration(seconds: 3),
            )..show(context),
            setState(() {
              _isLading = false;
            })
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: displaySlot != null
            ? Body(
                displaySlot: displaySlot,
              )
            : Container(
                child: Center(
                  child: Container(
                      width: double.infinity,
                      child: Column(children: [
                        Spacer(),
                        Text("Sorry! This job is currently Unavailbale."),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Back to Home Page")),
                        Spacer()
                      ])),
                ),
              ),
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.shade400.withOpacity(.3),
                blurRadius: 30.0,
              ),
            ],
          ),
          child: Container(
            width: 100,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Map<String, String> profile =
                      Provider.of<ProfileFetch>(context, listen: false)
                          .getProfile;
                  if (!Provider.of<Auth>(context, listen: false).isAuth) {
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  } else if (profile["accountStatus"] == "Unauthorized") {
                    showAlert();
                  } else {
                    askConfirmation(displaySlot!.slotId);
                  }
                },
                child: _isLading
                    ? Center(
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    : Text(displaySlot == null ? " Unavailble" : "Book Now")),
          ),
        ),
      ),
    );
  }
}
