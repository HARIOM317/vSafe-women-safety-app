import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/widgets/drawer_widgets/screen_drawer.dart';

class MainSplashScreen extends StatelessWidget{
  const MainSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/icon/intro_logo.png',
      nextScreen: const DrawerScreen(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.deepPurple.shade500,
      splashIconSize: 200,
      duration: 2500,
    );
  }
}