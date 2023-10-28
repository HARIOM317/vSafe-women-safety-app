import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/components/primary_button.dart';
import 'package:vsafe/src/user/login_screen.dart';
import 'package:vsafe/src/user/register_user.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      // disable back button
      onWillPop: _onPop,

      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              Color(0xffdad4ec),
              Color(0xfff3e7e9)
            ])),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Center(
                    child: Lottie.asset("assets/animations/other_animations/login.json", animate: true, width: 250),
                  ),
                ),

                // login page button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryButton(
                    title: "Login",
                    onPressed: () {
                      Navigator.push(context, CustomPageRoute(child: const LoginScreen()));
                      },
                  ),
                ),

                // registration page button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryButton(
                      title: "Register",
                      onPressed: () {
                        Navigator.push(context, CustomPageRoute(child: const RegisterUser()));
                      }
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
