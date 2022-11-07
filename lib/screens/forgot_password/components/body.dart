import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/screens/forgot_password/components/ForgotOTPScreen.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/custom_surfix_icon.dart';
import 'package:deaksapp/components/default_button.dart';
import 'package:deaksapp/components/form_error.dart';
import 'package:deaksapp/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              const ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  String? contactNumber;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
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
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Provider.of<Auth>(context, listen: false).setEmail(email);
                Provider.of<Auth>(context, listen: false)
                    .forgotPassword()
                    .then((value) => {
                          if (value["errorCode"] == 1)
                            {
                              Flushbar(
                                margin: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(5),
                                message: value["message"],
                                duration: const Duration(seconds: 3),
                              )..show(context),
                            }
                          else if (value["errorCode"] == 0)
                            {
                              Navigator.pushNamed(
                                  context, ForgotOTPScreen.routeName),
                            }
                        });
                // Do what you want to do
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }
}
