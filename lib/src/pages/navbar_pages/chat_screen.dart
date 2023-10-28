import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:vsafe/src/chat/apis.dart';
import 'package:vsafe/src/model/user_model.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/widgets/drawer_widgets/screen_drawer.dart';
import '../../chat/chat_user_card.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});
  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  // for storing all users
  List<UserModel> _list = [];
  // for storing searched item
  final List<UserModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  @override
  void initState() {
    super.initState();

    // for updating user active status according to lifecycle events
    // resume -> active or online
    // pause -> inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPop,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xfff9eae9),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(Icons.chat),
              ),
              body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: true,
                        title: _isSearching
                            ? TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search"),
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            // Search logic
                            _searchList.clear();

                            for (var i in _list) {
                              if (i.name
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                                  i.email
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) {
                                _searchList.add(i);
                              }
                              setState(() {
                                _searchList;
                              });
                            }
                          },
                        )
                            : const Text(""),
                        elevation: 1,
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        actions: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                });
                              },
                              icon: Icon(
                                _isSearching
                                    ? CupertinoIcons.clear_circled_solid
                                    : Icons.search,
                                color: Colors.black,
                              )),
                        ],
                      )
                    ];
                  },

                  // message screen body
                  body: StreamBuilder(
                    stream: APIs.getMyUserId(),

                    // get id of only known users
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      // If data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );

                      // If some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:

                          return StreamBuilder(
                            stream: APIs.getAllUsers(
                                snapshot.data?.docs.map((e) => e.id).toList() ??
                                    []),

                            // get only those user, who's ids are provided
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                              // If data is loading
                                case ConnectionState.waiting:
                                case ConnectionState.none:

                                // If some or all data is loaded then show it
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  _list = data
                                      ?.map((e) =>
                                      UserModel.fromJson(e.data()))
                                      .toList() ??
                                      [];

                                  if (_list.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(
                                          user: _isSearching
                                              ? _searchList[index]
                                              : _list[index],
                                        );
                                        // return Text("Name: ${list[index]}");
                                      },
                                    );
                                  } else {
                                    return Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Lottie.asset(
                                              "assets/animations/other_animations/no_data_found.json",
                                              animate: true,
                                              width: 200),
                                        ),
                                        const Center(
                                          child: Text(
                                            "No Contact Found!",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              }
                            },
                          );
                      }
                    },
                  ))),
        ));
  }

  // for adding user in chat list
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          // title
          title: const Row(
            children: [
              Icon(
                Icons.person_add,
                color: Colors.deepPurple,
                size: 28,
              ),
              Text("  Add User")
            ],
          ),

          // content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: "Email or Phone",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),

          // actions
          actions: [
            // Cancel button
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.deepPurple, fontSize: 16),
              ),
            ),

            // add button
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                if (email.isNotEmpty) {
                  await APIs.addChatUser(email).then((value) {
                    if (!value) {
                      showSnackbar(context, "User does not exist!");
                    }
                  });
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.deepPurple, fontSize: 16),
              ),
            )
          ],
        ));
  }
}
