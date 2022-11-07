import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:flutter/material.dart';
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
        decoration: const BoxDecoration(color: Colors.white),
        height: 170,
        child: widget.displaySlots.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                      onTap: () => {
                            Navigator.pushNamed(
                                context, JobDetailsScreen.routeName,
                                arguments: [
                                  widget.displaySlots[index],
                                  widget.displaySlots,
                                ])
                          },
                      child: TrendingJobsCard(
                          displaySlot: widget.displaySlots[index]));
                }),
                itemCount: widget.displaySlots.length,
              )
            : const Center(
                child: Text("Jobs not available."),
              ));
  }
}

class TrendingJobsCard extends StatefulWidget {
  final DisplaySlot displaySlot;
  const TrendingJobsCard({
    super.key,
    required this.displaySlot,
  });

  @override
  State<TrendingJobsCard> createState() => _TrendingJobsCardState();
}

class _TrendingJobsCardState extends State<TrendingJobsCard> {
  String status = "Limited";
  Color color = Colors.red;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (int.parse(widget.displaySlot.vacancy) > 3) {
      setState(() {
        status = "Open";
        color = Colors.green;
      });
    } else if (int.parse(widget.displaySlot.vacancy) -
            widget.displaySlot.confirmedRequests.length >
        3) {
      setState(() {
        status = "Open";
        color = Colors.green;
      });
    } else if (int.parse(widget.displaySlot.vacancy) -
            widget.displaySlot.confirmedRequests.length <=
        0) {
      setState(() {
        status = "Waiting List";
        color = Colors.orange;
      });
    } else if (int.parse(widget.displaySlot.release) -
            int.parse(widget.displaySlot.vacancy) ==
        widget.displaySlot.waitingListRequests.length) {
      setState(() {
        status = "Closed";
        color = Colors.blue;
      });
    } else {
      setState(() {
        status = "Limited";
        color = Colors.red;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(
                255,
                243,
                218,
                1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(.3),
                blurRadius: 5.0,
              ),
            ]),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
        width: 230,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 65,
                  height: 65,
                  child: ClipRRect(
                    child: Image.network(
                      "${globals.url}/images/${widget.displaySlot.hotelLogo}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.displaySlot.startTime,
                          style:
                              const TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                        const Text(
                          " to ",
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                        Text(
                          widget.displaySlot.endTime,
                          style:
                              const TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                      ],
                    ),
                    Text(
                      widget.displaySlot.date,
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.displaySlot.hotelName,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.displaySlot.outletName,
                          style: const TextStyle(
                              fontSize: 9,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      height: 23,
                      width: 65,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "\$${widget.displaySlot.payPerHour} /h",
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        const Text(
                          "Expected Pay : ",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "\$${widget.displaySlot.totalPay}",
                          style: const TextStyle(
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
