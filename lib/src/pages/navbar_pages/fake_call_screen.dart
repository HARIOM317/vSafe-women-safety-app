import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/pages/required_pages/incoming_fake_call.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';
import 'package:vsafe/src/widgets/drawer_widgets/screen_drawer.dart';

String contactName = "";
String contactAvatar = "";
String contactNumber = "";

class FakeCallScreen extends StatefulWidget{
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  String fakeCallContactName = "Police";
  String fakeCallContactAvatar = "assets/images/fake_call/unknown.jpg";
  String fakeCallContactNumber = "100";

  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  // function to create section heading
  Widget sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rajdhani-Regular',
            color: Colors.black54),
      ),
    );
  }

  // function to create preset contact with avatar
  Widget createPresetContactWithAvatar(String name, String imagePath, String number) {
    return GestureDetector(
      onTap: (){
        setState(() {
          fakeCallContactName = name;
          fakeCallContactAvatar = imagePath;
          fakeCallContactNumber = number;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:  [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xffe5ffff),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xffd4d4d4),
                backgroundImage: AssetImage(imagePath),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(name, style: const TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,

      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff9eae9),
          ),

          child: ListView(
            children: [
              sectionHeading("Presets"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    createPresetContactWithAvatar("Police", "assets/images/fake_call/unknown.jpg", "100"),
                    createPresetContactWithAvatar("Brother", "assets/images/fake_call/brother.jpg", "9800166512"),
                    createPresetContactWithAvatar("Friend", "assets/images/fake_call/friend.jpg", "9200667890"),
                    createPresetContactWithAvatar("Mom", "assets/images/fake_call/mom.jpg", "6263870098"),
                    createPresetContactWithAvatar("Dad", "assets/images/fake_call/papa.jpg", "8823086555"),
                    createPresetContactWithAvatar("Sister", "assets/images/fake_call/sister.jpg", "6688451209"),
                    createPresetContactWithAvatar("Husband", "assets/images/fake_call/husband.jpg", "8855689812"),
                    createPresetContactWithAvatar("Uncle", "assets/images/fake_call/uncle.jpg", "9302566783"),
                    createPresetContactWithAvatar("Relative", "assets/images/fake_call/relative.jpg", "8765230098"),
                    createPresetContactWithAvatar("Unknown", "assets/images/fake_call/unknown.jpg", "8223826656")
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3.5,
                  color: const Color(0xfff5efff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey, width: 1)),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Caller Details", textAlign: TextAlign.left,),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 57,
                                  backgroundColor: const Color(0xffd4d4d4),
                                    backgroundImage: AssetImage(fakeCallContactAvatar),
                                ),
                              ),
                            ),

                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: Text(fakeCallContactName, style: const TextStyle(fontSize: 24, color: Colors.black, fontFamily: "PTSans-Regular"),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: Text(fakeCallContactNumber, style: const TextStyle(fontSize: 18, color: Colors.black54)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              DropShadow(
                blurRadius: 10,
                color: Colors.black26.withOpacity(0.4),
                offset: const Offset(0, 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  height: 60,
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      contactName = fakeCallContactName;
                      contactNumber = fakeCallContactNumber;
                      contactAvatar = fakeCallContactAvatar;
                      Navigator.push(context, CustomPageRouteDirection(child: const IncomingFakeCall(), direction: AxisDirection.right));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Call", style: TextStyle(
                        fontFamily: 'PTSans-Regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}