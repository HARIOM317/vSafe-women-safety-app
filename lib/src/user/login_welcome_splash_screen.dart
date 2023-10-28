import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/user/welcome_screen.dart';

class LoginWelcomeSplashScreen extends StatelessWidget{
  const LoginWelcomeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/intro_images/login_welcome.png',
      nextScreen: const WelcomeScreen(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: const Color(0xffb7a7ff),
      splashIconSize: 200,
      duration: 2500,
    );
  }
}