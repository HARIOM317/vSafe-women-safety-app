// ignore_for_file: use_build_context_synchronously
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/components/primary_button.dart';
import 'package:vsafe/src/user/login_screen.dart';

class VerifyOTP extends StatelessWidget {
  const VerifyOTP({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.myauth}) : super(key: key);
  final EmailOTP myauth;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";
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
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
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
                          "Enter vSafe PIN",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NovaSlim-Regular',
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            VerifyOTP(
                              otpController: otp1Controller,
                            ),
                            VerifyOTP(
                              otpController: otp2Controller,
                            ),
                            VerifyOTP(
                              otpController: otp3Controller,
                            ),
                            VerifyOTP(
                              otpController: otp4Controller,
                            ),
                          ],
                        ),
                      ),
                      PrimaryButton(
                        title: "Confirm",
                        onPressed: () async {
                          if (await widget.myauth.verifyOTP(
                                  otp: otp1Controller.text +
                                      otp2Controller.text +
                                      otp3Controller.text +
                                      otp4Controller.text) ==
                              true) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                  content: Text("OTP is verified"),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                  content: Text("Invalid OTP"),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
