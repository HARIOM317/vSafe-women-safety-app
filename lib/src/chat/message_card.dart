// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vsafe/src/chat/apis.dart';
import 'package:vsafe/src/chat/my_date_util.dart';
import 'package:vsafe/src/model/user_message.dart';
import 'package:vsafe/src/utils/constants.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final UserMessage message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _sendMessage() : _receiveMessage(),
    );
  }

  // sender or another user message
  Widget _receiveMessage() {
    // update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message content
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: widget.message.type == Type.image ? 3.0 : 15.0,
                vertical: widget.message.type == Type.image ? 10.0 : 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
                color: Color(0xff1b2a51),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: widget.message.type == Type.text
                ?
                // show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                :
                // show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        // message time
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        )
      ],
    );
  }

  // our or user message
  Widget _sendMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message time
        Row(
          children: [
            // for adding some space
            const SizedBox(
              width: 12,
            ),

            // double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            // for adding some space
            const SizedBox(
              width: 5,
            ),

            // sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),

        // message content
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: widget.message.type == Type.image ? 3.0 : 15.0,
                vertical: widget.message.type == Type.image ? 10.0 : 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
                color: Color(0xff311740),
                gradient: RadialGradient(
                    radius: 5,
                    colors: <Color>[Color(0xff471d61), Color(0xff311740)]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25))),
            child: widget.message.type == Type.text
                ?
                // show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                :
                // show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ? // Copy text option
                  _OptionItem(
                      icon: const Icon(Icons.copy, color: Colors.deepPurple),
                      name: "Copy Text",
                      onTap: () async {
                        try {
                          await Clipboard.setData(
                                  ClipboardData(text: widget.message.msg))
                              .then((value) {
                            // for hiding bottom sheet
                            Navigator.pop(context);
                            showSnackbar(context, "Message Copied!");
                          });
                        } catch (e) {
                          Navigator.pop(context);
                          showSnackbar(context, "Something went wrong!");
                        }
                      })
                  : // Download image option
                  _OptionItem(
                      icon:
                          const Icon(Icons.download, color: Colors.deepPurple),
                      name: "Save Image",
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: "vSafe Images")
                              .then((success) {
                            // for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              showSnackbar(
                                  context, "Image Successfully Saved!");
                            }
                          });
                        } catch (e) {
                          showSnackbar(context, "Something went wrong!");
                        }
                      }),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),

              // delete option
              if (isMe)
                widget.message.type == Type.text
                    ? _OptionItem(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        name: "Delete Message",
                        onTap: () async {
                          await APIs.deleteMessage(widget.message)
                              .then((value) {
                            // for hiding bottom sheet
                            Navigator.pop(context);
                            showSnackbar(
                                context, "Message deleted successfully!");
                          });
                        })
                    : _OptionItem(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        name: "Delete Image",
                        onTap: () async {
                          await APIs.deleteMessage(widget.message)
                              .then((value) {
                            // for hiding bottom sheet
                            Navigator.pop(context);
                            showSnackbar(
                                context, "Image deleted successfully!");
                          });
                        }),

              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.of(context).size.width * 0.04,
                indent: MediaQuery.of(context).size.width * 0.04,
              ),

              // sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye,
                      color: Colors.deepPurple),
                  name:
                      "Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}",
                  onTap: () {}),

              // read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not read yet'
                      : "Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}",
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff36464e),
                  fontFamily: "TSans-Regular",
                  letterSpacing: 0.5),
            )),
          ],
        ),
      ),
    );
  }
}
