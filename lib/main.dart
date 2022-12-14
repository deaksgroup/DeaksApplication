import 'dart:convert';

import 'package:deaksapp/providers/Jobs.dart';
import 'package:deaksapp/providers/Notification.dart';

import 'package:deaksapp/providers/Profile.dart';
import 'package:deaksapp/providers/Slots.dart';
import 'package:deaksapp/screens/pagestate/pagestate.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:deaksapp/routes.dart';
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
  runApp(const MyApp());
}

Future<void> backgroundHandler(RemoteMessage message) async {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true)
        .then((value) {
      // //print(value);
    });
    FirebaseMessaging.instance.getToken().then((token) async {
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
          create: (context) => Slots(
            token: Provider.of<Auth>(context, listen: false).token,
          ),
          update: (context, auth, previous) => Slots(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, NotificationFetch>(
          create: (context) => NotificationFetch(
            token: Provider.of<Auth>(context, listen: false).token,
          ),
          update: (context, auth, previous) =>
              NotificationFetch(token: auth.token),
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
                    ? const PageState()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : const PageState(),
                      ),

                // ProfileScreen(),
                // MyDetails(),

                // initialRoute: PageState(),
                routes: routes,
              ))),
    );
  }
}
