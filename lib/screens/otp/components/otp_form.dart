import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/default_button.dart';
import 'package:deaksapp/size_config.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/Auth.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String otp = "";
  TextEditingController textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> verifiyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //print("save");
      Provider.of<Auth>(context, listen: false).verifyOtp(otp).then((value) => {
            if (value["errorCode"] == 1)
              {
                Flushbar(
                  margin: EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(5),
                  message: value["message"],
                  duration: Duration(seconds: 3),
                )..show(context),
              },
            if (value["errorCode"] != null && value["message"] != null) {},
            if (Provider.of<Auth>(context, listen: false).isAuth)
              {
                if (Provider.of<Auth>(context, listen: false).isNumberVerified)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => PageState()),
                        ModalRoute.withName("/pagestate"))
                  }
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: getProportionateScreenWidth(250),
        height: getProportionateScreenWidth(130),
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
          // Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: (() {
                _formKey.currentState!.validate();
                verifiyOtp();
              }),
              child: const Text("Verifiy OTP"))
        ]),
      ),
    );
  }
}
