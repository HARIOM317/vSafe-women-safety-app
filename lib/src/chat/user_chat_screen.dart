import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsafe/src/chat/apis.dart';
import 'package:vsafe/src/chat/message_card.dart';
import 'package:vsafe/src/chat/my_date_util.dart';
import 'package:vsafe/src/chat/view_profile_screen.dart';
import 'package:vsafe/src/model/user_message.dart';
import 'package:vsafe/src/model/user_model.dart';

class UserChatScreen extends StatefulWidget {
  final UserModel user;

  const UserChatScreen({super.key, required this.user});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  // for storing all messages
  List<UserMessage> _list = [];

  // for handling message text changes
  final _textController = TextEditingController();

  // _showEmoji : for storing value of showing or hiding emoji
  // _isUploading : for checking if image is uploading or not
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          // appbar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            flexibleSpace: _appBar(),
          ),

          backgroundColor: const Color(0xffffedeb),

          // body
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // If data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      // If some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => UserMessage.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Say Hii! 👋",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blueGrey.withOpacity(0.75),
                                      fontFamily: "PTSans-Regular"),
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ),

              // progress indicator for showing uploading
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )),

              // chat input field
              _chatInput(),

              // show emoji on keyboard emoji button click & vice versa
              if (_showEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      recentsLimit: 45,
                      bgColor: const Color(0xffe9eaee),
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // appbar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
        ),
        child: SafeArea(
            child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),

                // user profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    radius: 18,
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      imageUrl: list.isNotEmpty
                          ? list[0].profilePic.toString()
                          : widget.user.profilePic.toString(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),

                // for adding some space
                const SizedBox(
                  width: 10,
                ),

                // user name and last seen time
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // user name
                    Text(
                      list.isNotEmpty
                          ? list[0].name.toString()
                          : widget.user.name.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),

                    // last seen time of user
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline!
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive.toString())
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive.toString()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    )
                  ],
                )
              ],
            );
          },
        )),
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // emoji button
                  IconButton(
                    alignment: Alignment.bottomLeft,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await Future.delayed(const Duration(milliseconds: 300));
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.orange,
                      )),

                  // text field for type message
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.45,
                      maxWidth: MediaQuery.of(context).size.width * 0.55,
                      minHeight: MediaQuery.of(context).size.height * 0.05,
                      maxHeight: MediaQuery.of(context).size.height * 0.20,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines:
                            null, // it will automatically adjust input line

                        onTap: () {
                          if (_showEmoji) {
                            setState(() => _showEmoji = !_showEmoji);
                          }
                        },

                        style: const TextStyle(
                            height: 1.25, fontFamily: "PTSans-Regular"),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                      alignment: Alignment.bottomRight,
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => bottomSheet());
                      },
                      icon: const Icon(Icons.attachment_outlined)),
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            onPressed: () {
              bool blank = _textController.text.trim().isEmpty;
              if (_textController.text.isNotEmpty && blank != true) {
                if (_list.isEmpty) {
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            shape: const CircleBorder(),
            minWidth: 0,
            color: Colors.deepPurple[900],
            child: const Icon(
              Icons.send_rounded,
              size: 28,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  bottomSheet() {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // take image from camera
            attachIcon(Icons.camera_alt, "Camera", () async {
              Navigator.pop(context);
              final ImagePicker picker = ImagePicker();

              // Pick an image
              final XFile? image = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 50);

              if (image != null) {
                setState(() => _isUploading = true);
                await APIs.sendChatImage(widget.user, File(image.path));
                setState(() => _isUploading = false);
              }
            }, Colors.pink),

            // pick image from gallery button
            attachIcon(Icons.image, "Gallery", () async {
              Navigator.pop(context);
              final ImagePicker picker = ImagePicker();

              // Pick multiple images
              final List<XFile> images =
                  await picker.pickMultiImage(imageQuality: 50);

              // uploading and sending images one by one
              for (var i in images) {
                setState(() => _isUploading = true);
                await APIs.sendChatImage(widget.user, File(i.path));
                setState(() => _isUploading = false);
              }
            }, Colors.green),
          ],
        ),
      ),
    );
  }

  attachIcon(IconData icon, String name, VoidCallback onTap, Color bgColor) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: bgColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          Text(name)
        ],
      ),
    );
  }
}
