import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/chat/my_date_util.dart';
import 'package:vsafe/src/model/user_model.dart';

// ViewProfileScreen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final UserModel user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffe9e8),

        // joining date
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined on: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  fontFamily: "PTSans-Regular"
                ),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt.toString(),
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 16, fontFamily: "PTSans-Regular")),
            ],
          ),
        ),

        // body
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
                ),
                child: Column(
                  children: [
                    // for adding some space
                    const SizedBox(height: 50),

                    // back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            CupertinoIcons.back,
                            color: Color(0xfffff3f3),
                            size: 30,
                          )),
                    ),

                    // for adding some space
                    const SizedBox(width: 30, height: 30),

                    // user profile picture
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(width: 3, color: Colors.white)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 70,
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.profilePic.toString(),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(
                              CupertinoIcons.person_alt,
                              size: 100,
                            )),
                          ),
                        ),
                      ),
                    ),

                    // for adding some space
                    const SizedBox(height: 10),

                    // user name label
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(widget.user.name.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: "PTSans-Regular")),
                    ),

                    // user email label
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(widget.user.email.toString(),
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: "PTSans-Regular")),
                    ),

                    // for adding some space
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // for adding some space
              const SizedBox(height: 30),

              //user about
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: "PTSans-Regular"),
                    ),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 0.5,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(25)
                            )),
                        color: const Color(0xfffff3f3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 30.0),
                          child: Text(widget.user.about.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "PTSans-Regular")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
