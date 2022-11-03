import 'package:deaksapp/screens/home/home_screen.dart';
import 'package:deaksapp/screens/myJobs/MyJobs.dart';
import 'package:deaksapp/screens/profile/profile_screen.dart';
import 'package:deaksapp/screens/shareJobScreen/shareJobScreen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/Auth.dart';
import '../../providers/DisplaySlot.dart';
import '../../providers/Hotel.dart';
import '../../providers/Hotels.dart';
import '../../providers/Job.dart';
import '../../providers/Outlet.dart';
import '../../providers/Outlets.dart';
import '../../providers/Profile.dart';
import '../../providers/Slot.dart';
import '../../providers/Slots.dart';
import '../notofications/NotoficationPage.dart';
import '../sign_in/sign_in_screen.dart';

class PageState extends StatefulWidget {
  static String routeName = "/pageState";
  const PageState({super.key});

  @override
  State<PageState> createState() => _PageStateState();
}

class _PageStateState extends State<PageState> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

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

  // This widget is the root of your application.
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final String id = uri.toString().split("/").last;

      if (Provider.of<Auth>(context, listen: false).isAuth) {
        Provider.of<Slots>(context, listen: false)
            .fetchSingleSlot(id)
            .then((value) {
          Navigator.of(context).pushNamed(shreJobDetailsScreen.routeName);
        });
      } else {
        Navigator.of(context).pushNamed(SignInScreen.routeName);
      }
    }).onError((error) {});
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map<dynamic, dynamic> notify = {
        "title": message.notification?.title ?? "",
        "body": message.notification?.body ?? "",
        "slotId": message.data["slotId"] ?? "",
        "tokenNumber": message.data["tokenNumber"] ?? "",
        "action1": message.data["action1"] ?? "",
        "action2": message.data["action2"] ?? ""
      };

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotoficationPage(payload: notify)));
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        Map<dynamic, dynamic> notify = {
          "title": message.notification?.title ?? "",
          "body": message.notification?.body ?? "",
          "slotId": message.data["slotId"] ?? "",
          "tokenNumber": message.data["tokenNumber"] ?? "",
          "action1": message.data["action1"] ?? "",
          "action2": message.data["action2"] ?? ""
        };

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotoficationPage(payload: notify)));
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        Map<dynamic, dynamic> notify = {
          "title": message.notification?.title ?? "",
          "body": message.notification?.body ?? "",
          "slotId": message.data["slotId"] ?? "",
          "tokenNumber": message.data["tokenNumber"] ?? "",
          "action1": message.data["action1"] ?? "",
          "action2": message.data["action2"] ?? ""
        };

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotoficationPage(payload: notify)));
      }
    });
  }

  //

  @override
  void didChangeDependencies() async {
    Map<String, String> searchQuery = {
      "shiftName": "",
      "sortType": "All Jobs",
      "Hotels": "",
      "Tags": "",
      "subscribed": "",
      "limit": "20"
    };
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProfileFetch>(context, listen: false)
          .fetchAndSetProfile()
          .then((value) => {
                Provider.of<Slots>(context, listen: false)
                    .fetchAndSetSlots(searchQuery)
                    .then((value) => {
                          setState(() {
                            _isLoading = false;
                          }),
                        }),
              });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomeScreen(), MyJobs(), ProfileScreen()];
    SizeConfig().init(context);
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1,
              ),
            )
          : pages[selected],
      bottomNavigationBar: SizedBox(
        height: getProportionateScreenWidth(70),
        // decoration: BoxDecoration(color: Colors.grey),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
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
                  child: SizedBox(
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
                  child: SizedBox(
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
                  child: SizedBox(
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
