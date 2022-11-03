import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:deaksapp/providers/Slot.dart';
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
  List<Slot> jobsList = [];
  List<DisplaySlot> displayJobSlots = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      jobsList = Provider.of<Jobs>(context, listen: false).getJobs;
      print("didChangeDipendcy");
      displayJobSlots = [];

      jobsList.forEach((job) => {
            displayJobSlots.add(DisplaySlot(
                vacancy: job.vacancy,
                confirmedRequests: job.confirmedRequests,
                waitingListRequests: job.waitingRequests,
                release: job.release,
                slotId: job.id,
                jobRemarks2: job.jobRemarks,
                jobRemarks1: job.outlet["jobRemarks"],
                outletId: job.outlet["id"],
                outletName: job.outlet["outletName"],
                outletImages: job.outlet["outletImages"] ?? [],
                paymentDetails: job.outlet["payment"] ?? [],
                groomingImages: job.outlet["groomingImages"] ?? [],
                howToImages: job.outlet["howToImages"] ?? [],
                adminNumber: job.outlet["outletAdminNo"] ?? "",
                youtubeLink: job.outlet["youtubeLink"] ?? "",
                hotelId: job.hotel["id"] ?? "",
                hotelName: job.hotel["hotelName"] ?? "",
                hotelLogo: job.hotel["hotelLogo"] ?? "",
                googleMapLink: job.hotel["googleMapLink"] ?? "",
                appleMapLink: job.hotel["appleMapLink"] ?? "",
                date: job.date,
                startTime: job.startTime,
                endTime: job.endTime,
                payPerHour: job.hourlyPay,
                totalPay: job.totalPayForSlot,
                priority: job.priority))
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
      print("refresh jobs");
    }));

    // didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Buidling myjobs");
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
