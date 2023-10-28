import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/utils/constants.dart';

class IntroPage7 extends StatelessWidget {
  const IntroPage7({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffc471f5).withOpacity(0.25), const Color(0xfffa71cd).withOpacity(0.4),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/security.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("Empower women Safety, Anywhere, Anytime with vSafe!"),
            ],
          ),
        ),
      ),
    );
  }
}
