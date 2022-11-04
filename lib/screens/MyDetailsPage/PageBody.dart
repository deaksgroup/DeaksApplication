import 'dart:convert';
import 'dart:io';

import 'package:deaksapp/screens/MyDetailsPage/Actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as _path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';
import '../home/components/section_title.dart';
import 'Options.dart' as options;
import 'package:deaksapp/globals.dart' as globals;
import "package:intl/src/intl/date_format.dart";
import '../../providers/Profile.dart';
import 'ProfilePicture.dart';
// import 'Actions.dart' as actions;

class PageBody extends StatefulWidget {
  const PageBody({super.key});

  @override
  State<PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  bool isInIt = true;
  bool isLoading = false;

  // final GlobalKey<FormBuilderState> _formKeyFormBuilder =
  //     GlobalKey<FormBuilderState>();
  final _formKeyForm = GlobalKey<FormState>();
  bool _isRestricted = false;
  File image = File("");
  List<File> attireImages = [];
  String profileUrlKey = "";
  List<String> attaaireImageUrlKeys = [];
  Map<String, String> profile = {};
  String legalStatus = "";

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;

  bool checkedValue = false;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController accountStatus = TextEditingController();
  TextEditingController Sex = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController unitNumber = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController blockNumber = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController NRIC = TextEditingController();
  TextEditingController PayNow = TextEditingController();
  TextEditingController bankAccNo = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController DOB = TextEditingController();
  TextEditingController emergencyContact = TextEditingController();
  TextEditingController emergencyContactName = TextEditingController();
  TextEditingController emergencyContactRelation = TextEditingController();
  TextEditingController verificationStatus = TextEditingController();
  TextEditingController residentStatus = TextEditingController();
  TextEditingController FSInstitute = TextEditingController();
  TextEditingController FSIDNumber = TextEditingController();
  TextEditingController bookingName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (isInIt) {
      print("rebuild didichange");
      image =
          Provider.of<ProfileFetch>(context, listen: false).getProfilePicture();
      profileUrlKey =
          Provider.of<ProfileFetch>(context, listen: false).getProfileUrlKey();
      attaaireImageUrlKeys = Provider.of<ProfileFetch>(context, listen: false)
          .getAttaireImagesUrlKey();
      attireImages =
          Provider.of<ProfileFetch>(context, listen: false).getAttaireiamges();

      profile = Provider.of<ProfileFetch>(context, listen: false).getProfile;
      if (profile["accountStatus"] == "AUTHORIZED") {
        _isRestricted = true;
      }
      name = TextEditingController(text: profile["name"]);
      email = TextEditingController(text: profile["email"]);
      contactNumber = TextEditingController(text: profile["contactNumber"]);
      accountStatus = TextEditingController(text: profile["accountStatus"]);
      Sex = TextEditingController(text: profile["Sex"]);
      city = TextEditingController(text: profile["city"]);
      unitNumber = TextEditingController(text: profile["unitNumber"]);
      street = TextEditingController(text: profile["street"]);
      blockNumber = TextEditingController(text: profile["blockNumber"]);
      zipCode = TextEditingController(text: profile["zipCode"]);
      NRIC = TextEditingController(text: profile["NRIC"]);
      PayNow = TextEditingController(text: profile["PayNow"]);
      bankAccNo = TextEditingController(text: profile["bankAccNo"]);
      bankName = TextEditingController(text: profile["bankName"]);
      DOB = TextEditingController(text: profile["DOB"]);
      emergencyContact =
          TextEditingController(text: profile["emergencyContact"]);
      emergencyContactName =
          TextEditingController(text: profile["emergencyContactName"]);
      emergencyContactRelation =
          TextEditingController(text: profile["emergencyContactRelation"]);
      verificationStatus =
          TextEditingController(text: profile["verificationStatus"]);
      residentStatus = TextEditingController(text: profile["residentStatus"]);
      FSInstitute = TextEditingController(text: profile["FSInstitute"]);
      FSIDNumber = TextEditingController(text: profile["FSIDNumber"]);
      bookingName = TextEditingController(text: profile["bookingName"]);
    }

    isInIt = false;
    super.didChangeDependencies();
  }

  Future<void> onReset() async {
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
                      child: const Text("Camera")),
                  CupertinoActionSheetAction(
                      onPressed: (() {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                      child: const Text("Gallery"))
                ],
              )));
    } else {
      return showModalBottomSheet(
          context: context,
          builder: ((context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Camera"),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text("Gallery"),
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
      if (imageFile != null) {
        final baseName = _path.basename(imageFile.path);
        // final imagePermenent = await saveImagePermenently(imageFile.path);
        final path = await getApplicationDocumentsDirectory();

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
          image = newImage;
          Provider.of<ProfileFetch>(context, listen: false)
              .setProfilePic(newImage);
        });
      }
    } on PlatformException catch (e) {}
  }

  void pickImages() async {
    try {
      final List<Media>? imageList = await ImagesPicker.pick(
          count: 2, pickType: PickType.image, gif: false, maxTime: 30);

      if (imageList!.isNotEmpty) {
        attireImages = [];
        imageList.forEach((image) async {
          final baseName = _path.basename(image.path);
          final path = await getApplicationDocumentsDirectory();

          final File newImage =
              await File(image.path).copy('${path.path}/$baseName');

          setState(() {
            attireImages.add(newImage);
            Provider.of<ProfileFetch>(context, listen: false)
                .setAttaireIamges(attireImages);
          });
          // Provider.of<ProfileFetch>(context, listen: false)
          //     .setAttaireIamges(attireImages);
        });
        final prefs = await SharedPreferences.getInstance();
        final attaireImagesPaths = json.encode(
          {
            'attaireImagesPaths': attireImages,
          },
        );
        await prefs.setString('attaireImagesPaths', attaireImagesPaths);
      }
    } on PlatformException catch (e) {}
  }

  Future<void> submitUserData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> userData = {
      "name": name.text,
      "email": email.text,
      "contctNumber": contactNumber.text,
      "bookingName": bookingName.text,
      "Sex": Sex.text,
      "city": city.text,
      "unitNumber": FSIDNumber.text,
      "blockNumber": blockNumber.text,
      "street": street.text,
      "zipCode": zipCode.text,
      "NRIC": NRIC.text,
      "PayNow": PayNow.text,
      "bankAccNo": bankAccNo.text,
      "bankName": bankName.text,
      "DOB": DOB.text,
      "emergencyContact": emergencyContact.text,
      "emergencyContactName": emergencyContactName.text,
      "emergencyContactRelation": emergencyContactRelation.text,
      "residentStatus": residentStatus.text,
      "FSInstitute": FSInstitute.text,
      "FSIDNumber": FSIDNumber.text
    };

    Provider.of<ProfileFetch>(context, listen: false)
        .submitProfile(userData, image, attireImages)
        .then((value) => {
              // Flushbar(
              //   margin: EdgeInsets.all(8),
              //   borderRadius: BorderRadius.circular(5),
              //   message: value["message"],
              //   duration: Duration(seconds: 3),
              // )..show(context),
              setState(() {
                isLoading = false;
              })
            });
  }

  InputDecoration setDisabledDecoration(
      {String labelName = "", bool fillColor = true}) {
    var decoration = InputDecoration(
      labelText: labelName,
      labelStyle: const TextStyle(
          color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold),
      fillColor: Colors.grey.withOpacity(.2),
      filled: fillColor,
      enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      disabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
    return decoration;
  }

  InputDecoration setEnabledDecoration(String labelName) {
    var decoration = InputDecoration(
      labelText: labelName,
      labelStyle: const TextStyle(
          color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      disabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 11.5, color: Colors.blueGrey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(5)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
    return decoration;
  }

  @override
  Widget build(BuildContext context) {
    var seen = Set<String>();
    List<String> uniquelist =
        options.institutes.where((country) => seen.add(country)).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            child: image.isAbsolute
                ? ProfilePicture(image: image, onReset: onReset)
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
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400.withOpacity(.6),
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: ClipOval(
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(15),
                              // ),
                              child: profileUrlKey.isEmpty
                                  ? Image.asset(
                                      "assets/images/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                                      width: 95,
                                      height: 95,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "${globals.url}/images/$profileUrlKey",
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
                                    BoxShadow(
                                      color:
                                          Colors.grey.shade400.withOpacity(.6),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color:
                                      const Color.fromARGB(255, 159, 222, 249),
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))))
                      ]),
                    )),
          ),
          const SizedBox(
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
              color: const Color.fromRGBO(118, 185, 71, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: profile["verificationStatus"] == "PENDING" ||
                            profile["verificationStatus"] == "NOTSUBMITTED"
                        ? "Account Verification Pending..."
                        : "Verified Account.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (profile["verificationStatus"] == "PENDING")
            const Text(
                "* Please wait! Your details have been submitted and waiting for verification. We may contact you during the verification process."),
          const SizedBox(
            height: 5,
          ),
          Form(
              key: _formKeyForm,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const SectionTitle(title: "Personal Details"),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: name,
                    enabled: false,
                    decoration: setDisabledDecoration(labelName: "Name"),
                    onChanged: (val) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(4),
                      FormBuilderValidators.max(22),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    enabled: false,
                    controller: email,
                    decoration: setDisabledDecoration(labelName: "Email"),
                    onChanged: (val) {},

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
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: contactNumber,
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 11.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixText: "+65",
                    ),
                    onChanged: (val) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.match(r'^(\d\d\d\d\d\d\d\d)$')
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: bookingName,
                    decoration: setEnabledDecoration("Booking Name"),
                    onChanged: (val) {},

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
                  DropdownButtonFormField<String>(
                    key: UniqueKey(),
                    value: Sex.text.toString(),
                    decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 11.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      hintText: 'Select Gender',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.notEqual("Select"),
                    ]),
                    items: options.genderOptions
                        .map((gender) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (val) {
                      Sex.text = val.toString();
                    },
                  ),
                  const SizedBox(height: 15),
                  FormBuilderDateTimePicker(
                    enabled: !_isRestricted,
                    controller: DOB,

                    name: 'DOB',
                    // locale: const Locale.fromSubtags(languageCode: 'in'),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,

                    initialValue: DOB.text.isNotEmpty
                        ? DateFormat("dd-MM-yyyy").parse(DOB.text.toString())
                        : null,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 5844)),
                    lastDate:
                        DateTime.now().subtract(const Duration(days: 5844)),
                    firstDate: DateTime.utc(1969, 7, 20, 20, 18, 04),
                    format: DateFormat("dd-MM-yyyy"),
                    inputType: InputType.date,
                    decoration: setDisabledDecoration(
                        labelName: "Date of birth", fillColor: _isRestricted),
                    onChanged: (val) {
                      print(val.toString().split(" ").first);
                      DOB.text = val.toString().split(" ").first;
                    },
                    onSaved: (newValue) => {newValue?.toIso8601String()},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.notEqual(DateTime.now()),
                    ]),
                  ),
                  const SizedBox(height: 40),
                  const SectionTitle(title: "Attire"),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => pickImages(),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.2),
                          border: Border.all(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        height: 200,
                        width: double.infinity,
                        child: attireImages.isNotEmpty &&
                                attireImages[0].isAbsolute &&
                                attireImages[1].isAbsolute
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400
                                                .withOpacity(.6),
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
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
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400
                                                .withOpacity(.6),
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
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
                            : attaaireImageUrlKeys.isEmpty
                                ? const Center(
                                    child: Text(
                                        "Please upload together.\n\n1. Fully Black formal Shoes.\n2. Black formal pants"))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade400
                                                    .withOpacity(.6),
                                                blurRadius: 5.0,
                                              ),
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            "${globals.url}/images/${attaaireImageUrlKeys[0]}",
                                            width: 110,
                                            height: 110,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade400
                                                    .withOpacity(.6),
                                                blurRadius: 5.0,
                                              ),
                                            ]),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            "${globals.url}/images/${attaaireImageUrlKeys[1]}",
                                            width: 110,
                                            height: 110,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                  ),
                  const SizedBox(height: 40),
                  const SectionTitle(title: "Address"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: unitNumber,
                    decoration: setEnabledDecoration("Unit Number"),
                    onChanged: (val) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: setEnabledDecoration("Block Number"),
                    onChanged: (val) {},
                    controller: blockNumber,
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
                  TextFormField(
                    controller: street,
                    decoration: setEnabledDecoration("Street"),
                    onChanged: (val) {},

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
                  TextFormField(
                    controller: city,
                    decoration: setEnabledDecoration("City"),
                    onChanged: (val) {},

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
                  TextFormField(
                    controller: zipCode,
                    decoration: setEnabledDecoration("ZIP Code"),
                    onChanged: (val) {},

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
                  const SectionTitle(title: "Legal Status"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    enabled: !_isRestricted,
                    controller: NRIC,
                    decoration: setDisabledDecoration(
                        labelName: "NRIC", fillColor: _isRestricted),
                    onChanged: (val) {},

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
                  DropdownButtonFormField<String>(
                    // autovalidate: true,
                    key: UniqueKey(),
                    value: residentStatus.text.toString(),
                    decoration: setEnabledDecoration("Legal Status"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.notEqual("Select")
                    ]),

                    items: options.residentOptions
                        .map((gender) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        legalStatus = val.toString();
                        residentStatus.text = val.toString();
                      });
                    },
                    // valueTransformer: (val) => val?.toString(),
                  ),
                  const SizedBox(height: 15),
                  if (residentStatus.text == "Foreign Student")
                    DropdownButtonFormField<String>(
                      // autovalidate: true,
                      isExpanded: true,
                      key: UniqueKey(),
                      value: FSInstitute.text.toString(),
                      decoration: setEnabledDecoration("Selelct Institute"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.notEqual("Select")
                      ]),
                      items: uniquelist
                          .map((institute) => DropdownMenuItem(
                                alignment: AlignmentDirectional.centerStart,
                                value: institute,
                                child: Text(institute),
                              ))
                          .toList(),
                      onChanged: (val) {
                        FSInstitute.text = val.toString();
                      },
                    ),
                  const SizedBox(height: 15),
                  if (residentStatus.text == "Foreign Student")
                    TextFormField(
                      controller: FSIDNumber,
                      decoration: setEnabledDecoration("ID Number"),
                      onChanged: (val) {
                        FSIDNumber.text = val.toString();
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
                  const SectionTitle(title: "Payment Details"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: PayNow,

                    decoration: setEnabledDecoration("PayNow Number"),
                    onChanged: (val) {},

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
                  TextFormField(
                    controller: bankAccNo,

                    decoration: setEnabledDecoration("Bank Account Number"),
                    onChanged: (val) {},

                    // valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    // initialValue: '12',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: bankName,

                    decoration: setEnabledDecoration("Name of Bank"),
                    onChanged: (val) {},

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
                  const SectionTitle(title: "Emergency Contact"),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emergencyContact,

                    decoration: InputDecoration(
                      labelText: "Emergency Contact",
                      labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      // fillColor: Color.fromRGBO(232, 235, 243, 1),
                      // filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 11.5,
                              color: Colors.blueGrey.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixText: "+65",
                      // suffixIcon: _emergencyContactHasError
                      //     ? const Icon(Icons.error, color: Colors.red)
                      //     : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {},

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
                  TextFormField(
                    controller: emergencyContactName,

                    decoration: setEnabledDecoration("Emergency Contact Name"),
                    onChanged: (val) {},

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
                  TextFormField(
                    controller: emergencyContactRelation,

                    decoration: setEnabledDecoration('Relation'),
                    onChanged: (val) {},

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
              )),
          SizedBox(
            height: 50,
            child: Center(
              child: CheckboxListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'I have read and agree to the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            var link =
                                "https://deaks-app-fe.vercel.app/terms-condition";
                            openlink(context, link);
                          },
                      ),
                      const TextSpan(
                        text: ' & ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            var link =
                                "https://deaks-app-fe.vercel.app/privacy-policy";
                            openlink(context, link);
                          },
                      ),
                    ],
                  ),
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = true;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (true &&
                        checkedValue &&
                        profile["verificationStatus"] != "PENDING") {
                      if (_formKeyForm.currentState?.validate() ?? false) {
                        debugPrint(_formKeyForm.currentState?.toString());
                        submitUserData();
                      } else {
                        debugPrint(_formKeyForm.currentState?.toString());
                        debugPrint('validation failed');
                      }
                    }
                  },
                  child: isLoading
                      ? const Center(
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
                    if (true) {
                      _formKeyForm.currentState?.reset();
                    }
                  },
                  // color: Theme.of(context).colorScheme.secondary,
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
