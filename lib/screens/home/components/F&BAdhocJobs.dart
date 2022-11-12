import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Slots.dart';

import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/screens/MyDetailsPage/MyDetailsPage.dart';
// import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/globals.dart' as globals;
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';

import '../../../providers/Auth.dart';
import '../../../providers/Jobs.dart';
import '../../../providers/Profile.dart';
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
    return SizedBox(
        height: 500,
        child: widget.displaySlots.isNotEmpty
            ? ListView.builder(
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, JobDetailsScreen.routeName,
                          arguments: [
                            widget.displaySlots
                                .where((element) => element.priority == "LOW")
                                .toList()[index],
                            widget.displaySlots,
                          ]);
                    }),
                    child: AdHocJobCard(
                      displaySlot: widget.displaySlots
                          .where((element) => element.priority == "LOW")
                          .toList()[index],
                      displaySlots: widget.displaySlots,
                    ),
                  );
                }),
                itemCount: widget.displaySlots
                    .where((element) => element.priority == "LOW")
                    .toList()
                    .length,
              )
            : const Center(
                child: Text("Jobs not available."),
              ));
  }
}

class AdHocJobCard extends StatefulWidget {
  final DisplaySlot displaySlot;
  final List<DisplaySlot> displaySlots;
  const AdHocJobCard({
    super.key,
    required this.displaySlot,
    required this.displaySlots,
  });

  @override
  State<AdHocJobCard> createState() => _AdHocJobCardState();
}

class _AdHocJobCardState extends State<AdHocJobCard> {
  bool isSubscribed = false;
  bool _isLoading = false;
  String status = "Limited";
  Color color = Colors.red;
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
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(5),
            message: value == 200
                ? "Booking Succesfull"
                : "Something went wrong! Please try again.",
            duration: const Duration(seconds: 3),
          )..show(context),
        });
  }

  void askConfirmation() {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (int.parse(widget.displaySlot.vacancy) > 3 &&
        int.parse(widget.displaySlot.vacancy) -
                widget.displaySlot.confirmedRequests.length >
            3) {
      setState(() {
        status = "Open";
        color = Colors.green;
      });
    } else if (int.parse(widget.displaySlot.vacancy) -
            widget.displaySlot.confirmedRequests.length ==
        0) {
      setState(() {
        status = "Waiting List";
        color = Colors.orange;
      });
    } else {
      setState(() {
        status = "Limited";
        color = Colors.red;
      });
    }

    // if (int.parse(widget.displaySlot.vacancy) -
    //         widget.displaySlot.confirmedRequests.length >
    //     3) {
    //   setState(() {
    //     status = "Open";
    //     color = Colors.green;
    //   });
    // }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400.withOpacity(.3),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        border: Border.all(
          color: const Color.fromRGBO(
            255,
            243,
            218,
            1,
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 105,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  "${globals.url}/images/${widget.displaySlot.hotelLogo}",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${widget.displaySlot.payPerHour} /h",
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Row(children: [
                  const Text(
                    "ExpectedPay : ",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    " \$${widget.displaySlot.totalPay}",
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  )
                ]),
                Text(
                  "${widget.displaySlot.startTime} to ${widget.displaySlot.endTime}",
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.displaySlot.date,
                  style: const TextStyle(fontSize: 11, color: Colors.red),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  height: 23,
                  width: 65,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: (() {
                    if (isSubscribed) {
                      Provider.of<Slots>(context, listen: false)
                          .unSubscribeOutlet(widget.displaySlot.outletId)
                          .then((value) => {
                                if (value == 200)
                                  {
                                    setState(() {
                                      isSubscribed = false;
                                    }),
                                  }
                              });
                      isSubscribed = false;
                    } else {
                      Provider.of<Slots>(context, listen: false)
                          .subscribeOutlet(widget.displaySlot.outletId)
                          .then((value) => {
                                if (value == 200)
                                  {
                                    setState(() {
                                      isSubscribed = true;
                                    })
                                  }
                              });
                    }
                  }),
                  child: Icon(
                    Icons.notification_add,
                    color: isSubscribed ? Colors.red : Colors.blueGrey,
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: const BoxDecoration(
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
                      widget.displaySlot.hotelName,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.displaySlot.outletName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 90,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(1)),
                    child: _isLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          )
                        : const Text(
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
                      } else if (profile["accountStatus"] == "UNAUTHORIZED") {
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
