import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/constants.dart';
import 'package:deaksapp/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sign_up_form.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> openlink() async {
    var link = "https://deaks-app-fe.vercel.app/terms-condition";
    var androidLink = Uri.parse(link);

    var iosLink = Uri.parse(link);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(iosLink)) {
        await launchUrl(iosLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sorry! Unable open URL")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(androidLink)) {
        await launchUrl(androidLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sorry! Unable open URL")));
      }
    }
  }

  Future<void> openPrivacy() async {
    var link = "https://deaks-app-fe.vercel.app/privacy-policy";
    var androidLink = Uri.parse(link);

    var iosLink = Uri.parse(link);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // for iOS phone only
      if (await canLaunchUrl(iosLink)) {
        await launchUrl(iosLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sorry! Unable open URL")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(androidLink)) {
        await launchUrl(androidLink, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sorry! Unable open URL")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Register Account", style: headingStyle),
                const Text(
                  "Complete your details.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                const SignUpForm(),

                SizedBox(height: getProportionateScreenHeight(20)),
                TextButton(
                  child: const Text("PrivacyPolicy."),
                  onPressed: () {
                    openPrivacy();
                  },
                ),
                TextButton(
                    onPressed: () {
                      openlink();
                    },
                    child: const Text("Terms and Conditons")),
                Text(
                  'By continuing your confirm that you agree \nwith our Term and Condition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
