import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vsafe/src/db/db_services.dart';
import 'package:vsafe/src/model/contact_model.dart';

class Situation extends StatefulWidget {
  const Situation({super.key});

  @override
  State<Situation> createState() => _SituationState();
}

class _SituationState extends State<Situation> {
  // variables for panic button
  double buttonRadius = 35;
  double shadowRadius = 30;
  Color shadowColor = Colors.white.withOpacity(0.5);
  Color buttonBG = Colors.white.withOpacity(0.5);
  Color iconColor = const Color(0xffcc1840);
  Color textColor = const Color(0xffcc1840);

  LocationPermission? locationPermission;

  String lat = "";
  String long = "";

  // function for direct calling to police
  _callToPolice() async{
    await FlutterPhoneDirectCaller.callNumber("100");
  }

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  }

  _getLatLong() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position.longitude.toString();
    lat = position.latitude.toString();
  }

  _getCurrentLocation() async {
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Location permission permanently denied!");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatLong();
    _getPermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        children: [
          // Todo: Panic situation
          Center(
            child: Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 5, right: 5, top: 2.5, bottom: 2.5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.withOpacity(0.5),
                      Colors.indigoAccent.withOpacity(0.7)
                    ]),
                border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(1.5, 2),
                      color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Panic Situation",
                    style: TextStyle(
                        fontFamily: 'Courgette-Regular',
                        color: Colors.white,
                        fontSize: 18),
                  ),

                  // Panic Button
                  GestureDetector(
                    onTap: () {
                      _getLatLong();
                      _getCurrentLocation();

                      setState(() {
                        buttonRadius = 40;
                        buttonBG = const Color(0xffff5722);
                        iconColor = Colors.white;
                        textColor = Colors.white;
                        shadowColor = Colors.deepOrange.withOpacity(0.5);
                        shadowRadius = 50;
                      });

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: AlertDialog(
                                elevation: 20,
                                shadowColor: Colors.deepPurple.withOpacity(0.5),
                                backgroundColor: Colors.deepPurple[100],
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0))),
                                title: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.emergency_share,
                                        color: Color(0xff6a1010),
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Are you in Danger?",
                                        style:
                                            TextStyle(color: Color(0xff6a1010), fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                content: const Text(
                                    "Do you really want to send an alert SOS message to all trusted contacts?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          buttonRadius = 35;
                                          shadowRadius = 30;
                                          shadowColor =
                                              Colors.white.withOpacity(0.5);
                                          buttonBG =
                                              Colors.white.withOpacity(0.5);
                                          iconColor = const Color(0xffcc1840);
                                          textColor = const Color(0xffcc1840);
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                        style:
                                            TextStyle(color: Colors.green[900]),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);

                                        await Future.delayed(const Duration(milliseconds: 2000));
                                        List<TContactModel> contactList =
                                            await DataBaseHelper()
                                                .getContactList();
                                        String messageBody =  "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
                                        String msg = "";

                                        if(lat == "" || long == ""){
                                          msg = "I am in danger and need your help! Please try to reach me as soon as possible.";
                                        } else {
                                          msg = "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody";
                                        }

                                        if (await _isPermissionGranted()) {
                                          for (var element in contactList) {
                                            _sendSMS(element.number, msg, simSlot: 1);
                                          }
                                          _callToPolice();
                                          Fluttertoast.showToast(
                                              msg:
                                                  "SOS alert sent successfully!");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Unable to fetch location!");
                                        }
                                        setState(() {
                                          buttonRadius = 35;
                                          shadowRadius = 30;
                                          shadowColor =
                                              Colors.white.withOpacity(0.5);
                                          buttonBG =
                                              Colors.white.withOpacity(0.5);
                                          iconColor = const Color(0xffcc1840);
                                          textColor = const Color(0xffcc1840);
                                        });
                                      },
                                      child: const Text(
                                        "Send",
                                        style:
                                            TextStyle(color: Color(0xff6a1010)),
                                      ))
                                ],
                              ),
                            );
                          });
                    },
                    onLongPress: () {
                      _getLatLong();
                      _getCurrentLocation();

                      setState(() {
                        buttonRadius = 40;
                        buttonBG = const Color(0xffff5722);
                        iconColor = Colors.white;
                        textColor = Colors.white;
                        shadowColor = Colors.deepOrange.withOpacity(0.5);
                        shadowRadius = 50;
                      });

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: AlertDialog(
                                elevation: 20,
                                shadowColor: Colors.deepPurple.withOpacity(0.5),
                                backgroundColor: Colors.deepPurple[100],
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                title: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.emergency_share,
                                        color: Color(0xff6a1010),
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Are you in Danger?",
                                        style:
                                            TextStyle(color: Color(0xff6a1010)),
                                      ),
                                    )
                                  ],
                                ),
                                content: const Text(
                                    "Do you really want to send an alert SOS message to all trusted contacts?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          buttonRadius = 35;
                                          shadowRadius = 30;
                                          shadowColor =
                                              Colors.white.withOpacity(0.5);
                                          buttonBG =
                                              Colors.white.withOpacity(0.5);
                                          iconColor = const Color(0xffcc1840);
                                          textColor = const Color(0xffcc1840);
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                        style:
                                            TextStyle(color: Colors.green[900]),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                        await Future.delayed(const Duration(milliseconds: 2000));

                                        List<TContactModel> contactList =
                                            await DataBaseHelper()
                                                .getContactList();
                                        String messageBody =
                                            "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";

                                        String msg = "";

                                        if(lat == "" || long == ""){
                                          msg = "I am in danger and need your help! Please try to reach me as soon as possible.";
                                        } else {
                                          msg = "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody";
                                        }

                                        if (await _isPermissionGranted()) {
                                          for (var element in contactList) {
                                            _sendSMS(element.number, msg, simSlot: 1);
                                          }
                                          _callToPolice();
                                          Fluttertoast.showToast(
                                              msg:
                                                  "SOS alert sent successfully!");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Unable to fetch location!");
                                        }
                                        setState(() {
                                          buttonRadius = 35;
                                          shadowRadius = 30;
                                          shadowColor =
                                              Colors.white.withOpacity(0.5);
                                          buttonBG =
                                              Colors.white.withOpacity(0.5);
                                          iconColor = const Color(0xffcc1840);
                                          textColor = const Color(0xffcc1840);
                                        });
                                      },
                                      child: const Text(
                                        "Send",
                                        style:
                                            TextStyle(color: Color(0xff6a1010)),
                                      ))
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: shadowRadius,
                                // blurRadius: 50,
                                offset: const Offset(0, 2),
                                color: shadowColor
                                // color: Colors.deepOrange.withOpacity(0.5)
                                )
                          ]),
                      child: CircleAvatar(
                        radius: buttonRadius,
                        // radius: 40,
                        backgroundColor: buttonBG,
                        // backgroundColor: Colors.deepOrange[500],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emergency_share_sharp,
                              color: iconColor,
                              // color: Colors.white,
                            ),
                            Text(
                              "SOS",
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'NovaSlim-Regular',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Todo: Feel Unsafe situation
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 5, right: 5, top: 2.5, bottom: 2.5),
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigoAccent.withOpacity(0.7),
                      Colors.deepPurple.withOpacity(0.5)
                    ]),
                border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(1.5, 2),
                      color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Feel Unsafe',
                      style: TextStyle(
                          fontFamily: 'Courgette-Regular',
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Record Surrounding Button
                      InkWell(
                        onTap: () async {
                          String messageBody =
                              "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
                          String msg = "";

                          if(lat == "" || long == ""){
                            msg = "I am feeling unsafe in this area!";
                          } else {
                            msg = "I am feeling unsafe in this area!\n\nArea location is 👇🏼👇🏼👇🏼\n$messageBody";
                          }

                          final picker = ImagePicker();

                          final pickedFile = await picker.pickVideo(
                              source: ImageSource.camera,
                              maxDuration: const Duration(minutes: 10));
                          XFile? video = pickedFile;

                          if (video == null) return;
                          await Share.shareXFiles([video],
                              text: msg);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 62,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 15,
                                          offset: const Offset(0, 2),
                                          color: Colors.white.withOpacity(0.5))
                                    ]),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.video,
                                      color: Color(0xff003c6b),
                                      size: 20,
                                    ),
                                    Text(
                                      "Record Surrounding",
                                      style: TextStyle(
                                          color: Color(0xff003c6b),
                                          fontFamily: 'PTSans-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Capture Surrounding Button
                      InkWell(
                        onTap: () async {
                          String messageBody = "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
                          String msg = "";

                          if(lat == "" || long == ""){
                            msg = "I am feeling unsafe in this area!";
                          } else {
                            msg = "I am feeling unsafe in this area!\n\nArea location is 👇🏼👇🏼👇🏼\n$messageBody";
                          }

                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          XFile? capturedImage = image;

                          if (capturedImage == null) return;
                          await Share.shareXFiles([capturedImage],
                              text: msg);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 62,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 15,
                                          offset: const Offset(0, 2),
                                          color: Colors.white.withOpacity(0.5))
                                    ]),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.image,
                                      color: Color(0xff003c6b),
                                      size: 20,
                                    ),
                                    Text(
                                      "Capture Surrounding",
                                      style: TextStyle(
                                          color: Color(0xff003c6b),
                                          fontFamily: 'PTSans-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
