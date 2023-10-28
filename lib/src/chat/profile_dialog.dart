import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/chat/user_chat_screen.dart';
import 'package:vsafe/src/chat/view_profile_screen.dart';
import 'package:vsafe/src/model/user_model.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.48,
        child: Stack(
          children: [


            // User profile picture
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
                imageUrl: user.profilePic.toString(),
                errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(
                  CupertinoIcons.person_alt,
                  size: 150,
                )),
              ),
            ),

            // User name
            Positioned(
              left: MediaQuery.of(context).size.width * 0.14,
              top: MediaQuery.of(context).size.height * 0.02,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(user.name.toString(), style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "PTSans-Regular",
                  fontWeight: FontWeight.bold,
              ),
              ),
            ),

            // User info button
            Positioned(
              left: 3,
              top: 6,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, CustomPageRouteDirection(child: ViewProfileScreen(user: user), direction: AxisDirection.down));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                minWidth: 0,
                child: const Icon(Icons.info_outline, size: 25, color: Colors.deepPurple,),
              ),
            ),

            // User chat button
            Positioned(
              right: 3,
              top: 6,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, CupertinoPageRoute(builder: (_) => UserChatScreen(user: user)));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                minWidth: 0,
                child: const Icon(Icons.chat, size: 25, color: Colors.deepPurple,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
