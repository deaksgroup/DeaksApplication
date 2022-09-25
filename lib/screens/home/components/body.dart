import 'package:deaksapp/providers/DisplaySlot.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/screens/home/components/F&BAdhocJobs.dart';
import 'package:deaksapp/screens/home/components/TendingJobs.dart';
import 'package:deaksapp/screens/home/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  final List<DisplaySlot> displaySlots;
  Body({super.key, required this.displaySlots});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: getProportionateScreenWidth(5)),
            DiscountBanner(),
            SectionTitle(
              title: "Trending",
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            TrendingJobs(
              displaySlots: displaySlots
                  .where((element) => element.priority == "H")
                  .toList(),
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
            SectionTitle(
              title: "F&B Ad-hoc Jobs",
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            AdHocJobs(
                displaySlots: displaySlots
                    .where((element) => element.priority == "L")
                    .toList()),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
