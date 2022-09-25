import 'package:deaksapp/providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/custom_surfix_icon.dart';
import 'package:deaksapp/components/default_button.dart';
import 'package:deaksapp/components/form_error.dart';
import 'package:deaksapp/screens/complete_profile/complete_profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../pagestate/pagestate.dart';

class NewPasswordForm extends StatefulWidget {
  @override
  _NewPasswordFormState createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  String? password;
  String? confirm_password;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen

                Provider.of<Auth>(context, listen: false)
                    .setPassword(confirm_password.toString());
                Provider.of<Auth>(context, listen: false)
                    .setNewPassword()
                    .then((value) => {
                          if (value["errorCode"] != null &&
                              value["errorCode"] == 0)
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageState()),
                                  ModalRoute.withName("/pagestate"))
                            }
                        });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
        obscureText: true,
        onSaved: (newValue) => confirm_password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.isNotEmpty && password == confirm_password) {
            removeError(error: kMatchPassError);
          }
          confirm_password = value;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if ((password != value)) {
            addError(error: kMatchPassError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          disabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          border: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          labelText: "Confirm Password",

          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        ));
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
          password = value;
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
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          disabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          border: OutlineInputBorder(
              borderSide: new BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          labelText: "Password",

          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        ));
  }
}
