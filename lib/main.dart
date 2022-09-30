import 'dart:convert';

import 'package:deaksapp/providers/Hotels.dart';
import 'package:deaksapp/providers/Jobs.dart';
import 'package:deaksapp/providers/Outlets.dart';
import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:deaksapp/screens/MyDetails/MyDetails.dart';
import 'package:deaksapp/screens/forgot_password/components/ForgotOTPScreen.dart';
import 'package:deaksapp/screens/home/home_screen.dart';
import 'package:deaksapp/screens/newPasswordForm/newPasswordScreen.dart';
import 'package:deaksapp/screens/otp/otp_screen.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';
import 'package:deaksapp/screens/sign_in/sign_in_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/routes.dart';
import 'package:deaksapp/screens/profile/profile_screen.dart';
import 'package:deaksapp/screens/splash/splash_screen.dart';
import 'package:deaksapp/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./providers/Auth.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState

    FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true)
        .then((value) {
      // //print(value);
    });
    FirebaseMessaging.instance.getToken().then((token) async {
      print(token);
      final prefs = await SharedPreferences.getInstance();
      final userPushToken = json.encode(
        {
          'userPushToken': token,
        },
      );
      await prefs.setString('userPushToken', userPushToken);
    });
    FirebaseMessaging.instance.getAPNSToken().then((APNStoken) {
      // //print(APNStoken);
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
      print(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Jobs>(
          create: (
            context,
          ) =>
              Jobs(token: Provider.of<Auth>(context, listen: false).token),
          update: (context, auth, previousjobs) => Jobs(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, ProfileFetch>(
            create: ((context) => ProfileFetch(
                  token: Provider.of<Auth>(context, listen: false).token,
                  profile: {},
                )),
            update: ((context, auth, previous) =>
                ProfileFetch(token: auth.token, profile: {}))),
        ChangeNotifierProxyProvider<Auth, Slots>(
          create: (
            ctx,
          ) =>
              Slots(),
          update: (context, value, previous) => Slots(),
        ),
        ChangeNotifierProxyProvider<Auth, Outlets>(
          create: (
            ctx,
          ) =>
              Outlets(),
          update: (context, value, previous) => Outlets(),
        ),
        ChangeNotifierProxyProvider<Auth, Hotels>(
          create: (
            ctx,
          ) =>
              Hotels(),
          update: (context, value, previous) => Hotels(),
        ),
      ],
      child: Consumer<Auth>(
          builder: ((context, auth, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  FormBuilderLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales:
                    FormBuilderLocalizations.delegate.supportedLocales,
                title: 'Deaks App',
                theme: theme(),
                // home: SplashScreen(),
                // We use routeName so that we dont need to remember the name
                home: auth.isAuth
                    ? PageState()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : PageState(),
                      ),
                // initialRoute: PageState(),
                routes: routes,
              ))),
    );
  }
}
