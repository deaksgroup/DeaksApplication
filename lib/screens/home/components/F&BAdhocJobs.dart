import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/FlushBar/ShowFlushBAr.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:deaksapp/globals.dart' as globals;
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

import '../../../providers/Auth.dart';
import '../../../providers/Jobs.dart';
import '../../../providers/Profile.dart';
import '../../MyDetails/MyDetails.dart';
import '../../sign_in/sign_in_screen.dart';

class AdHocJobs extends StatefulWidget {
  final List<DisplaySlot> displaySlots;
  const AdHocJobs({super.key, required this.displaySlots});

  @override
  State<AdHocJobs> createState() => _AdHocJobsState();
}

class _AdHocJobsState extends State<AdHocJobs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenWidth(500),
      child: ListView.builder(
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, JobDetailsScreen.routeName,
                  arguments: [
                    widget.displaySlots[index],
                    widget.displaySlots,
                  ]);
            }),
            child: AdHocJobCard(
              displaySlot: widget.displaySlots[index],
              displaySlots: widget.displaySlots,
            ),
          );
        }),
        itemCount: widget.displaySlots.length,
      ),
    );
  }
}

class AdHocJobCard extends StatefulWidget {
  final DisplaySlot displaySlot;
  final List<DisplaySlot> displaySlots;
  const AdHocJobCard(
      {super.key, required this.displaySlot, required this.displaySlots});

  @override
  State<AdHocJobCard> createState() => _AdHocJobCardState();
}

class _AdHocJobCardState extends State<AdHocJobCard> {
  bool _isLoading = false;
  Future<void> applyJob(String slotId) async {
    setState(() {
      _isLoading = true;
    });
    //print(slotId);
    Provider.of<Jobs>(context, listen: false).applyJob(slotId).then((value) => {
          //print(value),
          setState(() {
            _isLoading = false;
          }),
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(5),
            message: value["message"],
            duration: Duration(seconds: 3),
          )..show(context),
        });
  }

  void askConfirmation() {
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
              applyJob(widget.displaySlot.slotId);
            },
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromRGBO(
            255,
            243,
            218,
            1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(0),
      ),
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 120,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  "${globals.url}/images/${widget.displaySlot.hotelLogo}",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${widget.displaySlot.payPerHour} /h",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text(
                      "ExpectedPay | ",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${widget.displaySlot.totalPay}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                  Text(
                    "${widget.displaySlot.startTime} to ${widget.displaySlot.endTime}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.displaySlot.date}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Color.fromRGBO(
                  255,
                  243,
                  218,
                  1,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.displaySlot.hotelName}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.displaySlot.outletName}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                ),
                Container(
                  width: 100,
                  height: 30,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: _isLoading
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          )
                        : Text(
                            "${widget.displaySlot.slotStatus}",
                            style: TextStyle(fontSize: 12),
                          ),
                    onPressed: () {
                      Map<String, String> profile =
                          Provider.of<ProfileFetch>(context, listen: false)
                              .getProfile;
                      if (!Provider.of<Auth>(context, listen: false).isAuth) {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      } else if (profile["accountStatus"] == "Unauthorized") {
                        showAlert();
                      } else {
                        askConfirmation();
                      }
                    },
                  ),
                )
              ],
            ))
      ]),
    );
  }
}
