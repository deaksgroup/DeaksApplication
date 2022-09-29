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
import 'package:provider/provider.dart';
import '../../size_config.dart';

class Body extends StatefulWidget {
  final VoidCallback press;
  bool isEditable;
  Body({super.key, required this.isEditable, required this.press});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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

  Future<void> submitUserData(Map<String, dynamic>? userData) async {
    setState(() {
      isLoading = true;
    });

    Provider.of<ProfileFetch>(context, listen: false)
        .submitProfile(userData)
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
    var seen = Set<String>();

    List<String> uniquelist =
        institutes.where((country) => seen.add(country)).toList();
    List<String> uniqueStatus =
        institutes.where((country) => seen.add(country)).toList();
    Map<String, String> profile =
        Provider.of<ProfileFetch>(context, listen: false).getProfile;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Column(children: [
        Container(
          // height: 90,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: getProportionateScreenWidth(20)),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(15),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: "Hello ${profile["name"] ?? " "}.\n",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: profile["verificationStatus"] == "Pending" ||
                            profile["verificationStatus"] == "Not Submitted"
                        ? "Account Verification Pending..."
                        : "Verified Account.",
                  ),
                ],
              ),
            ),
            if (!(profile["verificationStatus"] == "Pending" ||
                profile["verificationStatus"] == "Not Submitted" ||
                profile["accountStatus"] == "Unauthorized"))
              Container(
                width: 30,
                height: 30,
                child: Image.asset("assets/icons/checked.png"),
              )
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
          autovalidateMode: AutovalidateMode.always,
          // initialValue: profile as Map<String, dynamic>,
          skipDisabled: true,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              SectionTitle(title: "Personal Details"),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'email',
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    suffixIcon: _emailHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                    floatingLabelBehavior: FloatingLabelBehavior.auto),
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
                name: 'name',
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'FullName',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _nameHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                name: 'contactNumber',

                decoration: InputDecoration(
                  labelText: "Contact Number",
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixText: "+65",
                  suffixIcon: _numberHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Booking Name',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _bookingNameHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Gender',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffix: _genderHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                initialValue: DateTime.now().subtract(Duration(days: 5844)),
                lastDate: DateTime.now().subtract(Duration(days: 5844)),
                firstDate: DateTime.utc(1969, 7, 20, 20, 18, 04),
                format: DateFormat("dd-MM-yyyy"),
                inputType: InputType.date,
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Date of Birth',
                  suffixIcon: _dobHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
              SectionTitle(title: "Address"),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'unitNumber',

                decoration: InputDecoration(
                  labelText: 'Unit Number',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _unitNumberHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Floor Number',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _floorHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Street',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _streetHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'City',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _cityHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'zipCode',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _zipHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'NRIC',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _NRICHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Legal Status',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffix: _statusHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                  // hintText: 'Select Gender',
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
                    labelText: 'Select Institute',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffix: _FSIHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                    // hintText: 'Select Gender',
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
                    labelText: 'ID Number',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide:
                            new BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIcon: _FSIDHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'PayNow Number',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _payNowHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Bank Account Number',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _BACCNOHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Name Of Bank',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _bankNameHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Emergency Contact',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixText: "+65",
                  suffixIcon: _emergencyContactHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  labelText: 'Emergency Contact Name',
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _emergencyContactNameHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: _emergencyContactRelationHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
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
