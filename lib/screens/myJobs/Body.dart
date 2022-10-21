import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:deaksapp/globals.dart' as globals;
import 'package:provider/provider.dart';
import '../../size_config.dart';

class Body extends StatelessWidget {
  final List<DisplaySlot> jobsDispaySlots;

  const Body({super.key, required this.jobsDispaySlots});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: jobsDispaySlots.isEmpty
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: getProportionateScreenHeight(400),
                      child: Center(
                        child: Text("No Upcoming jobs."),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: jobsDispaySlots.length,
                    itemBuilder: ((context, index) {
                      return JobCard(displaySlot: jobsDispaySlots[index]);
                    }))),
        Center(
            child: Text(
          "Swipe down to refresh!",
          style: TextStyle(
              color: Colors.grey.withOpacity(.5),
              fontSize: 15,
              fontWeight: FontWeight.w200),
        )),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}

class JobCard extends StatelessWidget {
  final DisplaySlot displaySlot;

  const JobCard({
    super.key,
    required this.displaySlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.grey.shade400.withOpacity(.3),
            blurRadius: 5.0,
          ),
        ],
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
      margin: EdgeInsets.only(
          bottom: getProportionateScreenWidth(15), left: 10, right: 10),
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
                  "${globals.url}/images/${displaySlot.hotelLogo}",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${displaySlot.payPerHour}",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text(
                      "ExpectedPay | ",
                      style: TextStyle(
                          fontSize: 12,
                          // color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${displaySlot.totalPay}",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                  Text(
                    "${displaySlot.date}",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${displaySlot.startTime} to ${displaySlot.endTime}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
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
                      "${displaySlot.hotelName}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${displaySlot.outletName}",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: (() {
                      Provider.of<Jobs>(context, listen: false)
                          .cancelJob(displaySlot.slotId)
                          .then((value) => {
                                Flushbar(
                                  margin: EdgeInsets.all(8),
                                  borderRadius: BorderRadius.circular(5),
                                  message: value == 200
                                      ? "Job Canceled Succesfully"
                                      : "Something went wrong! Please contact our support.",
                                  duration: Duration(seconds: 3),
                                )..show(context),
                              });
                    }),
                    child: Text("Cancel"))
              ],
            ))
      ]),
    );
  }
}
