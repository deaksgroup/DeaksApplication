import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:deaksapp/screens/MyDetails/ProfilePicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';
import 'package:deaksapp/screens/home/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:images_picker/images_picker.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';
import "../../globals.dart" as MediaType;

class Body extends StatefulWidget {
  final VoidCallback press;
  bool isEditable;
  Body({super.key, required this.isEditable, required this.press});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File? image;
  List<File> attireImages = [];

  bool isInIt = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _dobHasError = false;
  bool _genderHasError = false;
  var genderOptions = ['Male', 'Female', 'Other', 'Select'];
  var residentOptions = [
    "Select",
    "Singaporean",
    "Permanent Resident",
    "Foreign Student"
  ];
  var institutes = [
    "Select",
    "Anglo-Chinese School (International) Singapore",
    "Australian International School",
    "Canadian International School",
    "Chatsworth International School",
    "Digipen",
    "Duke-NUS Graduate Medical School",
    "Dulwich College (Singapore)",
    "EDHEC Risk Institute-Asia",
    "ESSEC Business School (Singapore)",
    "GEMS World Academy (Singapore)",
    "German European School Singapore",
    "German Institute of Science and Technology - TUM Asia",
    "Government Junior Colleges",
    "Government secondary schools",
    "Government-aided Junior Colleges",
    "Government-aided secondary schools",
    "Hwa Chong International School",
    "Hollandse school",
    "INSEAD, Singapore",
    "Institute of Technical Education, Singapore",
    "International Community School",
    "ISS International School",
    "The Japanese School Singapore",
    "LaSalle College of the Arts",
    "Lycee Francais De Singapour",
    "Nanyang Academy of Fine Arts",
    "Nanyang Polytechnic",
    "Nanyang Technological University",
    "National University of Singapore",
    "Nexus International School (Singapore)",
    "Ngee Ann Polytechnic",
    "Overseas Family School",
    "Republic Polytechnic",
    "S P Jain School of Global Management Singapore",
    "Saint Joseph's Institution International School",
    "Sekolah Indonesia",
    "Singapore American School",
    "Singapore Institute of Technology",
    "Singapore Korean International School",
    "Singapore Management University",
    "Singapore Polytechnic",
    "Singapore University of Social Sciences",
    "Singapore University of Technology and Design",
    "Sorbonne-Assas International Law School - Asia",
    "Stamford American International School",
    "Swiss School in Singapore",
    "Tanglin Trust School",
    "Temasek Polytechnic",
    "United World College of South East Asia",
    "The University of Chicago Booth School of Business",
    "Waseda Shibuya Senior High School in Singapore",
    "Yale-NUS College of the National University of Singapore"
  ];

  bool _unitNumberHasError = false;

  bool _floorHasError = false;

  bool _streetHasError = false;

  bool _cityHasError = false;

  bool _zipHasError = false;

  bool _statusHasError = false;

  bool _FSIHasError = false;

  bool _FSIDHasError = false;

  bool _NRICHasError = false;

  bool _payNowHasError = false;

  bool _BACCNOHasError = false;

  bool _bankNameHasError = false;

  bool _emergencyContactHasError = false;

  bool _emergencyContactNameHasError = false;

  bool _emergencyContactRelationHasError = false;

  bool _bookingNameHasError = false;

  bool _emailHasError = false;

  bool _nameHasError = false;

  bool _numberHasError = false;

  String legalStatus = "";

  Future<void> onReset() async {
    print("hello");
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return showCupertinoModalPopup(
          context: context,
          builder: ((context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: (() {
                        pickImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      }),
                      child: Text("Camera")),
                  CupertinoActionSheetAction(
                      onPressed: (() {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                      child: Text("Gallery"))
                ],
              )));
    } else {
      return showModalBottomSheet(
          context: context,
          builder: ((context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Camera"),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text("Gallery"),
                    onTap: (() {
                      pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                  )
                ],
              )));
    }
  }

  void pickImage(ImageSource source) async {
    try {
      final imageFile = await ImagePicker().pickImage(source: source);
      print("pickImage");
      if (imageFile != null) {
        print(imageFile.path);
        final baseName = Path.basename(imageFile.path);
        // final imagePermenent = await saveImagePermenently(imageFile.path);
        final path = await getApplicationDocumentsDirectory();
        log("1");
        print(path.path);
        final File newImage =
            await File(imageFile.path).copy('${path.path}/$baseName');
        final prefs = await SharedPreferences.getInstance();
        final profilePicPath = json.encode(
          {
            'profilePicPath': newImage.path.toString(),
          },
        );
        await prefs.setString('profilePicPath', profilePicPath);
        setState(() {
          print("setState");
          image = newImage;
        });
      }
    } on PlatformException catch (e) {
      print("Failed to pick image : $e");
    }
  }

  void pickImages() async {
    try {
      final List<Media>? imageList = await ImagesPicker.pick(
          count: 2, pickType: PickType.image, gif: false, maxTime: 30);

      if (imageList!.isNotEmpty) {
        attireImages = [];
        imageList.forEach((image) async {
          final baseName = Path.basename(image.path);
          final path = await getApplicationDocumentsDirectory();

          final File newImage =
              await File(image.path).copy('${path.path}/$baseName');
          setState(() {
            attireImages.add(newImage);
          });
        });
      }
    } on PlatformException catch (e) {
      print("Failed to pick image : $e");
    }
  }

  // Future<List<File>> saveImagesPermenently(Lis)

  // Future<File> saveImagePermenently(String ImagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   final image = File("${directory.path}$ImagePath");
  //   return File(ImagePath).copy(image);
  // }

  Future<void> submitUserData(Map<String, dynamic>? userData) async {
    setState(() {
      isLoading = true;
    });

    Provider.of<ProfileFetch>(context, listen: false)
        .submitProfile(userData, image, attireImages)
        .then((value) => {
              ////print("insideForm"),
              ////print(value),
              Flushbar(
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(5),
                message: value["message"],
                duration: Duration(seconds: 3),
              )..show(context),
              setState(() {
                isLoading = false;
              })
            });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var seen = Set<String>();

    List<String> uniquelist =
        institutes.where((country) => seen.add(country)).toList();
    List<String> uniqueStatus =
        institutes.where((country) => seen.add(country)).toList();
    Map<String, String> profile =
        Provider.of<ProfileFetch>(context, listen: false).getProfile;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(children: [
        SizedBox(
          height: 30,
        ),
        Container(
          child: image != null
              ? ProfilePicture(image: image!, onReset: onReset)
              : GestureDetector(
                  onTap: () => onReset(),
                  child: Container(
                    width: 110,
                    height: 115,
                    child: Stack(children: [
                      Center(
                        child: Container(
                          // margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey.shade400.withOpacity(.6),
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: ClipOval(
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(15),
                            // ),
                            child: Image.asset(
                              "assets/images/Profile Image.png",
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 8,
                          bottom: 0,
                          child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey.shade400.withOpacity(.6),
                                    blurRadius: 5.0,
                                  ),
                                ],
                                color: Color.fromARGB(255, 159, 222, 249),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))))
                    ]),
                  )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          // height: 90,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: getProportionateScreenWidth(20)),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(10),
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(118, 185, 71, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(
              TextSpan(
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: profile["verificationStatus"] == "Pending" ||
                            profile["verificationStatus"] == "Not Submitted"
                        ? "Account Verification Pending..."
                        : "Verified Account.",
                  ),
                ],
              ),
            ),
            // if (!(profile["verificationStatus"] == "Pending" ||
            //     profile["verificationStatus"] == "Not Submitted" ||
            //     profile["accountStatus"] == "Unauthorized"))
            //   Container(
            //     width: 30,
            //     height: 30,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(25),
            //       ),
            //     ),
            //     child: Center(
            //         child: Image.asset(
            //       "assets/icons/checked.png",
            //       width: 25,
            //       height: 25,
            //     )),
            //   )
          ]),
        ),
        SizedBox(
          height: 5,
        ),
        if (profile["verificationStatus"] == "Pending")
          Text(
              "* Please wait! Your details have been submitted and waiting for verification. We may contact you during the verification process."),
        FormBuilder(
          enabled: isEditable,
          key: _formKey,
          // enabled: false,
          onChanged: () {
            _formKey.currentState!.save();
            debugPrint(_formKey.currentState!.value.toString());
          },
          initialValue: profile,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          // initialValue: profile as Map<String, dynamic>,
          skipDisabled: true,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              SectionTitle(title: "Personal Details"),
              SizedBox(
                height: 25,
              ),
              FormBuilderTextField(
                name: 'name',
                enabled: true,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _nameHasError =
                        !(_formKey.currentState?.fields['name']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.min(4),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'email',
                enabled: true,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // suffixIcon: (_nameHasError)
                  //     ? const Icon(Icons.error, color: Colors.red)
                  //     : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _emailHasError =
                        !(_formKey.currentState?.fields['email']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'contactNumber',

                decoration: InputDecoration(
                  labelText: "Contact Number",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixText: "+65",
                ),
                onChanged: (val) {
                  setState(() {
                    _numberHasError = !(_formKey
                            .currentState?.fields['contactNumber']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(r'^(\d\d\d\d\d\d\d\d)$')
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'bookingName',

                decoration: InputDecoration(
                  labelText: "Bookin Name",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _bookingNameHasError = !(_formKey
                            .currentState?.fields['bookingName']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.min(5),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderDropdown<String>(
                // autovalidate: true,
                name: 'Sex',
                enabled: isEditable,
                decoration: InputDecoration(
                  labelText: "Gender",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'Select Gender',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.notEqual("Select"),
                ]),
                items: genderOptions
                    .map((gender) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _genderHasError =
                        !(_formKey.currentState?.fields['Sex']?.validate() ??
                            false);
                  });
                },
                valueTransformer: (val) => val?.toString(),
              ),
              const SizedBox(height: 15),
              FormBuilderDateTimePicker(
                name: 'DOB',
                // locale: const Locale.fromSubtags(languageCode: 'in'),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                // initialValue: DateTime.now().subtract(Duration(days: 5844)),
                initialDate: DateTime.now().subtract(Duration(days: 5844)),
                lastDate: DateTime.now().subtract(Duration(days: 5844)),
                firstDate: DateTime.utc(1969, 7, 20, 20, 18, 04),
                format: DateFormat("dd-MM-yyyy"),
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: "Date Of Birth",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _dobHasError =
                        !(_formKey.currentState?.fields['DOB']?.validate() ??
                            false);
                  });
                },
                onSaved: (newValue) => {newValue?.toIso8601String()},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.notEqual(DateTime.now()),
                ]),

                // locale: const Locale.fromSubtags(languageCode: 'fr'),
              ),
              const SizedBox(height: 40),
              SectionTitle(title: "Attire"),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => pickImages(),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.2),
                      border: Border.all(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.grey.shade400.withOpacity(.6),
                      //     blurRadius: 5.0,
                      //   ),
                      // ]
                    ),
                    height: 200,
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: Colors.grey.withOpacity(.3),
                    //   border: Border.all(width: 1, color: Colors.grey),
                    // ),
                    child: attireImages.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey.shade400
                                            .withOpacity(.6),
                                        blurRadius: 5.0,
                                      ),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  child: Image.file(
                                    attireImages[0],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey.shade400
                                            .withOpacity(.6),
                                        blurRadius: 5.0,
                                      ),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  child: Image.file(
                                    attireImages[1],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(child: Text("Select images"))),
              ),
              const SizedBox(height: 40),
              SectionTitle(title: "Address"),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'unitNumber',

                decoration: InputDecoration(
                  labelText: "Unit Number",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _unitNumberHasError = !(_formKey
                            .currentState?.fields['unitNumber']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'floorNumber',

                decoration: InputDecoration(
                  labelText: "Floor Number",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _floorHasError = !(_formKey
                            .currentState?.fields['floorNumber']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'street',

                decoration: InputDecoration(
                  labelText: "Street",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _streetHasError =
                        !(_formKey.currentState?.fields['street']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'city',

                decoration: InputDecoration(
                  labelText: "City",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _cityHasError =
                        !(_formKey.currentState?.fields['city']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'zipCode',

                decoration: InputDecoration(
                  labelText: "ZIP Code",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _zipHasError = !(_formKey.currentState?.fields['zipCode']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(r'^(\d\d\d\d\d\d)$'),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 40),
              SectionTitle(title: "Legal Status"),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'NRIC',

                decoration: InputDecoration(
                  labelText: "NRIC",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _NRICHasError =
                        !(_formKey.currentState?.fields['NRIC']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(
                      r'^[STGMstgm]\d\d\d\d\d\d\d[A-Za-z]$'),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderDropdown<String>(
                // autovalidate: true,

                name: 'residentStatus',
                decoration: InputDecoration(
                  labelText: "Legal Status",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.notEqual("Select")
                ]),

                items: residentOptions
                    .map((gender) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    legalStatus = val.toString();
                    _statusHasError = !(_formKey
                            .currentState?.fields['residentStatus']
                            ?.validate() ??
                        false);
                  });
                },
                valueTransformer: (val) => val?.toString(),
              ),
              const SizedBox(height: 15),
              if (legalStatus == "Foreign Student")
                FormBuilderDropdown<String>(
                  // autovalidate: true,
                  isExpanded: true,

                  name: 'FSInstitute',
                  decoration: InputDecoration(
                    labelText: "Selelct Institute",
                    labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    // fillColor: Color.fromRGBO(232, 235, 243, 1),
                    // filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 11.5,
                            color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.notEqual("Select")
                  ]),
                  items: uniquelist
                      .map((gender) => DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _FSIHasError = !(_formKey
                              .currentState?.fields['FSInstitute']
                              ?.validate() ??
                          false);
                    });
                  },
                  valueTransformer: (val) => val?.toString(),
                ),
              const SizedBox(height: 15),
              if (legalStatus == "Foreign Student")
                FormBuilderTextField(
                  name: 'FSIDNumber',

                  decoration: InputDecoration(
                    labelText: "ID Number",
                    labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    // fillColor: Color.fromRGBO(232, 235, 243, 1),
                    // filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(
                            width: 11.5,
                            color: Colors.blueGrey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(5)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _FSIDHasError = !(_formKey
                              .currentState?.fields['FSIDNumber']
                              ?.validate() ??
                          false);
                    });
                  },

                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                  // initialValue: '12',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              const SizedBox(height: 40),
              SectionTitle(title: "Payment Details"),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'PayNow',

                decoration: InputDecoration(
                  labelText: "PayNow Number",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _payNowHasError =
                        !(_formKey.currentState?.fields['PayNow']?.validate() ??
                            false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(r'^(\d\d\d\d\d\d\d\d)$'),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'bankAccNo',

                decoration: InputDecoration(
                  labelText: "Bank Account Number",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _BACCNOHasError = !(_formKey
                            .currentState?.fields['bankAccNo']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'bankName',

                decoration: InputDecoration(
                  labelText: "Name of Bank",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _bankNameHasError = !(_formKey
                            .currentState?.fields['bankName']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 40),
              SectionTitle(title: "Emergency Contact"),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'emergencyContact',

                decoration: InputDecoration(
                  labelText: "Emergency Contact",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixText: "+65",
                  // suffixIcon: _emergencyContactHasError
                  //     ? const Icon(Icons.error, color: Colors.red)
                  //     : const Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (val) {
                  setState(() {
                    _emergencyContactHasError = !(_formKey
                            .currentState?.fields['emergencyContact']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(r'^(\d\d\d\d\d\d\d\d)$')
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'emergencyContactName',

                decoration: InputDecoration(
                  labelText: "Emergency Contact Name",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _emergencyContactNameHasError = !(_formKey
                            .currentState?.fields['emergencyContactName']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'emergencyContactRelation',

                decoration: InputDecoration(
                  labelText: 'Relation',

                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  // fillColor: Color.fromRGBO(232, 235, 243, 1),
                  // filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (val) {
                  setState(() {
                    _emergencyContactRelationHasError = !(_formKey
                            .currentState?.fields['emergencyContactRelation']
                            ?.validate() ??
                        false);
                  });
                },

                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(22),
                ]),
                // initialValue: '12',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  if (isEditable &&
                      profile["verificationStatus"] != "Pending") {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // debugPrint(_formKey.currentState?.value.toString());
                      submitUserData(_formKey.currentState?.value);
                    } else {
                      debugPrint(_formKey.currentState?.value.toString());
                      debugPrint('validation failed');
                    }
                  }
                },
                child: isLoading
                    ? Center(
                        child: SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            )),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (isEditable) {
                    _formKey.currentState?.reset();
                  }
                },
                // color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
