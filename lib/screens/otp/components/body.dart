import 'dart:async';

import 'package:deaksapp/providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/constants.dart';
import 'package:deaksapp/size_config.dart';
import 'package:provider/provider.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController changeContactNumber = TextEditingController();
  final _FormKey = GlobalKey<FormState>();
  bool isEnabeld = false;
  String? newContactNumber = "";

  void enableResendOtp() {
    setState(() {
      isEnabeld = true;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        // _FormKey.currentState!.save();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        if (_FormKey.currentState!.validate()) {
          _FormKey.currentState!.save();
          Provider.of<Auth>(context, listen: false)
              .setContactNumber(newContactNumber.toString());
          Provider.of<Auth>(context, listen: false)
              .verifyOtpCreate()
              .then((value) => {});

          Navigator.of(context).pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Please enter your contact number!",
        style: TextStyle(fontSize: 15),
      ),
      content: Form(
        key: _FormKey,
        child: TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            // labelText: "Password",
            prefixText: "+65",

            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          validator: (value) {
            if (value!.isEmpty || value.length != 8) {
              return "";
            }
            return null;
          },
          controller: changeContactNumber,
          onChanged: (value) => {newContactNumber = value},
          // onSaved: ((newValue) {
          //   newContactNumber = newValue.toString();
          // }),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 45), (() {
      setState(() {
        isEnabeld = true;
      });
    }));
    String contactNumber =
        Provider.of<Auth>(context, listen: false).getContactNumber();
    String fullName = Provider.of<Auth>(context, listen: false).getFullName();
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Hello $fullName, We sent an OTP to $contactNumber",
                    maxLines: 2,
                  )),
              buildTimer(),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              const OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // OTP code resendi
                  if (isEnabeld) {
                    ////print("resend");
                    setState(() {});
                  }
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: isEnabeld ? Colors.blue : Colors.grey),
                ),
              ),
              TextButton(
                  onPressed: (() {
                    showAlertDialog(context);
                  }),
                  child: const Text("Change Number")),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 45.00, end: 0.00),
          duration: const Duration(seconds: 45),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
