import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/Hotel.dart';
import '../../providers/Hotels.dart';
import '../../providers/Job.dart';
import '../../providers/Outlet.dart';
import '../../providers/Outlets.dart';

import '../../providers/Slots.dart';
import 'Body.dart';

class MyJobs extends StatefulWidget {
  static String routeName = "/myjobs";

  MyJobs({super.key});

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  var _isInit = true;
  var _isLoading = false;
  List<Job> jobsList = [];
  List<DisplaySlot> displayJobSlots = [];

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
      jobsList = Provider.of<Jobs>(context, listen: false).getJobs;

      displayJobSlots = [];

      jobsList.forEach((job) => {
            displayJobSlots.add(DisplaySlot(
                slotId: job.id,
                jobRemarks: getOulet(job.outletId).jobRemarks,
                outletId: job.outletId,
                outletName: job.outletName,
                outletImages: getOulet(job.outletId).outletImages ?? [],
                paymentDetails: getOulet(job.outletId).paymentDescription,
                groomingImages: getOulet(job.outletId).groomingImages ?? [],
                hoeToImages: getOulet(job.outletId).howToImages ?? [],
                adminNumber: getOulet(job.outletId).adminNumber,
                youtubeLink: getOulet(job.outletId).youtubeLink,
                hotelId: job.hotelId,
                hotelName: job.hotelName,
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
          });
      setState(() {});
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Jobs>(context, listen: false)
        .fetchAndSetJobs()
        .then(((value) {
      _isInit = true;
      didChangeDependencies();
      ////print("here");
    }));

    // didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ////print("Buidling myjobs");
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Upcoming Jobs",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                  ),
                )),
            body: RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Body(
                jobsDispaySlots: displayJobSlots,
              ),
            )));
  }
}
