import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/pages/navbar_pages/fake_call_screen.dart';

class FakeCall extends StatefulWidget {
  const FakeCall({super.key});


  @override
  State<FakeCall> createState() => _FakeCallState();
}

class _FakeCallState extends State<FakeCall> {
  final player = AudioPlayer();

  final Color _backgroundColor = const Color(0xff0d202c);
  String fakeContactNumber = "";
  String fakeContactName = "";
  String fakeContactAvatar = "";

  int seconds = 0, minutes = 0;
  String digitSeconds = "00", digitMinutes = "00";
  bool startCall = false;

  Timer? timer;

  void startCalling(){
    startCall = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSecond = seconds + 1;
      int localMinutes = minutes;

      if(localSecond > 59){
        localMinutes++;
        localSecond = 0;
      }

      setState(() {
        seconds = localSecond;
        minutes = localMinutes;

        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });

    });
  }

  void stopCalling(){
    timer?.cancel();
    setState(() {
      startCall = false;
    });
  }

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  void _start() {
    setState(() {
      fakeContactNumber = contactNumber;
      fakeContactName = contactName;
      fakeContactAvatar = contactAvatar;
    });
  }


  @override
  void initState() {
    super.initState();

    setState(() {
      _start();
      startCalling();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
          backgroundColor: _backgroundColor,
          body: Column(
            // physics: const NeverScrollableScrollPhysics(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),

              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xffd4d4d4),
                  backgroundImage: AssetImage(fakeContactAvatar),
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$digitMinutes:$digitSeconds", style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.record_voice_over,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Record", style: TextStyle(color: Colors.white),)
                    ],
                  ),

                  Column(
                    children: [
                      Icon(
                        Icons.video_call,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Video", style: TextStyle(color: Colors.white))
                    ],
                  ),

                  Column(
                    children: [
                      Icon(
                        Icons.add_call,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Add call", style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.speaker_phone,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Speaker", style: TextStyle(color: Colors.white),)
                    ],
                  ),

                  Column(
                    children: [
                      Icon(
                        Icons.mic_off,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Mute", style: TextStyle(color: Colors.white))
                    ],
                  ),

                  Column(
                    children: [
                      Icon(
                        Icons.dialpad,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text("Dialpad", style: TextStyle(color: Colors.white))
                    ],
                  )

                ],
              ),

              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    stopCalling();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const SizedBox(
                    width: 70,
                    height: 70,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: null,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.call_end,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
