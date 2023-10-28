import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/utils/slider_titles.dart';
import 'package:vsafe/src/widgets/home_widgets/safety_tips.dart';

class CustomCarousel extends StatelessWidget{
  const CustomCarousel({super.key});

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: List.generate(
        imageSliders.length, (index) => Card(
        // elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
        ),

        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black87),
            borderRadius: BorderRadius.circular(20.5),
            boxShadow: [
              BoxShadow(blurRadius: 2, offset: const Offset(0, 2), color: Colors.black.withOpacity(0.5))
            ],
          ),
          child: InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AwarenessTips()));
              } else if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MaintainEmergencyContactsTips()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnSelfDefenceTips()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AlcoholConsumptionTips()));
              } else if (index == 4) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SafetyAppsAndToolsTips()));
              } else if (index == 5) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrustworthyTransportationTips()));
              } else if (index == 6) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalSafetyDeviceTips()));
              } else if (index == 7) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StayInformedTips()));
              } else if (index == 8) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrustYourIntuitionTips()));
              } else if (index == 9) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityEngagementTips()));
              } else if (index == 10) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PushYourselfTips()));
              } else if (index == 11) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoNotFearTips()));
              } else if (index == 12) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SolidarityTips()));
              } else if (index == 13) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CourageTips()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PracticeCautionWithStrangersTips()));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imageSliders[index])
                ),
              ),

              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.deepPurpleAccent.withOpacity(0.25)])
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(articleTitle[index], style: TextStyle(
                      fontFamily: 'NovaSlim-Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.033,
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}