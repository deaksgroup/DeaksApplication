import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deaksapp/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  final List<DisplaySlot> displaySlots;
  final DisplaySlot displaySlot;

  Body({super.key, required this.displaySlot, required this.displaySlots});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selection = 0;

  List<DisplaySlot> moreDisplaySlots = [];
  Future<void> openWhatsapp(String whatsapp) async {
    var whatsappURl_android =
        Uri.parse("whatsapp://send?phone=" + whatsapp + "&text=hello");

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

  Future<void> openYoutube(String youtubeLink) async {
    var whatsappURl_android = Uri.parse(youtubeLink);

    var whatappURL_ios = Uri.parse(youtubeLink);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(whatappURL_ios)) {
        await launchUrl(whatappURL_ios, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Youtube not installed!")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsappURl_android)) {
        await launchUrl(whatsappURl_android,
            mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Youtube not installed!")));
      }
    }
  }

  Future<void> openlocation(String longitude, String latitude) async {
    var whatsappURl_android =
        Uri.parse('comgooglemaps://?center=${longitude},${latitude}');

    var whatappURL_ios =
        Uri.parse('https://maps.apple.com/?sll=${longitude},${latitude}');
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(whatappURL_ios)) {
        await launchUrl(whatappURL_ios, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("Maps not installed!")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsappURl_android)) {
        await launchUrl(whatsappURl_android,
            mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Google Maps not installed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(getProportionateScreenWidth(5)),
            child: Stack(
              children: [
                CarouselSlider(
                    items: widget.displaySlot.outletImages.map((id) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  "${globals.url}/images/$id",
                                  fit: BoxFit.fill,
                                ),
                              ));
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: getProportionateScreenHeight(1000) /
                          getProportionateScreenWidth(1000),
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    )),
                Positioned(
                  child: CustomAppBar(),
                  top: 20,
                  left: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenWidth(0),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: Color.fromRGBO(
                  255,
                  243,
                  218,
                  1,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.displaySlot.hotelName}",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.displaySlot.outletName}",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenWidth(10),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(5)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.displaySlot.startTime} to ${widget.displaySlot.endTime}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.displaySlot.date,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(children: [
                          Text("\$${widget.displaySlot.payPerHour} /h",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          Text("Expected Pay ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                              )),
                          Text(
                            "\$${widget.displaySlot.totalPay}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.15),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              openWhatsapp(widget.displaySlot.adminNumber);
                            }),
                            child: Container(
                              width: 35,
                              height: 35,
                              child: Image.asset("assets/icons/whatsapp.png"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              openYoutube(widget.displaySlot.youtubeLink);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Image.asset("assets/icons/youtube.png"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: (() {
                              openlocation(widget.displaySlot.longitude,
                                  widget.displaySlot.latitude);
                            }),
                            child: Container(
                              width: 30,
                              height: 30,
                              child:
                                  Image.asset("assets/icons/placeholder.png"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(2)),
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selection = 0;
                    });
                  },
                  child: Text(
                    "Job Remarks",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selection = 1;
                      moreDisplaySlots = widget.displaySlots
                          .where((element) =>
                              element.outletId == widget.displaySlot.outletId &&
                              element.slotId != widget.displaySlot.slotId)
                          .toList();
                      //print(moreDisplaySlots);
                    });
                  },
                  child: Text(
                    "More Slots",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selection = 2;
                    });
                  },
                  child: Text(
                    "Grooming",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selection = 3;
                    });
                  },
                  child: Text(
                    "How To Report",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selection = 4;
                    });
                  },
                  child: Text(
                    "Payment",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(5)),
            height: 500,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selection == 0)
                  Expanded(
                    child: Text("${widget.displaySlot.jobRemarks}"),
                  ),
                if (selection == 1)
                  Expanded(
                    child: moreDisplaySlots.length == 0
                        ? Center(
                            child: Text("No similar slots availbale."),
                          )
                        : ListView.builder(
                            itemCount: moreDisplaySlots.length,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, JobDetailsScreen.routeName,
                                      arguments: [
                                        moreDisplaySlots[index],
                                        widget.displaySlots
                                      ]);
                                },
                                child: MoreSlotCard(
                                    displaySlot: moreDisplaySlots[index],
                                    displaySlots: widget.displaySlots),
                              );
                            })),
                  ),
                if (selection == 2)
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.displaySlot.groomingImages.length,
                        itemBuilder: ((context, index) {
                          return ClipRRect(
                            child: Image.network(
                                "${globals.url}/images/${widget.displaySlot.groomingImages[index]}"),
                          );
                        })),
                  ),
                if (selection == 3)
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.displaySlot.hoeToImages.length,
                        itemBuilder: ((context, index) {
                          return ClipRRect(
                            child: Image.network(
                                "${globals.url}/images/${widget.displaySlot.hoeToImages[index]}"),
                          );
                        })),
                  ),
                if (selection == 4)
                  Expanded(
                    child: Text("${widget.displaySlot.paymentDetails}"),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MoreSlotCard extends StatelessWidget {
  final DisplaySlot displaySlot;
  final List<DisplaySlot> displaySlots;
  const MoreSlotCard(
      {super.key, required this.displaySlot, required this.displaySlots});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(5),
      ),
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 100,
              decoration: BoxDecoration(color: Colors.blueGrey),
              margin: EdgeInsets.only(right: 10),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${displaySlot.payPerHour} /h",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text(
                      "ExpectedPay | ",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${displaySlot.totalPay}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                  Text(
                    "${displaySlot.startTime} to ${displaySlot.endTime}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${displaySlot.date}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )
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
                          fontSize: 15,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                ),
              ],
            ))
      ]),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.shade400.withOpacity(.7),
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white.withOpacity(.9),
            borderRadius: BorderRadius.circular(5)),
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            CupertinoIcons.back,
            size: 30,
          ),
        ),
      ),
    );
  }
}
