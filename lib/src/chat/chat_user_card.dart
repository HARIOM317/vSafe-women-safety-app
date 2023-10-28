import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/chat/apis.dart';
import 'package:vsafe/src/chat/my_date_util.dart';
import 'package:vsafe/src/chat/profile_dialog.dart';
import 'package:vsafe/src/chat/user_chat_screen.dart';
import 'package:vsafe/src/model/user_message.dart';
import 'package:vsafe/src/model/user_model.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (If null -> no message)
  UserMessage? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      color: const Color(0xfff9efed),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            // Navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserMessage.fromJson(e.data())).toList() ??
                      [];

              if (list.isNotEmpty) {
                _message = list[0];
              }

              return ListTile(
                // user profile picture
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CircleAvatar(
                      radius: 25,
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.profilePic.toString(),
                        errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),
                ),

                // user name
                title: Text(widget.user.name.toString()),

                // last message
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? 'image'
                          : _message!.msg
                      : widget.user.about.toString(),
                  maxLines: 1,
                ),

                // last message time
                trailing: _message == null
                    ? null // show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ?
                        // show for unread message
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
                        // message sent time
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
