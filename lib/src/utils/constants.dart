import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsafe/src/db/share_pref.dart';
import 'package:vsafe/src/user/login_screen.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';

Color primaryColor = const Color(0xff471aa0);

// function to show progress indicator
Widget progressIndicator(BuildContext context) {
  return const Center(
      child: CircularProgressIndicator(
          backgroundColor: Colors.indigo,
          color: Color(0xff2d3a82),
          strokeWidth: 4));
}

// function to show snackbar
void showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontFamily: "PTSans-Regular", fontSize: 16),
      ),
      backgroundColor: Colors.black.withOpacity(.9),
      behavior: SnackBarBehavior.floating));
}

// function to show an alert dialog box
showAlertDialogueBox(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.deepPurpleAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
            titlePadding: const EdgeInsets.all(25),
            titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'PTSans-Regular'),
            title: Text(
              msg,
              textAlign: TextAlign.center,
            ),
          ));
}

//  function to switch page
void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      CustomPageRouteDirection(
          child: nextScreen, direction: AxisDirection.left));
}

Widget introTextDesign1(String text,
    {double fontSize = 20.0, TextAlign alignment = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: 'Acme-Regular',
        fontSize: fontSize,
        color: Colors.black.withOpacity(0.5)),
    textAlign: alignment,
  );
}

// function to write heading
Widget writeHeading(String title) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans-Regular',
          color: Color(0xff010046),
        ),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

// function to write sub-heading
Widget writeSubHeading(String title) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontFamily: 'PTSans-Regular',
            color: Colors.black,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

// function to write description
Widget writeDescription(String text) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            fontFamily: 'PTSans-Regular',
            fontSize: 15,
            color: Color(0xff383838)),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}

// function to redirect on gmail for feedback
openEmail() async {
  String email = Uri.encodeComponent("community.vsafe@gmail.com");
  String subject = Uri.encodeComponent("Request for vSafe community feedback");
  String body = Uri.encodeComponent("Dear vSafe community, \n\n");
  Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
  if (await launchUrl(mail)) {
    //email app opened
  } else {
    Fluttertoast.showToast(msg: "Something went wrong");
  }
}

// function to sign out
signOut(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          shadowColor: Colors.deepPurple.withOpacity(0.25),
          backgroundColor: Colors.deepPurple[100],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Color(0xff6a1010),
                  size: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sign out",
                  style: TextStyle(color: Color(0xff6a1010)),
                ),
              )
            ],
          ),
          content: const Text("Do you really want to sign out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.green[900]),
                )),
            TextButton(
                onPressed: () async {
                  logoutUser();
                  Navigator.pushReplacement(
                      context, CustomPageRoute(child: const LoginScreen()));
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Color(0xff6a1010)),
                ))
          ],
        );
      });
}
