import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vsafe/src/db/share_pref.dart';
import 'package:vsafe/src/pages/intro_pages/splash_screen.dart';
import 'package:vsafe/src/pages/required_pages/main_splash_screen.dart';
import 'package:vsafe/src/utils/constants.dart';
// import 'package:v_safe/src/utils/flutter_background_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreference.init();
  // await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // stop auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) async {
      await _initializeFirebase();
    });

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'vSafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.anekDevanagariTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.deepPurple,
      ),

      // todo -----X----- STARTING POINT OF APP -----X-----
      home: FutureBuilder(
          future: MySharedPreference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "") {
              return const SplashScreen();
            }
            if (snapshot.data == "user") {
              return const MainSplashScreen();
            }
            return progressIndicator(context);
          }),
    );
  }

  _initializeFirebase() async {
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For showing message notifications',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
    );
    log("Notification Channel Name: $result");
  }
}
