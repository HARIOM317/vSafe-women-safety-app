import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:vsafe/src/components/primary_button.dart';
import 'package:vsafe/src/user/update_user_profile.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/widgets/drawer_widgets/screen_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  bool isSaving = false;

  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  // function to reload to profile page on pull down
  Future<void> _handleRefresh () async{
    // reloading takes some time
    getData();
    getName();
    getEmail();
    getContact();
    getAbout();
    return await Future.delayed(const Duration(seconds: 2));
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  // function to get user name from database
  getName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      nameController.text = value.docs.first['name'];
      id = value.docs.first.id;
    });
  }

  // function to get user about information from database
  getAbout() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      aboutController.text = value.docs.first['about'];
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

  // function to get user email from database
  getEmail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      emailController.text = value.docs.first['email'];
      id = value.docs.first.id;
    });
  }

  // function to get user contact from database
  getContact() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      contactController.text = value.docs.first['phone'];
      id = value.docs.first.id;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getName();
      getEmail();
      getContact();
      getData();
      getAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        backgroundColor: const Color(0xfff9eae9),
        body: isSaving == true
            ? const Center(child: CircularProgressIndicator())
            : LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              color: Colors.deepPurpleAccent,
              backgroundColor: const Color(0xfff9d2cf).withOpacity(0.7),
              height: 300,
              animSpeedFactor: 3,
              showChildOpacityTransition: true,

              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Form(
                        key: key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "WELCOME",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'NovaSlim-Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                goTo(context, const UpdateUserProfile());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 3, color: Colors.white)),
                                child: profilePic == null
                                    ? const CircleAvatar(
                                        radius: 75,
                                        child: Icon(
                                          Icons.person,
                                          size: 120,
                                        ),
                                      )
                                    : profilePic!.contains('http')
                                        ? CircleAvatar(
                                            radius: 75,
                                            backgroundImage:
                                                NetworkImage(profilePic!),
                                          )
                                        : CircleAvatar(
                                            radius: 75,
                                            backgroundImage:
                                                FileImage(File(profilePic!)),
                                          ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller: nameController,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "User Name";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: nameController.text,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'PTSans-Regular',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple),
                              textAlign: TextAlign.center,
                            ),


                            TextFormField(
                              enabled: false,
                              controller: aboutController,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "About";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: aboutController.text,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),


                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              child: TextFormField(
                                enabled: false,
                                controller: emailController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Email ID";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white.withOpacity(0.2),
                                  filled: true,
                                  label: const Text("Registered Email"),
                                  hintText: emailController.text,
                                  prefixIcon: const Icon(Icons.email, color: Colors.black54,),

                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xFF909A9E),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: TextFormField(
                                enabled: false,
                                controller: contactController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Contact Number";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white.withOpacity(0.2),
                                  filled: true,
                                  label: const Text("Registered Phone"),
                                  hintText: contactController.text,
                                  prefixIcon: const Icon(Icons.phone, color: Colors.black54,),

                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0xFF909A9E),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: PrimaryButton(
                                  title: "EDIT PROFILE",
                                  onPressed: () async {
                                    goTo(context, const UpdateUserProfile());
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
