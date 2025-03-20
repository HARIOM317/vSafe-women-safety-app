import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:vsafe/src/components/custom_textfield.dart';
import 'package:vsafe/src/components/primary_button.dart';
import 'package:vsafe/src/utils/constants.dart';

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  String? id;
  TextEditingController nameController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isSaving = false;

  Future<void> _handleRefresh() async {
    // reloading takes some time
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        getUserName();
      });
    });
    return await Future.delayed(const Duration(seconds: 2));
  }

  // function to get user name from database
  getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      nameController.text = value.docs.first['name'];
      id = value.docs.first.id;
    });
  }

  saveFeedback() async {
    setState(() {
      isSaving = true;
    });

    await FirebaseFirestore.instance.collection('feedbacks').add({
      'user': nameController.text,
      'feedback': feedbackController.text,
      'location': locationController.text
    }).then((value) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: "Feedback submitted successfully!");
      });
    });
  }

  showReviewDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            title: const Text(
              "Feedback Form",
              textAlign: TextAlign.center,
            ),
            content: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      enabled: false,
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: nameController.text,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'PTSans-Regular',
                          color: Colors.deepPurple),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: LoginTextField(
                        controller: locationController,
                        hintText: "Enter Location",
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: LoginTextField(
                        controller: feedbackController,
                        hintText: "Write Your Feedback",
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              PrimaryButton(
                  title: "Submit",
                  onPressed: () {
                    if (feedbackController.text.length < 5) {
                      Fluttertoast.showToast(
                          msg: "Feedback should be at least 4 characters!");
                    } else if (locationController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Area name is required!");
                    } else {
                      saveFeedback();
                      Navigator.pop(context);
                    }
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving == true
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xfff9d2cf).withOpacity(0.5),
              ),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.deepPurple,
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
              )),
            )
          : Container(
              decoration: BoxDecoration(
                color: const Color(0xfff9d2cf).withOpacity(0.5),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "User's Feedback",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('feedbacks')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                            backgroundColor:
                                Colors.deepPurpleAccent.withOpacity(0.5),
                          ));
                        }

                        return LiquidPullToRefresh(
                          onRefresh: _handleRefresh,
                          color: Colors.transparent,
                          backgroundColor: Colors.deepPurple,
                          height: 300,
                          animSpeedFactor: 3,
                          showChildOpacityTransition: true,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: ListTile(
                                    leading: SizedBox(
                                      height: 35,
                                      child: CircleAvatar(
                                        child: Text(
                                          "User",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 10,
                                              fontFamily:
                                                  "KaushanScript-Regular"),
                                        ),
                                      ),
                                    ),

                                    // title: Text(data['user'], style: const TextStyle(color: Color(0xff2a0077)),),
                                    subtitle: Text(data['feedback'],
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7))),
                                    title: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: "${data['user']}\n",
                                            style: const TextStyle(
                                                fontFamily: 'PTSans-Regular',
                                                color: Color(0xff2a0077),
                                                fontSize: 16)),
                                        TextSpan(
                                          text: "${data['location']}\n",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green[900]),
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          showReviewDialog(context);
                        },
                        elevation: 3,
                        icon: const Icon(
                          Icons.rate_review,
                          color: Colors.black87,
                        ),
                        label: const Text("Tell about your area",
                            style: TextStyle(fontFamily: "PTSans-Regular")),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
