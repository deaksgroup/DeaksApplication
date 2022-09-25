import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/screens/newPasswordForm/newPasswordScreen.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/default_button.dart';
import 'package:deaksapp/size_config.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/Auth.dart';

class ForgotOTPForm extends StatefulWidget {
  const ForgotOTPForm({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotOTPFormState createState() => _ForgotOTPFormState();
}

class _ForgotOTPFormState extends State<ForgotOTPForm> {
  String otp = "";
  TextEditingController textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> verifiyForgotOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ////print("save");
      Provider.of<Auth>(context, listen: false).verifyForgotOtp(otp).then(
            (value) => {
              if (value["message"] != null)
                {
                  Flushbar(
                    margin: EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(5),
                    message: value["message"],
                    duration: Duration(seconds: 3),
                  )..show(context),
                },
              ////print(value),
              if (value["errorCode"] != null && value["errorCode"] == 0)
                {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewPasswordScreen()),
                      ModalRoute.withName("/newpasswordscreen"))
                }
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: getProportionateScreenWidth(250),
        height: getProportionateScreenWidth(200),
        child: Column(children: [
          Expanded(
            child: PinCodeTextField(
              appContext: context,
              pastedTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              blinkDuration: const Duration(milliseconds: 0),
              length: 4,
              validator: (v) {
                if (v!.length < 4) {
                  return "Please enter a valid OTP";
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  borderWidth: 1,
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  activeColor: Colors.grey,
                  errorBorderColor: Colors.redAccent,
                  selectedColor: Colors.black),
              enablePinAutofill: true,
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 0),
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                debugPrint("Completed");
                debugPrint(otp);
              },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  otp = value;
                });
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          ),
          // SizedBox(height: SizeConfig.screenHeight * 0.1),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: (() {
                _formKey.currentState!.validate();
                verifiyForgotOtp();
              }),
              child: const Text("Verifiy OTP")),
          Spacer()
        ]),
      ),
    );
  }
}
