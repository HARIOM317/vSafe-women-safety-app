import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/components/custom_textfield.dart';
import 'package:vsafe/src/utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      showAlertDialogueBox(
          context, "Password reset link sent! Check your email");
    } on FirebaseAuthException catch (e) {
      showAlertDialogueBox(context, e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // app icon
                Padding(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  child: Image.asset(
                    "assets/images/icon/logo.png",
                    width: 120,
                  ),
                ),

                // login text
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Enter your email and we will send you a password reset link",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Dosis-Regular',
                        color: Color(0xff401693),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginTextField(
                    controller: _emailController,
                    hintText: "Email",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(Icons.email_rounded),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      passwordReset();
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.deepPurpleAccent)),
                    child: const Text("Reset Password"),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
