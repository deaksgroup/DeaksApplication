import 'package:deaksapp/screens/DeleteAccount/DeleteAccount.dart';
import 'package:deaksapp/screens/JobDetailsScreen/JobDetailsScreen.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';

import 'package:deaksapp/screens/forgot_password/components/ForgotOTPScreen.dart';
import 'package:deaksapp/screens/myJobs/MyJobs.dart';
import 'package:deaksapp/screens/newPasswordForm/newPasswordScreen.dart';
import 'package:deaksapp/screens/notofications/NotoficationPage.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:deaksapp/screens/subscriptions/subscriptionsScreen.dart';

import 'package:flutter/widgets.dart';

import 'package:deaksapp/screens/complete_profile/complete_profile_screen.dart';

import 'package:deaksapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:deaksapp/screens/home/home_screen.dart';
import 'package:deaksapp/screens/login_success/login_success_screen.dart';
import 'package:deaksapp/screens/otp/otp_screen.dart';
import 'package:deaksapp/screens/profile/profile_screen.dart';
import 'package:deaksapp/screens/sign_in/sign_in_screen.dart';
import 'package:deaksapp/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),

  ProfileScreen.routeName: (context) => ProfileScreen(),
  PageState.routeName: (context) => PageState(),
  JobDetailsScreen.routeName: (context) => JobDetailsScreen(),
  // MyJobs.routeName: (context) => MyJobs(),
  MyDetails.routeName: (context) => MyDetails(),
  ForgotOTPScreen.routeName: (context) => ForgotOTPScreen(),
  NewPasswordScreen.routeName: (context) => NewPasswordScreen(),
  DeleteAccount.routeName: (context) => DeleteAccount(),

  NotoficationPage.routeName: (context) => NotoficationPage(),
  Subscriptions.routeName: (context) => Subscriptions()
};
