import 'package:deaksapp/screens/notofications/NotoficationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/Auth.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullName = Provider.of<Auth>(context, listen: false).getFullName();

    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.grey.shade400.withOpacity(1),
            blurRadius: 5.0,
          ),
        ],
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: "Hello $fullName.\n"),
              TextSpan(
                text: "Find your next job!",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconBtnWithCounter(
          svgSrc: "assets/icons/Bell.svg",
          numOfitem: 3,
          press: () {
            Navigator.pushNamed(context, NotoficationPage.routeName);
          },
        ),
      ]),
    );
  }
}
