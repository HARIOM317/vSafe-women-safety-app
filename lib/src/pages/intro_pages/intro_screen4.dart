import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/utils/constants.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xfff3e7e9), Color(0xffe3eeff),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/ambulance.json", animate: true, width: 200),
                    ),

                    introTextDesign1("vSafe app can be a boon proof for you in any kind of emergency situation"),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/helpline_service.json", animate: true, width: 200),
                    ),
                    introTextDesign1("Using vSafe you can contact with government helpline services any time in case of emergency"),
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
