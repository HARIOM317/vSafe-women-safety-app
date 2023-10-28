import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsafe/src/pages/required_pages/contact_screen.dart';
import 'package:vsafe/src/user/authentication/forgot_password_page.dart';
import 'package:vsafe/src/user/update_user_profile.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  Widget accountOption(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Settings",
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
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color(0xfff9d2cf).withOpacity(0.5),
          ),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    color: Colors.deepPurpleAccent,
                    size: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserProfile()));
                },
                child: accountOption("Update Profile"),
              ),

              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                  },
                  child: accountOption("Add Trusted Contact")),

              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                  },
                  child: accountOption("Change Password")),

              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // share button
                  GestureDetector(
                    onTap: () async{
                      await Share.share('com.women_safety.v_safe');
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        height: 90,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff863aff), Color(0xff9883ea)]),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(CupertinoIcons.share,
                                color: Colors.white, size: 30),
                            Text(
                              "SHARE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Rate Us Button
                  GestureDetector(
                    onTap: () {
                      showRatingDialogBox();
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        height: 90,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff863aff), Color(0xff9883ea)]),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(CupertinoIcons.star_fill,
                                color: Colors.white, size: 30),
                            Text(
                              "RATE US",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // Sign Out Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    signOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff1d4ec),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(15),
                      elevation: 2),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        fontFamily: 'PTSans-Regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red[900]),
                  ),
                ),
              ),

              // PrimaryButton(title: "Sign Out", onPressed: (){}),

              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(height: 30),

              // Terms and Conditions
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: RichText(
                    text: TextSpan(
                        // Default Style
                        style: const TextStyle(
                            fontFamily: 'PTSans-Regular',
                            fontSize: 15,
                            color: Color(0xff383838)),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Terms & Conditions",
                              style: const TextStyle(
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri url = Uri.parse("https://sites.google.com/view/vsafe-terms-and-conditions");

                                  try {
                                    final result = await InternetAddress.lookup('example.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      if (!await launchUrl(url)) {
                                        throw Exception('Could not launch $url');
                                      }
                                    }
                                  } on SocketException catch (_) {
                                    // ignore: use_build_context_synchronously
                                    showSnackbar(context, "No internet connection found!");
                                  }
                                }),
                          const TextSpan(text: " of using the product"),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void showRatingDialogBox() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return RatingDialog(
              title: const Text(
                "RATE US",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "PTSans-Regular",
                    fontWeight: FontWeight.bold),
              ),
              message: const Text(
                "Share your experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "PTSans-Regular",
                ),
              ),
              image: Image.asset(
                "assets/images/icon/logo.png",
                height: 100,
              ),
              submitButtonText: "SUBMIT",
              submitButtonTextStyle: const TextStyle(
                fontFamily: "PTSans-Regular",
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              starSize: 35,
              onSubmitted: (response) {
                // print("Rating : ${response.rating}");
                // print("Comment : ${response.comment}");
                if(response.rating < 3.0){

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff9d2cf).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Lottie.asset("assets/animations/other_animations/improve_app.json", animate: true, width: 200),
                                    ),
                                  ),

                                  const TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'How can we improve our app?'),
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        openEmail();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Write your issue",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  StoreRedirect.redirect(androidAppId: "com.women_safety.v_safe", iOSAppId: "com.women_safety.v_safe");
                }
              });
        });
  }
}
