import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/utils/constants.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffabecd6).withOpacity(0.5), const Color(0xfffbed96).withOpacity(0.5),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/live_location.json", animate: true, width: 200),
                    ),

                    introTextDesign1("You can share your location with sos message to trusted contacts and emergency number in panic situation"),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/tracking.json", animate: true, width: 200),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: introTextDesign1("vSafe provide easy location tracking to stay safe",),
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
