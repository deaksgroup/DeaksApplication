import 'dart:convert';
import 'dart:io';

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
import 'Actions.dart' as actions;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (isInIt) {
      setState(() {
        image = Provider.of<ProfileFetch>(context, listen: false)
            .getProfilePicture();
        profileUrlKey = Provider.of<ProfileFetch>(context, listen: false)
            .getProfileUrlKey();
        attaaireImageUrlKeys = Provider.of<ProfileFetch>(context, listen: false)
            .getAttaireImagesUrlKey();
        attireImages = Provider.of<ProfileFetch>(context, listen: false)
            .getAttaireiamges();

        profile = Provider.of<ProfileFetch>(context, listen: false).getProfile;
        if (profile["accountStatus"] == "AUTHORIZED") {
          _isRestricted = true;
        }
      });
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

  Future<void> submitUserData(Map<String, dynamic>? userData) async {
    setState(() {
      isLoading = true;
    });

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
                                      "h${globals.url}/images/$profileUrlKey",
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
                    enabled: false,
                    decoration: setDisabledDecoration(labelName: "Name"),
                    onChanged: (val) {
                      _formKeyForm.currentState?.fields['name']?.validate();
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(4),
                      FormBuilderValidators.max(22),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    name: UniqueKey().toString(),

                    enabled: false,
                    decoration: setDisabledDecoration(labelName: "Email"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['email']
                          ?.validate();
                    },

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
                  FormBuilderTextField(
                    name: 'contactNumber',
                    key: UniqueKey(),
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
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['contactNumber']
                          ?.validate();
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.match(r'^(\d\d\d\d\d\d\d\d)$')
                    ]),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    name: 'bookingName',
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("Booking Name"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['bookingName']
                          ?.validate();
                    },

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
                    name: 'Sex',
                    key: UniqueKey(),
                    enabled: true,
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
                    onChanged: (val) {},
                    valueTransformer: (val) => val?.toString(),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderDateTimePicker(
                    enabled: !_isRestricted,
                    key: UniqueKey(),
                    name: 'DOB',
                    // locale: const Locale.fromSubtags(languageCode: 'in'),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialValue: profile["DOB"]!.isNotEmpty
                        ? DateFormat("yyyy-MM-dd ")
                            .parse(profile["DOB"].toString())
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
                    onChanged: (val) {},
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
                  FormBuilderTextField(
                    name: 'unitNumber',
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("Unit Number"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['unitNumber']
                          ?.validate();
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    name: 'blockNumber',
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("Block Number"),
                    onChanged: (val) {},

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
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("Street"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['street']
                          ?.validate();
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
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("City"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['city']
                          ?.validate();
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
                    key: UniqueKey(),
                    decoration: setEnabledDecoration("ZIP Code"),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['zipCode']
                          ?.validate();
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
                  const SectionTitle(title: "Legal Status"),
                  const SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    enabled: !_isRestricted,
                    name: 'NRIC',
                    key: UniqueKey(),
                    decoration: setDisabledDecoration(
                        labelName: "NRIC", fillColor: _isRestricted),
                    onChanged: (val) {
                      _formKeyFormBuilder.currentState?.fields['NRIC']
                          ?.validate();
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
                    key: UniqueKey(),
                    name: 'residentStatus',
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
                      legalStatus = val.toString();
                      _formKeyFormBuilder.currentState?.fields['residentStatus']
                          ?.validate();
                    },
                    valueTransformer: (val) => val?.toString(),
                  ),
                  if (legalStatus == "Foreign Student")
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      isExpanded: true,
                      key: UniqueKey(),
                      name: 'FSInstitute',
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
                      onChanged: (val) {},
                      valueTransformer: (val) => val?.toString(),
                    ),
                  const SizedBox(height: 15),
                  if (legalStatus == "Foreign Student")
                    FormBuilderTextField(
                      name: 'FSIDNumber',
                      key: UniqueKey(),
                      decoration: setEnabledDecoration("ID Number"),
                      onChanged: (val) {
                        _formKeyFormBuilder.currentState?.fields['FSIDNumber']
                            ?.validate();
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
                  // SizedBox(
                  //   height: 100,
                  //   child: Center(
                  //     child: FormBuilderCheckbox(
                  //       name: 'accept_terms',
                  //       initialValue: false,
                  //       title: RichText(
                  //         text: TextSpan(
                  //           children: [
                  //             const TextSpan(
                  //               text: 'I have read and agree to the ',
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //             TextSpan(
                  //               text: 'Terms and Conditions',
                  //               style: const TextStyle(color: Colors.blue),
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   var link =
                  //                       "https://deaks-app-fe.vercel.app/terms-condition";
                  //                   actions.openlink(context, link);
                  //                 },
                  //             ),
                  //             const TextSpan(
                  //               text: ' & ',
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //             TextSpan(
                  //               text: 'Privacy Policy.',
                  //               style: const TextStyle(color: Colors.blue),
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   var link =
                  //                       "https://deaks-app-fe.vercel.app/privacy-policy";
                  //                   actions.openlink(context, link);
                  //                 },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       validator: FormBuilderValidators.equal(
                  //         true,
                  //         errorText:
                  //             'You must accept terms and conditions to continue',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                ],
              )),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (true && profile["verificationStatus"] != "PENDING") {
                      if (_formKeyFormBuilder.currentState?.saveAndValidate() ??
                          false) {
                        // debugPrint(_formKey.currentState?.value.toString());
                        submitUserData(_formKeyFormBuilder.currentState?.value);
                      } else {
                        debugPrint(
                            _formKeyFormBuilder.currentState?.value.toString());
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
                      _formKeyFormBuilder.currentState?.reset();
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
