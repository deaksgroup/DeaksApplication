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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: "Hello"),
              TextSpan(
                text: " Max",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
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
