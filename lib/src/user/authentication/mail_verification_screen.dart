// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/components/primary_button.dart';
import 'package:vsafe/src/user/authentication/otp_verification_screen.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({super.key});

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  String? id;
  TextEditingController email = TextEditingController();
  EmailOTP myAuth = EmailOTP();

  get otpController => null;

  // function to get user email from database
  getEmail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      email.text = value.docs.first['email'];
      id = value.docs.first.id;
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color(0xffdad4ec).withOpacity(0.75),
          const Color(0xffdad4ec).withOpacity(0.5),
          const Color(0xfff3e7e9).withOpacity(0.75)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: ListView(shrinkWrap: true, children: [
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Lottie.asset(
                      "assets/animations/other_animations/email_verification.json")),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      child: Text(
                        "Click on Send OTP to get Code",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NovaSlim-Regular',
                            color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      child: TextFormField(
                        enabled: false,
                        controller: email,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.mail_rounded,
                            color: Colors.black54,
                          ),
                          hintText: email.text,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontFamily: 'PTSans-Regular'),
                      ),
                    ),
                    PrimaryButton(
                        title: "Send OTP",
                        onPressed: () async {
                          myAuth.setConfig(
                              appEmail: "community.vsafe@gmail.com",
                              appName: "Email OTP",
                              userEmail: email.text,
                              otpLength: 4,
                              otpType: OTPType.digitsOnly);
                          if (await myAuth.sendOTP() == true) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                  content: Text("OTP has been sent"),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                          myauth: myAuth,
                                        )));
                          } else {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                  content: Text("Oops, OTP send failed"),
                            ));
                          }
                        }),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
