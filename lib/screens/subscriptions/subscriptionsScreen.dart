import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

// final subcriptions = List<SubscriptionCard>.generate(
//     20,
//     (i) => SubscriptionCard(
//           index: i,
//           subscriptions: [],
//         ));

class Subscriptions extends StatefulWidget {
  static String routeName = "/subscriptions";
  Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  List<Map<dynamic, dynamic>> subcriptions = [];
  bool _isInIt = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInIt) {
      subcriptions =
          Provider.of<ProfileFetch>(context, listen: false).getSubscriptions;
    }

    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Subscriptions",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
              ),
            )),
        body: ListView.builder(
            itemCount: subcriptions.length,
            itemBuilder: ((context, index) => Dismissible(
                key: UniqueKey(),
                background: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.red),
                  child: Row(children: [
                    Spacer(),
                    Text(
                      "Unsubscribe",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ]),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  Provider.of<Slots>(context, listen: false)
                      .unSubscribeOutlet(subcriptions[index]["_id"])
                      .then((value) {
                    if (value == 200) {
                      setState(() {
                        print("removed");
                        subcriptions.removeAt(index);
                      });
                    }
                  });
                },
                child: SubscriptionCard(
                  outletName: subcriptions[index]["outletName"],
                  hotelName: subcriptions[index]["hotel"]["hotelName"],
                  subscriptions: subcriptions,
                  index: index,
                )))));
  }
}

class SubscriptionCard extends StatefulWidget {
  final String hotelName;
  final String outletName;
  final int index;
  final List<Map<dynamic, dynamic>> subscriptions;
  const SubscriptionCard(
      {super.key,
      required this.index,
      required this.subscriptions,
      required this.hotelName,
      required this.outletName});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(.2)),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.shade400.withOpacity(.3),
              blurRadius: 5.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.hotelName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
              Text(widget.outletName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w200))
            ],
          ),
          Container(
            child: Center(
                child: Icon(
              Icons.arrow_left_outlined,
              size: 50,
              color: Colors.red,
            )
                //  Text(
                //   "Unsubscribe",
                //   style: TextStyle(
                //       color: Colors.red,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 17),
                // ),
                ),
          )
        ],
      ),
    );
  }
}
