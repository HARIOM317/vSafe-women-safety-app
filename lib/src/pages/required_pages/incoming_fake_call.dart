import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/pages/navbar_pages/fake_call_screen.dart';
import 'package:vsafe/src/pages/required_pages/fake_call.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';

class IncomingFakeCall extends StatefulWidget {
  const IncomingFakeCall({super.key});


  @override
  State<IncomingFakeCall> createState() => _IncomingFakeCallState();
}

class _IncomingFakeCallState extends State<IncomingFakeCall> {
  final player = AudioPlayer();
  bool _isAttendCall = false;

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  final Color _backgroundColor = const Color(0xff0d202c);
  String fakeContactNumber = "";
  String fakeContactName = "";
  String fakeContactAvatar = "";

  void _start() {
    setState(() {
      fakeContactNumber = contactNumber;
      fakeContactName = contactName;
      fakeContactAvatar = contactAvatar;
    });
  }

  void _ring() async {
    await player.play(AssetSource('audio/caller_tune.mp3'));
  }

  void _stopRing() {
    player.stop();
  }

  @override
  void initState() {
    super.initState();


    setState(() {
      _start();
      _ring();
    });

    Timer(const Duration(seconds: 23), (){
      if(!_isAttendCall){
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
          backgroundColor: _backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xffd4d4d4),
                      backgroundImage: AssetImage(fakeContactAvatar),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      fakeContactName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'PTSans-Regular'),
                    ),

                    Text(
                      fakeContactNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: FittedBox(
                            child: FloatingActionButton(
                              heroTag: 'btn1',
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              onPressed: () {
                                _stopRing();
                                _isAttendCall = false;
                                Navigator.of(context).pop();
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(
                                Icons.call_end,
                                size: 42,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text("Decline", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                    ],
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: FittedBox(
                            child: FloatingActionButton(
                              heroTag: 'btn2',
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              onPressed: () {
                                _stopRing();
                                _isAttendCall = true;
                                Navigator.push(context, CustomPageRouteDirection(child: const FakeCall(), direction: AxisDirection.left));
                              },
                              backgroundColor: Colors.green,
                              child: const Icon(
                                Icons.call,
                                size: 42,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text("Accept", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
