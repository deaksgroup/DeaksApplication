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
        height: 170,
        width: 230,
        child: TrendingJobsCard()
        // ListView.builder(
        //   scrollDirection: Axis.horizontal,
        //   itemBuilder: ((context, index) {
        //     return GestureDetector(
        //         onTap: () => {
        //               Navigator.pushNamed(context, JobDetailsScreen.routeName,
        //                   arguments: [number[index]])
        //             },
        //         child: TrendingJobsCard(displaySlot: widget.displaySlots[index]));
        //   }),
        //   itemCount: number.length,
        // ),
        );
  }
}

class TrendingJobsCard extends StatelessWidget {
  // final DisplaySlot displaySlot;

  const TrendingJobsCard({
    super.key,
  });

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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.only(right: 5, top: 10, bottom: 10),
        width: 230,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  child: ClipRRect(
                    child: Image.network(
                      "${globals.url}/images/wefhweif}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "2:00 PM ",
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                        Text(
                          " to ",
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                        Text(
                          " 11:00 PM",
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        "27th Wed December",
                        style: TextStyle(fontSize: 10, color: Colors.red),
                      ),
                    )
                  ],
                ))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Perk Royal",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Pickering, Lime Restaurent",
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      height: 23,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          "Waiting List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "\$13 /h",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(
                          "Expected Pay : ",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "\$130",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
