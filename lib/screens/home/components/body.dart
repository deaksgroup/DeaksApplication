import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/home/components/F&BAdhocJobs.dart';
import 'package:deaksapp/screens/home/components/TendingJobs.dart';
import 'package:deaksapp/screens/home/components/section_title.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'discount_banner.dart';
import 'home_header.dart';

class Body extends StatefulWidget {
  final VoidCallback refresh;
  List<DisplaySlot> displaySlots;
  Body({super.key, required this.displaySlots, required this.refresh});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //  List<Slot> slots = [];
  // List<DisplaySlot> displaySlots = [];
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() async {
  //   if (_isInIt) {
  //     slots = Provider.of<Slots>(context, listen: false).getSlots;
  //     print("homeScreen");
  //     widget.displaySlots = [];
  //     slots.forEach((slot) => {
  //           setState(() {
  //             widget.displaySlots.add(DisplaySlot(
  //                 confirmedRequests: slot.confirmedRequests,
  //                 waitingListRequests: slot.waitingRequests,
  //                 vacancy: slot.vacancy,
  //                 release: slot.release,
  //                 slotId: slot.id,
  //                 jobRemarks2: slot.jobRemarks,
  //                 jobRemarks1: slot.outlet["jobRemarks"],
  //                 outletId: slot.outlet["_id"],
  //                 outletName: slot.outlet["outletName"],
  //                 outletImages: slot.outlet["outletImages"] ?? [],
  //                 paymentDetails: slot.outlet["payment"] ?? "",
  //                 groomingImages: slot.outlet["groomingImages"] ?? [],
  //                 howToImages: slot.outlet["howToImages"] ?? [],
  //                 adminNumber: slot.outlet["outletAdminNo"] ?? "",
  //                 youtubeLink: slot.outlet["youtubeLink"] ?? "",
  //                 hotelId: slot.hotel["_id"] ?? "",
  //                 hotelName: slot.hotel["hotelName"] ?? "",
  //                 hotelLogo: slot.hotel["hotelLogo"] ?? "",
  //                 googleMapLink: slot.hotel["googleMapLink"] ?? "",
  //                 appleMapLink: slot.hotel["appleMapLink"] ?? "",
  //                 date: slot.date,
  //                 startTime: slot.startTime,
  //                 endTime: slot.endTime,
  //                 payPerHour: slot.hourlyPay,
  //                 totalPay: slot.totalPayForSlot,
  //                 priority: slot.priority));
  //           }),
  //         });
  //   }

  //   _isInIt = false;

  //   ////print("HomeScreen1111");

  //   ////print(_isInit);
  //   super.didChangeDependencies();
  // }bool _isInIt = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const DiscountBanner(),
            const SizedBox(height: 10),
            HomeHeader(
              refrsh: () => widget.refresh(),
            ),
            const SizedBox(height: 20),
            const SectionTitle(
              title: "Trending",
            ),
            const SizedBox(height: 10),
            TrendingJobs(displaySlots: widget.displaySlots
                // .where((element) => element.priority == "HIGH")
                // .toList(),
                ),
            const SizedBox(height: 20),
            const SectionTitle(
              title: "F&B Ad-hoc Jobs",
            ),
            const SizedBox(height: 20),
            AdHocJobs(displaySlots: widget.displaySlots
                // .where((element) => element.priority == "LOW")
                // .toList()
                ),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
