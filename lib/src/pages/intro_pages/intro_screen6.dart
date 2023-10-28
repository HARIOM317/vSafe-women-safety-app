import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/utils/constants.dart';

class IntroPage6 extends StatelessWidget {
  const IntroPage6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffffafbd).withOpacity(0.3), const Color(0xffc9ffbf).withOpacity(0.3),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/tips.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("vSafe app provides you safety tips for any kind of situation by following which you can take the right decision in each and every situation"),


              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/women_help.json", animate: true, width: 200),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
