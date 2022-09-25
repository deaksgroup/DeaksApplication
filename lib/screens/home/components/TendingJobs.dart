import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:deaksapp/globals.dart' as globals;

class TrendingJobs extends StatefulWidget {
  final List<DisplaySlot> displaySlots;
  const TrendingJobs({super.key, required this.displaySlots});

  @override
  State<TrendingJobs> createState() => _TrendingJobsState();
}

class _TrendingJobsState extends State<TrendingJobs> {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 300,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return GestureDetector(
              onTap: () => {
                    Navigator.pushNamed(context, JobDetailsScreen.routeName,
                        arguments: [
                          widget.displaySlots[index],
                          widget.displaySlots,
                        ])
                  },
              child: TrendingJobsCard(displaySlot: widget.displaySlots[index]));
        }),
        itemCount: widget.displaySlots.length,
      ),
    );
  }
}

class TrendingJobsCard extends StatelessWidget {
  final DisplaySlot displaySlot;

  const TrendingJobsCard({super.key, required this.displaySlot});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(
              255,
              243,
              218,
              1,
            ),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.shade400.withOpacity(.3),
              blurRadius: 5.0,
            ),
          ]),
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(2), vertical: 10),
      width: getProportionateScreenWidth(200),
      // height: getProportionateScreenWidth(220),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: getProportionateScreenWidth(200),
          height: 130,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              "${globals.url}/images/${displaySlot.hotelLogo}",
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromRGBO(
                255,
                243,
                218,
                1,
              ),
              borderRadius: BorderRadius.circular(5.0)),
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 5),
            Text(
              displaySlot.hotelName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              displaySlot.outletName,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.w200),
            )
          ]),
        ),
        SizedBox(height: 10),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${displaySlot.startTime} to ${displaySlot.endTime}",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
            Text(displaySlot.date,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                )),
          ]),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child: Row(
            children: [
              Text("Expected Pay : ",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              Text("\$${displaySlot.totalPay}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
