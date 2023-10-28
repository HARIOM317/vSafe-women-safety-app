import 'package:flutter/material.dart';
import 'package:vsafe/src/utils/constants.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget{
  final String title;
  final Function onPressed;
  bool loading;

  PrimaryButton({super.key, required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        ),
        child: Text(title, style: const TextStyle(
          fontFamily: 'PTSans-Regular',
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
        ),
      ),
    );
  }
}