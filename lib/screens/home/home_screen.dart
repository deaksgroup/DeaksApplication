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
  bool _isLoading = false;
  List<Slot> slots = [];
  List<DisplaySlot> displaySlots = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      slots = Provider.of<Slots>(context, listen: false).getSlots;
      print(slots.length);
      displaySlots = [];
      slots.forEach((slot) => {
            displaySlots.add(DisplaySlot(
                confirmedRequests: slot.confirmedRequests,
                waitingListRequests: slot.waitingRequests,
                vacancy: slot.vacancy,
                release: slot.release,
                slotId: slot.id,
                jobRemarks2: slot.jobRemarks,
                jobRemarks1: slot.outlet["jobRemarks"],
                outletId: slot.outlet["_id"],
                outletName: slot.outlet["outletName"],
                outletImages: slot.outlet["outletImages"] ?? [],
                paymentDetails: slot.outlet["payment"] ?? "",
                groomingImages: slot.outlet["groomingImages"] ?? [],
                howToImages: slot.outlet["howToImages"] ?? [],
                adminNumber: slot.outlet["outletAdminNo"] ?? "",
                youtubeLink: slot.outlet["youtubeLink"] ?? "",
                hotelId: slot.hotel["_id"] ?? "",
                hotelName: slot.hotel["hotelName"] ?? "",
                hotelLogo: slot.hotel["hotelLogo"] ?? "",
                googleMapLink: slot.hotel["googleMapLink"] ?? "",
                appleMapLink: slot.hotel["appleMapLink"] ?? "",
                date: slot.date,
                startTime: slot.startTime,
                endTime: slot.endTime,
                payPerHour: slot.hourlyPay,
                totalPay: slot.totalPayForSlot,
                priority: slot.priority)),
            setState(() {
              _isLoading = false;
            }),
          });
    }

    _isInit = false;

    ////print("HomeScreen1111");

    ////print(_isInit);
    super.didChangeDependencies();
  }

  void searchRefrsh() {
    print("hello");
    _isInit = true;
    didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    Map<String, String> searchQuery = {
      "search": "",
      "sortType": "All Jobs",
      "Hotels": "",
      "Tags": "",
      "subscribed": "",
      "limit": "20"
    };
    await Provider.of<Slots>(context, listen: false)
        .fetchAndSetSlots(searchQuery)
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
            refresh: (() => searchRefrsh()),
            displaySlots: displaySlots,
          ),
        )
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
