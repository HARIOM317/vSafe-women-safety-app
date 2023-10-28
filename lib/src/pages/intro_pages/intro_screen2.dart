import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/utils/constants.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffcd9cf2).withOpacity(0.5), const Color(0xfff6f3ff).withOpacity(0.5)]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,  bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/sos.json", animate: true, width: 200),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: introTextDesign1("You can send SOS alert message to your all trusted contacts in emergency situation using vSafe SOS button"),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
