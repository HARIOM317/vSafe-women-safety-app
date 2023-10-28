import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationPage extends StatelessWidget{
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
              fontFamily: 'Dosis-Regular',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset("assets/animations/other_animations/no_notification.json", animate: true, width: 300),
            ),
            const Text("No Any New Notification!", style: TextStyle(fontSize: 20, color: Colors.black54),)
          ],
        ),
      )
    );
  }
}