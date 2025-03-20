import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vsafe/src/db/db_services.dart';
import 'package:vsafe/src/model/contact_model.dart';
import 'package:vsafe/src/pages/required_pages/contact_screen.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/widgets/drawer_widgets/screen_drawer.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  // Position? _currentPosition;
  LocationPermission? permission;

  _getPermission() async => await Permission.sms.request();
  _isPermissionGranted() async => await Permission.sms.isGranted;

  Future<void> _handleRefresh() async {
    // reloading takes some time
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
    return await Future.delayed(const Duration(seconds: 2));
  }

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<TContactModel>? contactList;
  int count = 0;

  String lat = "";
  String long = "";

  _getLatLong() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position.longitude.toString();
    lat = position.latitude.toString();
  }

  // _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
            phoneNumber: phoneNumber, message: message, simSlot: simSlot)
        .then((SmsStatus status) {});
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "permission permanently denied");
      }
    }

    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .catchError((e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return e;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getPermission();
    _getLatLong();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
  }

  void showList() {
    Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContactModel>> contactListFuture =
          dataBaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
    });
  }

  void deleteContact(TContactModel contact) async {
    int result = await dataBaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact removed from trusted contact list");
      showList();
    }
  }

  @override
  Widget build(BuildContext context) {
    contactList ??= [];

    return WillPopScope(
      onWillPop: _onPop,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff9eae9),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    bool result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ContactScreen();
                    }));

                    if (result == true) {
                      showList();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Trusted Contacts"),
                ),
              ),
              Expanded(
                child: LiquidPullToRefresh(
                  onRefresh: _handleRefresh,
                  color: Colors.transparent,
                  backgroundColor: Colors.deepPurple,
                  height: 300,
                  animSpeedFactor: 3,
                  showChildOpacityTransition: true,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onLongPress: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 10,
                                      shadowColor:
                                          Colors.deepPurple.withOpacity(0.25),
                                      backgroundColor: Colors.deepPurple[100],
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      title: const Text('Remove Contact'),
                                      content: const Text(
                                          'Remove contact from trusted contact list'),
                                      actions: <Widget>[
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              foregroundColor:
                                                  Colors.deepPurple[900],
                                            ),
                                            child: const Text("Cancel")),
                                        ElevatedButton(
                                          onPressed: () async {
                                            deleteContact(contactList![index]);
                                            Navigator.of(context).pop(false);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[300],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: const Text("Remove"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Card(
                              elevation: 3.5,
                              color: const Color(0xfff5efff),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      color: Colors.grey, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: ((context) {
                                          deleteContact(contactList![index]);
                                        }),
                                        icon: Icons.delete,
                                        foregroundColor: Colors.red[900],
                                        backgroundColor:
                                            const Color(0xfff5efff),
                                      )
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(contactList![index].name),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Center(
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(
                                                        contactList![index]
                                                            .number);
                                              },
                                              icon: Icon(
                                                Icons.call,
                                                color: Colors.green[900],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _getLatLong();

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        elevation: 20,
                                                        shadowColor: Colors
                                                            .deepPurple
                                                            .withOpacity(0.5),
                                                        backgroundColor: Colors
                                                            .deepPurple[100],
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0))),
                                                        title: const Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .emergency_share,
                                                                color: Color(
                                                                    0xff6a1010),
                                                                size: 30,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Are you in Trouble?",
                                                                style: TextStyle(
                                                                    color: Color(0xff6a1010), fontSize: 20, fontWeight: FontWeight.bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        content: Text(
                                                            "Do you really want to send an alert SOS message on ${contactList![index].number} ?"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .green[
                                                                        900]),
                                                              )),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);

                                                                const Duration(
                                                                    milliseconds:
                                                                        2000);
                                                                String
                                                                    messageBody =
                                                                    "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";

                                                                String msg = "";

                                                                if (lat == "" ||
                                                                    long ==
                                                                        "") {
                                                                  msg =
                                                                      "I am in danger and need your help! Please try to reach me as soon as possible.";
                                                                } else {
                                                                  msg =
                                                                      "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody";
                                                                }

                                                                if (await _isPermissionGranted()) {
                                                                  _sendSMS(
                                                                      contactList![
                                                                              index]
                                                                          .number,
                                                                      msg,
                                                                      simSlot:
                                                                          1);

                                                                  await FlutterPhoneDirectCaller
                                                                      .callNumber(
                                                                          "100");

                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "message sent successfully");
                                                                } else {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Unable to fetch current location!");
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Send",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff6a1010)),
                                                              ))
                                                        ],
                                                      );
                                                    });
                                              },
                                              icon: Icon(
                                                CupertinoIcons
                                                    .chat_bubble_text_fill,
                                                color: Colors.blue[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
