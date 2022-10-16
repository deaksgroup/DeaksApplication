import "package:flutter/foundation.dart";
import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Hotel.dart';
import 'package:deaksapp/providers/Hotels.dart';
import 'package:deaksapp/providers/Outlets.dart';
import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:flutter/material.dart';
// import 'package:deaksapp/components/coustom_bottom_nav_bar.dart';
import 'package:deaksapp/enums.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/Outlet.dart';
import '../../providers/Slot.dart';
import '../../size_config.dart';
import '../JobDetailsScreen/JobDetailsScreen.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  List<Slot> slots = [];
  List<DisplaySlot> displaySlotss = [];

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
    slots = Provider.of<Slots>(context, listen: false).getSlots;

    displaySlotss = [];
    slots.forEach((slot) => {
          setState(() {
            displaySlotss.add(DisplaySlot(
                slotId: slot.id,
                jobRemarks: getOulet(slot.outletId).jobRemarks,
                outletId: slot.outletId,
                outletName: slot.outletName,
                outletImages: getOulet(slot.outletId).outletImages ?? [],
                paymentDetails: getOulet(slot.outletId).paymentDescription,
                groomingImages: getOulet(slot.outletId).groomingImages ?? [],
                hoeToImages: getOulet(slot.outletId).howToImages ?? [],
                adminNumber: getOulet(slot.outletId).adminNumber,
                youtubeLink: getOulet(slot.outletId).youtubeLink,
                hotelId: slot.hotelId,
                hotelName: slot.hotelName,
                hotelLogo: getHotel(slot.hotelId).logo ?? "",
                googleMapLink: getHotel(slot.hotelId).googleMapLink ?? "",
                appleMapLink: getHotel(slot.hotelId).appleMapLink ?? "",
                date: slot.date,
                startTime: slot.startTime,
                endTime: slot.endTime,
                payPerHour: slot.payPerHour,
                totalPay: slot.totalPay,
                slotStatus: slot.slotStatus,
                priority: slot.priority));
          }),
        });
    _isInit = false;

    ////print("HomeScreen1111");

    ////print(_isInit);
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Slots>(context, listen: false)
        .fetchAndSetSlots()
        .then(((value) {
      didChangeDependencies();
      ////print("here");
    }));
    setState(() {});
    // didChangeDependencies();
  }

  Future<void> openWhatsapp() async {
    var whatsapp = "+6598596440";
    var whatsappURl_android =
        Uri.parse("whatsapp://send?phone=" + whatsapp + "&text=hello");
    "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = Uri.parse("https://wa.me/$whatsapp?text=hello");
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(whatappURL_ios)) {
        await launchUrl(whatappURL_ios, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp not installed!")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsappURl_android)) {
        await launchUrl(whatsappURl_android,
            mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp not installed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      didChangeDependencies();
    });
    SizeConfig().init(context);
    ////print("rebuilding");
    return
        // JobDetailsScreen();
        Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Body(
              displaySlots: displaySlotss,
            ),
          ),
          // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        ),
        Positioned(
            left: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                openWhatsapp();
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.shade400.withOpacity(.5),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                    child: Image.asset(
                  "assets/icons/whatsapp.png",
                  width: 45,
                )),
              ),
            )),
      ],
    );
  }
}
