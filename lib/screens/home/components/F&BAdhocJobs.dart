import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/FlushBar/ShowFlushBAr.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
// import 'package:deaksapp/size_config.dart';
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
      // height: 500,
      child: AdHocJobCard(),

      // ListView.builder(
      //   itemBuilder: ((context, index) {
      //     return GestureDetector(
      //       onTap: (() {
      //         Navigator.pushNamed(context, JobDetailsScreen.routeName,
      //             arguments: [
      //               widget.displaySlots[index],
      //               widget.displaySlots,
      //             ]);
      //       }),
      //       child: AdHocJobCard(
      //         displaySlot: widget.displaySlots[index],
      //         displaySlots: widget.displaySlots,
      //       ),
      //     );
      //   }),
      //   itemCount: widget.displaySlots.length,
      // ),
    );
  }
}

class AdHocJobCard extends StatefulWidget {
  // final DisplaySlot displaySlot;
  // final List<DisplaySlot> displaySlots;
  const AdHocJobCard({
    super.key,
  });

  @override
  State<AdHocJobCard> createState() => _AdHocJobCardState();
}

class _AdHocJobCardState extends State<AdHocJobCard> {
  bool isSubscribed = false;
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
              // applyJob(widget.displaySlot.slotId);
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
        boxShadow: [
          new BoxShadow(
            color: Colors.grey.shade400.withOpacity(.3),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        border: Border.all(
          color: Color.fromRGBO(
            255,
            243,
            218,
            1,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 105,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  "${globals.url}/images/guyg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$14 /h",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text(
                      "ExpectedPay : ",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      " \$130",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                  Text(
                    "02:00 PM to 05:00 PM",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "27th Wed December",
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  height: 23,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      "Waiting List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      if (isSubscribed) {
                        isSubscribed = false;
                      } else {
                        isSubscribed = true;
                      }
                    });
                  }),
                  child: Container(
                    child: Icon(
                      Icons.notification_add,
                      color: isSubscribed ? Colors.red : Colors.blueGrey,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Park Royal",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Pickering, Lime Restaurant",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 90,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(1)),
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
                            "Book Now",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
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
