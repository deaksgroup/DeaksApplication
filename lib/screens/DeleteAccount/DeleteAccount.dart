import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/constants.dart';
import 'package:deaksapp/providers/Auth.dart';
import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../components/custom_surfix_icon.dart';
import '../pagestate/pagestate.dart';

class DeleteAccount extends StatefulWidget {
  static String routeName = "/deleteaccount";
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  String? password = "";

  Future<void> deleteUser() async {
    Provider.of<Auth>(context, listen: false)
        .deleteAccount(password)
        .then((value) => {
              Flushbar(
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(5),
                message: value["message"],
                duration: Duration(seconds: 3),
              )..show(context),
              if (value["errorCode"] == 0)
                {
                  Provider.of<Auth>(context, listen: false).logout(),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => PageState()),
                      ModalRoute.withName("/pagestate")),
                }
              else
                {}
            });
  }

  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<ProfileFetch>(context, listen: false).getProfile;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Delete Account",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          )),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          height: 335,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${profile["name"]}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text("Now just a minute.",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Are you sure you want to delete your whole account? Your data will be deleted permanently, and this can't be undone. If you're sure, confirm by your password.",
                  style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => password = newValue,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "";
                  }
                  return null;
                }),
                onChanged: (value) {},
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
                  fillColor: Colors.white,
                  filled: true,

                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        deleteUser();
                      } else {
                        ////print("invalid");
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Permenently delete my account")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
