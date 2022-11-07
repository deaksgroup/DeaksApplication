import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/components/custom_surfix_icon.dart';
import 'package:deaksapp/components/default_button.dart';
import 'package:deaksapp/components/form_error.dart';
import 'package:deaksapp/screens/otp/otp_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? fullName;

  String? contactNumber;
  String? address;

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

  void authenticateUser() async {
    Provider.of<Auth>(context, listen: false).signUpUser().then((value) => {
          ////print(value),
          if (value["message"] != null)
            {
              Flushbar(
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(5),
                message: value["message"],
                duration: const Duration(seconds: 3),
              )..show(context),
            },
          if (value["errorCode"] != null)
            {
              if (value["errorCode"] == 0)
                {Navigator.pushNamed(context, OtpScreen.routeName)}
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          const Text("*Singapore region only."),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Provider.of<Auth>(context, listen: false)
                    .setFullNameAndContactNumber(
                        fullName.toString(), contactNumber.toString());
                authenticateUser();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => contactNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty || value.length != 8) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",

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
        prefixText: "+65",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  // TextFormField buildLastNameFormField() {
  //   return TextFormField(
  //     onSaved: (newValue) => lastName = newValue,
  //     decoration: InputDecoration(
  //       labelText: "Last Name",
  //       hintText: "Enter your last name",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
  //     ),
  //   );
  // }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      onSaved: (newValue) => fullName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
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
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
