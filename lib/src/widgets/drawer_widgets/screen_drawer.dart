// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsafe/src/chat/apis.dart';
import 'package:vsafe/src/pages/required_pages/chatbot.dart';
import 'package:vsafe/src/user/update_user_profile.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';
import 'package:vsafe/src/widgets/bottom_nav_bar.dart';
import 'package:vsafe/src/widgets/drawer_widgets/feedback_page.dart';
import 'package:vsafe/src/widgets/drawer_widgets/help_page.dart';
import 'package:vsafe/src/widgets/drawer_widgets/notification_page.dart';
import 'package:vsafe/src/widgets/drawer_widgets/setting_page.dart';
import 'package:share_plus/share_plus.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  bool isSaving = false;
  TextEditingController nameController = TextEditingController();

  LocationPermission? locationPermission;
  String lat = "";
  String long = "";

  _getPermission() async => await [Permission.sms].request();

  _getLatLong() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    long = position.longitude.toString();
    lat = position.latitude.toString();
  }

  _getCurrentLocation() async {
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permission denied!");
      if (locationPermission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Location permission permanently denied!");
      }
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .catchError((e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return e;
    });
  }

  // function to get user name from database
  getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      nameController.text = value.docs.first['name'];
      id = value.docs.first.id;
    });
  }

  // function to get user image from database
  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.docs.first['name'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    setState(() {
      getUserName();
      getData();
      _getLatLong();
      _getPermission();
      _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff4801FF).withOpacity(0.75),
              const Color(0xff7010fb).withOpacity(0.70),
              const Color(0xff7918F2).withOpacity(0.65)
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.linear,
      animationDuration: const Duration(milliseconds: 250),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),

      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserProfile()));
                      _advancedDrawerController.hideDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.white)),
                      child: profilePic == null
                          ? const CircleAvatar(
                              radius: 55,
                              child: Icon(
                                Icons.person,
                                size: 80,
                              ),
                            )
                          : profilePic!.contains('http')
                              ? CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(profilePic!),
                                )
                              : CircleAvatar(
                                  radius: 55,
                                  backgroundImage: FileImage(File(profilePic!)),
                                ),
                    ),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 35),
                child: Form(
                  key: key,
                  child: TextFormField(
                    enabled: false,
                    controller: nameController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Update your name";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: nameController.text,
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),

              // setting button
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSetting()));
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.settings),
                title: const Text('Setting'),
              ),

              // notification button
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
              ),

              const Divider(
                thickness: 1,
                color: Colors.white70,
              ),

              // share button
              ListTile(
                onTap: () async {
                  await Share.share('com.women_safety.v_safe');
                },
                leading: const Icon(Icons.share),
                title: const Text('Share'),
              ),

              // help button
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpPage()));
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.help),
                title: const Text('Help'),
              ),

              // logout button
              ListTile(
                onTap: () async {
                  signOut(context);
                },
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
              ),

              const Divider(
                thickness: 1,
                color: Colors.white70,
              ),

              // feedback button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserFeedback()));
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.feedback),
                title: const Text('Area Feedback'),
              ),

              // policy button
              ListTile(
                onTap: () async {
                  final Uri url = Uri.parse("https://sites.google.com/view/vsafe-privacy-policy");

                  try {
                    final result = await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                  }
                  }
                  } on SocketException catch (_) {
                  showSnackbar(context, "No internet connection found!");
                  }
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
              ),
            ],
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "vSafe",
            style: TextStyle(
                fontFamily: 'Dosis-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
            ),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, CustomPageRouteDirection(child: const ChatBot(), direction: AxisDirection.down));
                },
                icon: Image.asset(
                  "assets/images/icon/chatbot.png",
                  height: 40,
                )),
          ],
        ),
        body: const BottomNavBar(),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
