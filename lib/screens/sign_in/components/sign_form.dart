import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/screens/otp/otp_screen.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/custom_surfix_icon.dart';
import 'package:deaksapp/components/form_error.dart';
import 'package:deaksapp/helper/keyboard.dart';
import 'package:deaksapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> authenticateUser() async {
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    final extractedUserPushToken =
        await jsonDecode(prefs.getString('userPushToken').toString())
            as Map<dynamic, dynamic>;

    Map<String, String> loginData = {
      "email": email.toString(),
      "password": password.toString(),
      "userPushToken": extractedUserPushToken["userPushToken"].toString()
    };

    Provider.of<Auth>(context, listen: false)
        .loginUser(loginData)
        .then((value) => {
              setState(() {}),
              if (value["message"] != null)
                {
                  Flushbar(
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(5),
                    message: value["message"],
                    duration: const Duration(seconds: 3),
                  )..show(context),
                },
              // //print(!Provider.of<Auth>(context, listen: false).isAuth),
              if (Provider.of<Auth>(context, listen: false).isAuth)
                {
                  if (!Provider.of<Auth>(context, listen: false)
                      .isNumberVerified)
                    {
                      Provider.of<Auth>(context, listen: false)
                          .verifyOtpCreate(),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OtpScreen()),
                          ModalRoute.withName("/otp"))
                    }
                  else
                    {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageState()),
                          ModalRoute.withName("/pagestate"))
                    }
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                authenticateUser();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
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
        labelText: "Password",

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Email',
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
          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          floatingLabelBehavior: FloatingLabelBehavior.auto),
      // decoration: InputDecoration(
      //   labelText: "Email",
      //   hintText: "Enter your email",
      //   // If  you are using latest version of flutter then lable text and hint text shown like this
      //   // if you r using flutter less then 1.20.* then maybe this is not working properly
      //   floatingLabelBehavior: FloatingLabelBehavior.always,
      //   suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      // ),
    );
  }
}
