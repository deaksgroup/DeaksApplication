import 'package:deaksapp/screens/home/home_screen.dart';
import 'package:deaksapp/screens/myJobs/MyJobs.dart';
import 'package:deaksapp/screens/profile/profile_screen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/Auth.dart';
import '../../providers/DisplaySlot.dart';
import '../../providers/Hotel.dart';
import '../../providers/Hotels.dart';
import '../../providers/Job.dart';
import '../../providers/Jobs.dart';
import '../../providers/Outlet.dart';
import '../../providers/Outlets.dart';
import '../../providers/Profile.dart';
import '../../providers/Slot.dart';
import '../../providers/Slots.dart';
import '../sign_in/sign_in_screen.dart';

class PageState extends StatefulWidget {
  static String routeName = "/pageState";
  PageState({super.key});

  @override
  State<PageState> createState() => _PageStateState();
}

class _PageStateState extends State<PageState> {
  var _isInit = true;
  var _isLoading = false;
  List<DisplaySlot> displaySlots = [];
  List<Slot> slots = [];
  List<Job> jobsList = [];
  List<DisplaySlot> displayJobSlots = [];
  var selected = 0;
  Outlet getOulet(String OutletId) {
    return Provider.of<Outlets>(context, listen: false)
        .getOutletDetails(OutletId);
  }

  Hotel getHotel(String hotelId) {
    return Provider.of<Hotels>(context, listen: false).getHotelDetails(hotelId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      ////print(_isInit);
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProfileFetch>(context, listen: false)
          .fetchAndSetProfile()
          .then((value) => {
                Provider.of<Slots>(context, listen: false)
                    .fetchAndSetSlots()
                    .then((value) => {
                          Provider.of<Outlets>(context, listen: false)
                              .fetchAndSetOulets()
                              .then((value) => {
                                    Provider.of<Hotels>(context, listen: false)
                                        .fetchAndSetHotels()
                                        .then((value) => {
                                              slots = Provider.of<Slots>(
                                                      context,
                                                      listen: false)
                                                  .getSlots,
                                              slots.forEach((slot) => {
                                                    //////print("222"),
                                                    //////print(slot),
                                                    //////print("333"),
                                                    displaySlots.add(DisplaySlot(
                                                        slotId: slot.id,
                                                        jobRemarks:
                                                            getOulet(slot.outletId)
                                                                .jobRemarks,
                                                        outletId: slot.outletId,
                                                        outletName:
                                                            slot.outletName,
                                                        outletImages: getOulet(slot.outletId)
                                                                .outletImages ??
                                                            [],
                                                        paymentDetails:
                                                            getOulet(slot.outletId)
                                                                .paymentDescription,
                                                        groomingImages:
                                                            getOulet(slot.outletId).groomingImages ??
                                                                [],
                                                        hoeToImages: getOulet(slot.outletId)
                                                                .howToImages ??
                                                            [],
                                                        adminNumber:
                                                            getOulet(slot.outletId)
                                                                .adminNumber,
                                                        youtubeLink:
                                                            getOulet(slot.outletId)
                                                                .youtubeLink,
                                                        hotelId: slot.hotelId,
                                                        hotelName: slot.hotelName,
                                                        hotelLogo: getHotel(slot.hotelId).logo ?? "",
                                                        longitude: getHotel(slot.hotelId).longitude ?? "",
                                                        latitude: getHotel(slot.hotelId).latitude ?? "",
                                                        date: slot.date,
                                                        startTime: slot.startTime,
                                                        endTime: slot.endTime,
                                                        payPerHour: slot.payPerHour,
                                                        totalPay: slot.totalPay,
                                                        slotStatus: slot.slotStatus,
                                                        priority: slot.priority)),
                                                  }),
                                              ////print("pagestate"),
                                              ////print(displaySlots),
                                            })
                                        .then((value) => {
                                              Provider.of<Jobs>(context,
                                                      listen: false)
                                                  .fetchAndSetJobs()
                                                  .then((value) => {
                                                        jobsList =
                                                            Provider.of<Jobs>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getJobs,
                                                        //////print(jobsList),
                                                        jobsList
                                                            .forEach((job) => {
                                                                  //////print("222"),
                                                                  //////print(job),
                                                                  //////print("333"),
                                                                  displayJobSlots.add(DisplaySlot(
                                                                      slotId: job
                                                                          .id,
                                                                      jobRemarks: getOulet(job.outletId)
                                                                          .jobRemarks,
                                                                      outletId: job
                                                                          .outletId,
                                                                      outletName: job
                                                                          .outletName,
                                                                      outletImages:
                                                                          getOulet(job.outletId).outletImages ??
                                                                              [],
                                                                      paymentDetails: getOulet(job.outletId)
                                                                          .paymentDescription,
                                                                      groomingImages:
                                                                          getOulet(job.outletId).groomingImages ??
                                                                              [],
                                                                      hoeToImages:
                                                                          getOulet(job.outletId).howToImages ??
                                                                              [],
                                                                      adminNumber:
                                                                          getOulet(job.outletId)
                                                                              .adminNumber,
                                                                      youtubeLink:
                                                                          getOulet(job.outletId)
                                                                              .youtubeLink,
                                                                      hotelId: job
                                                                          .hotelId,
                                                                      hotelName:
                                                                          job.hotelName,
                                                                      hotelLogo: getHotel(job.hotelId).logo ?? "",
                                                                      longitude: getHotel(job.hotelId).longitude ?? "",
                                                                      latitude: getHotel(job.hotelId).latitude ?? "",
                                                                      date: job.date,
                                                                      startTime: job.startTime,
                                                                      endTime: job.endTime,
                                                                      payPerHour: job.payPerHour,
                                                                      totalPay: job.totalPay,
                                                                      slotStatus: job.slotStatus,
                                                                      priority: job.priority)),
                                                                }),
                                                        setState(() {
                                                          _isLoading = false;
                                                        }),
                                                        //////print("5"),
                                                      }),
                                            })
                                  })
                        }),
              });
    }
    _isInit = false;
    ////print("HomeScreen");
    ////print(_isInit);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomeScreen(), MyJobs(), ProfileScreen()];
    SizeConfig().init(context);
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1,
              ),
            )
          : pages[selected],
      bottomNavigationBar: Container(
        height: getProportionateScreenWidth(70),
        // decoration: BoxDecoration(color: Colors.grey),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.shade400.withOpacity(.2),
                blurRadius: 30.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (selected != 0) {
                      setState(() {
                        ////print("home1");
                        selected = 0;
                      });
                    }
                  },
                  child: Container(
                    // decoration: BoxDecoration(color: Colors.white),
                    height: double.infinity,
                    child: Icon(
                      Icons.home_outlined,
                      color: selected == 0 ? Colors.red : Colors.grey,
                      size: selected == 0 ? 27 : 23,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (Provider.of<Auth>(context, listen: false).isAuth) {
                      if (selected != 1) {
                        setState(() {
                          selected = 1;
                        });
                      }
                    } else {
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    }
                  },
                  child: Container(
                      // decoration: BoxDecoration(color: Colors.white),
                      height: double.infinity,
                      child: Icon(
                        Icons.work_outline,
                        color: selected == 1 ? Colors.red : Colors.grey,
                        size: selected == 1 ? 27 : 23,
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (Provider.of<Auth>(context, listen: false).isAuth) {
                      if (selected != 2) {
                        setState(() {
                          ////print("home3");
                          selected = 2;
                        });
                      }
                    } else {
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    }
                  },
                  child: Container(
                      // decoration: BoxDecoration(color: Colors.white),
                      height: double.infinity,
                      child: Icon(
                        Icons.account_box_outlined,
                        color: selected == 2 ? Colors.red : Colors.grey,
                        size: selected == 2 ? 27 : 23,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
