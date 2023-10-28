import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:vsafe/src/pages/navbar_pages/add_contacts.dart';
import 'package:vsafe/src/pages/navbar_pages/fake_call_screen.dart';
import 'package:vsafe/src/pages/navbar_pages/home_screen.dart';
import 'package:vsafe/src/pages/navbar_pages/chat_screen.dart';
import 'package:vsafe/src/pages/navbar_pages/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  Icon homeIcon = const Icon(CupertinoIcons.house_fill, color: Colors.white);
  Icon chatIcon = const Icon(CupertinoIcons.chat_bubble_text, color: Colors.white);
  Icon contactIcon = const Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);
  Icon fakeCallIcon = const Icon(CupertinoIcons.phone, color: Colors.white,);
  Icon profileIcon = const Icon(CupertinoIcons.person, color: Colors.white);

  List<Widget> pages = [
    const HomeScreen(),
    const NetworkScreen(),
    const AddContactsScreen(),
    const FakeCallScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        backgroundColor: const Color(0xfff9eae9),
        buttonBackgroundColor: const Color(0xff4b51a8),
        color: Colors.indigoAccent,
        animationDuration: const Duration(milliseconds: 500),
        height: 70,
        animationCurve: Curves.easeOut,

        items: [
          CurvedNavigationBarItem(
              child: homeIcon,
              label: 'Home',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: chatIcon,
              label: 'Chat',
              labelStyle: const TextStyle(
                  color: Colors.white
              ),
              ),
          CurvedNavigationBarItem(
              child: contactIcon,
              label: 'Contact',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: fakeCallIcon,
              label: 'Fake Call',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: profileIcon,
              label: 'Profile',
              labelStyle: const TextStyle(color: Colors.white)),
        ],

        onTap: (index) {
          setState(() {
            _page = index;

            homeIcon = _page == 0 ? const Icon(CupertinoIcons.house_fill, color: Colors.white) : const Icon(CupertinoIcons.house, color: Colors.white);

            chatIcon = _page == 1 ? const Icon(CupertinoIcons.chat_bubble_text_fill, color: Colors.white) : const Icon(CupertinoIcons.chat_bubble_text, color: Colors.white,);

            contactIcon = _page == 2 ? const Icon(CupertinoIcons.rectangle_stack_person_crop_fill, color: Colors.white) : const Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);

            fakeCallIcon = _page == 3 ? const Icon(CupertinoIcons.phone_fill, color: Colors.white) : const Icon(CupertinoIcons.phone, color: Colors.white);

            profileIcon = _page == 4 ? const Icon(CupertinoIcons.person_fill, color: Colors.white) : const Icon(CupertinoIcons.person, color: Colors.white);
          });
        },
      ),
    );
  }
}
