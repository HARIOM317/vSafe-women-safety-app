import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  var listRadius = [30.0, 60.0, 90.0, 120.0, 150.0, 180.0, 210, 240.0, 270.0, 300.0];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 7), lowerBound: 0.5);

    _animationController.addListener(() {
      setState(() {

      });
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xffe9defa).withOpacity(0.5), const Color(0xfffbfcdb).withOpacity(0.5), const Color(0xfff3e7e9).withOpacity(0.5)]
        )
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Center(
              child: SizedBox(
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    buildMyContainer(listRadius[0]),
                    buildMyContainer(listRadius[1]),
                    buildMyContainer(listRadius[2]),
                    buildMyContainer(listRadius[3]),
                    buildMyContainer(listRadius[4]),
                    buildMyContainer(listRadius[5]),
                    buildMyContainer(listRadius[6]),
                    buildMyContainer(listRadius[7]),
                    buildMyContainer(listRadius[8]),
                    buildMyContainer(listRadius[9]),

                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/images/icon/logo.png",)
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                  child: Lottie.asset("assets/animations/intro_app_animations/welcome_text.json", animate: true, width: 225),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMyContainer (radius) {
    return Container(
      // <<<  With _animationController >>>
      width: radius*_animationController.value,
      height: radius*_animationController.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // <<<  With _animationController >>>
        color: const Color(0xfff6d0ef).withOpacity(1.0 - _animationController.value),
      ),
    );
  }
}
