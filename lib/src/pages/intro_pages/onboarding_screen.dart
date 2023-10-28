import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen1.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen2.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen3.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen4.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen5.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen6.dart';
import 'package:vsafe/src/pages/intro_pages/intro_screen7.dart';
import 'package:vsafe/src/user/login_welcome_splash_screen.dart';
import 'package:vsafe/src/utils/custom_page_route.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // controller to keep track of which page we are on
  final PageController _controller = PageController();

  // keep track of if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 6);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5(),
              IntroPage6(),
              IntroPage7(),
            ],
          ),

          // dot indicator
          Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip button
                  GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(6); // indexing start from 0
                      },
                      child: const Text('Skip', style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontFamily: 'PTSans-Regular',
                        fontWeight: FontWeight.bold
                      ),
                      )
                  ),

                  SmoothPageIndicator(
                      controller: _controller,
                      count: 7,
                    axisDirection: Axis.horizontal,

                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color(0xff1a237e),
                      dotColor: Colors.indigoAccent.withOpacity(0.5),
                      dotHeight: 8,
                      dotWidth: 8
                    ),
                  ),

                  // next button
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(context, CustomPageRoute(child: const LoginWelcomeSplashScreen()));
                          },
                          child: const Text("Let's go", style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 18,
                              fontFamily: 'PTSans-Regular',
                              fontWeight: FontWeight.bold
                          ),
                          )
                  )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear
                            );
                          },
                          child: const Text("Next", style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 18,
                              fontFamily: 'PTSans-Regular',
                              fontWeight: FontWeight.bold
                          ),
                          )
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
