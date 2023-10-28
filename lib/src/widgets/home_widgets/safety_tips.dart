import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:drop_shadow/drop_shadow.dart';

// function to create page heading
AppBar pageHeading(String title){
  return AppBar(
    centerTitle: true,
    title: Text(title, style: const TextStyle(
      fontFamily: 'NovaSlim-Regular',
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white
    ),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
      ),
    ),
  );
}

// function to tell about tip
Widget aboutTip(String text){
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
    padding: const EdgeInsets.all(10),
    child: Center(
        child: Text(text, style: const TextStyle(
          fontFamily: 'EBGaramond-Regular',
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Color(0xff002147),
          fontWeight: FontWeight.bold,
        ),
          textAlign: TextAlign.justify,
        )
    ),
  );
}

// function to create tip title
Center createTitle(String title) {
  return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courgette-Regular',
        ),
      )
  );
}

// function to create tip description
Widget createTextDescription(String text) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Center(
      child: Text(text,
        style: const TextStyle(
        fontFamily: 'PTSans-Regular',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xff343434)
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}

// function to create some remember things
Widget createTextRemember(String text) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Dosis-Regular',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff343434),
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}

// function to create footer
Widget footer(){
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [const Color(0xff6416ff).withOpacity(0.85), const Color(0xff5623a3).withOpacity(0.85)])
    ),

    child: Center(
      child: InkWell(
        onTap: () {
          openEmail();
        },
        child: RichText(
          text: const TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Contact us - ',
                    style: TextStyle(
                      fontFamily: 'Roboto-Regular',
                    )
                ),
                TextSpan(
                    text: 'community.vsafe@gmail.com',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: Colors.white,
                        decoration: TextDecoration.underline)
                ),
              ]
          ),
        ),
      ),
    ),
  );
}

// function to put image
Center putImage(String path) {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: DropShadow(
        blurRadius: 7,
        offset: const Offset(0, 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(21)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(path, fit: BoxFit.cover,)
          ),
        ),
      ),
    ),
  );
}

// class to call _VideoPlayerWidgetState class
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}
// class to play a video
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  var myOpacity = 0.5;
  Color buttonColor = Colors.white;
  LinearGradient buttonGradient = LinearGradient(colors: [Colors.black54.withOpacity(1.0), Colors.black26.withOpacity(1.0)]);
  var marginValue = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setPlaybackSpeed(1.10);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropShadow(
      blurRadius: 8,
      offset: const Offset(0, 5),
      child: AnimatedOpacity(
        opacity: myOpacity,
        duration: const Duration(seconds: 3),
        curve: Curves.easeOutQuart,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuint,
          margin: EdgeInsets.all(marginValue),

          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(21)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Stack(
              children: [

                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                Positioned(
                  bottom: 10,
                  right: 10,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // If the video is playing, pause it.
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            myOpacity = 0.5;
                            marginValue = 20;
                            buttonColor = Colors.white;
                            buttonGradient = LinearGradient(colors: [Colors.black54.withOpacity(1.0), Colors.black26.withOpacity(1.0)]);
                          } else {
                            // If the video is paused, play it.
                            _controller.play();
                            myOpacity = 1.0;
                            marginValue = 10;
                            buttonColor = Colors.white.withOpacity(0.5);
                            buttonGradient = LinearGradient(colors: [Colors.black54.withOpacity(0.1), Colors.black26.withOpacity(0.1)]);
                          }
                        });
                      },

                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: buttonGradient,
                        ),
                        child: Icon(
                          _controller.value.isPlaying ? (FontAwesomeIcons.pause) : FontAwesomeIcons.play, color: buttonColor, size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create awareness tips page
class AwarenessTips extends StatelessWidget {
  const AwarenessTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Be Aware of Your Surroundings"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Awareness of surroundings is essential for women's safety. Here are some key points to consider:"),

                putImage(
                    "assets/images/safety_tips_images/awareness/be_observant.jpg"),
                createTitle("Be Observant"),
                createTextDescription(
                    "Pay attention to your surroundings and the people around you. Notice any unusual or suspicious behavior, and trust your instincts if something feels off."),

                putImage(
                    "assets/images/safety_tips_images/awareness/stay_alert.jpg"),
                createTitle("Stay Alert"),
                createTextDescription(
                    "Avoid distractions like excessive phone use or wearing headphones that can limit your awareness. Maintain a level of alertness, especially in unfamiliar or isolated areas."),

                putImage(
                    "assets/images/safety_tips_images/awareness/plan_ahead.jpg"),
                createTitle("Plan Ahead"),
                createTextDescription(
                    "Familiarize yourself with the route you'll be taking, whether walking, using public transportation, or driving. Identify well-lit, populated areas, and have alternative routes in mind."),

                putImage(
                    "assets/images/safety_tips_images/awareness/trustworthy_companions.jpg"),
                createTitle("Trustworthy Companions"),
                createTextDescription(
                    "Whenever possible, travel with trusted friends, family members, or colleagues. Having company increases safety and provides support in case of any untoward incidents."),

                putImage(
                    "assets/images/safety_tips_images/awareness/well_lit_area.jpg"),
                createTitle("Use Well-Lit and Populated Areas"),
                createTextDescription(
                    "Stick to well-lit streets and areas with a good flow of people. Avoid shortcuts through poorly lit or secluded places, especially at night."),

                putImage(
                    "assets/images/safety_tips_images/awareness/trust_intuition.jpg"),
                createTitle("Trust Your Intuition"),
                createTextDescription(
                    "If you feel uncomfortable or sense danger, trust your instincts and take appropriate action. This could mean leaving a situation, seeking help, or asking someone you trust to accompany you."),

                putImage(
                    "assets/images/safety_tips_images/awareness/mindful_PI.jpg"),
                createTitle("Be Mindful of Personal Information"),
                createTextDescription(
                    "Be cautious about sharing personal information with strangers or on social media platforms. Avoid revealing specific details about your routines, location, or personal belongings."),

                putImage(
                    "assets/images/safety_tips_images/awareness/secure_belongings.jpg"),
                createTitle("Secure Personal Belongings"),
                createTextDescription(
                    "Keep your belongings, including purses, bags, and mobile phones, secure and within sight. Avoid displaying expensive items that may attract unnecessary attention."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Maintaining Emergency Contacts Tips page
class MaintainEmergencyContactsTips extends StatelessWidget {
  const MaintainEmergencyContactsTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Phone and Emergency Contacts"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Maintaining your phone and emergency contacts effectively can greatly contribute to your safety. Here are some tips to help you in that regard:"),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/Keep_Smartphone_Charged.png"),
                createTitle("Keep Your Phone Charged"),
                createTextDescription(
                    "Ensure that your phone is adequately charged before leaving home, especially when you're going to unfamiliar or potentially risky areas. Consider carrying a portable charger or keeping one in your bag for emergencies."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/set_up_contacts.jpeg"),
                createTitle("Set Up Emergency Contacts"),
                createTextDescription(
                    "Save important emergency contacts in your phone, including local authorities (such as police, ambulance, or fire department), trusted friends or family members, and any relevant helpline numbers. Label them clearly with 'ICE' (In Case of Emergency) to make them easily identifiable."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/utilize_sos.png"),
                createTitle("Utilize Emergency SOS Features"),
                createTextDescription(
                    "Familiarize yourself with the emergency speed dial or SOS features available on your phone. Some phones have specific buttons or gestures that can be used to quickly call for help or send distress signals."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/share_location.jpg"),
                createTitle("Share Your Location"),
                createTextDescription(
                    "Consider using location-sharing features with trusted individuals. Many smartphones have built-in options to share your real-time location with selected contacts or through specific apps. Activate this feature when you're in an unfamiliar or potentially unsafe situation."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/memorize_numbers.jpeg"),
                createTitle("Memorize Important Numbers"),
                createTextDescription(
                    "It's a good idea to memorize a few essential numbers, especially those of your close family members or friends. This can be helpful in case you don't have access to your phone or it gets lost or stolen."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/emergency_contact_card.png"),
                createTitle("Create an Emergency Contact Card"),
                createTextDescription(
                    "Carry a physical emergency contact card in your wallet or purse with the names and phone numbers of your emergency contacts. This can be especially useful if someone needs to reach out for help on your behalf."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/update_contact_info.png"),
                createTitle("Regularly Update Contact Information"),
                createTextDescription(
                    "Review and update your emergency contact list periodically. Make sure the numbers are current and relevant. If you change your phone or contact details, update them immediately."),

                putImage(
                    "assets/images/safety_tips_images/manage_phone_contact/practice_dialing_emergency_no.jpg"),
                createTitle("Practice Dialing Emergency Numbers"),
                createTextDescription(
                    "Familiarize yourself with the emergency dialing process on your phone. In some countries, the emergency number might be different. Learn the appropriate emergency numbers for your location and practice dialing them so you can do it quickly if needed."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - Class to create self defence tips page
class LearnSelfDefenceTips extends StatelessWidget {
  const LearnSelfDefenceTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Learn Self Defence"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Self-defense techniques can empower women and help them feel more confident in protecting themselves. Here are some effective self-defense techniques that women can consider learning:"),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/hammer_strike.mp4'),
                createTitle("Hammer strike"),
                createTextDescription("A hammer strike is a self-defense technique that involves using the base of your hand, similar to swinging a hammer, to deliver a powerful strike to an attacker. It is a close-range strike that aims to incapacitate the assailant and create an opportunity for escape."),
                createTextRemember("Remember, proper execution of the hammer strike requires practice and training. Seek guidance from a qualified self-defense instructor to learn the technique correctly and ensure you are using it safely and effectively."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/groin_kick.mp4'),
                createTitle("Groin kick"),
                createTextDescription("The groin kick is a self-defense technique that targets the groin area of an attacker. It is an effective technique, particularly for women, as it can quickly incapacitate the assailant and create an opportunity to escape."),
                createTextRemember("Remember, the groin kick is a powerful self-defense technique, but it should be used as a last resort when you believe your personal safety is at risk. It is important to practice this technique under the guidance of a qualified self-defense instructor to ensure proper form, accuracy, and effectiveness. Additionally, always prioritize your safety and well-being, and seek assistance from authorities or professionals if needed."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/heel_palm_strike.mp4'),
                createTitle("Heel palm strike"),
                createTextDescription("The heel palm strike is a self-defense technique that involves using the heel of your palm to strike an attacker. It is a simple yet effective technique for women's self-defense."),
                createTextRemember("Remember to always prioritize your safety and well-being. Practice the heel palm strike technique under the guidance of a qualified self-defense instructor to ensure proper technique, accuracy, and effectiveness. Additionally, self-defense is not just about physical techniques but also includes situational awareness, assertiveness, and knowing when to seek help."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/elbow_strike.mp4'),
                createTitle("Elbow strike"),
                createTextDescription("The elbow strike is a powerful self-defense technique that utilizes the elbow as a striking tool. It is an effective technique for women's self-defense as it allows for close-quarters combat and can cause significant damage to an attacker."),
                createTextRemember("It's important to note that learning self-defense techniques, including the elbow strike, is best done under the guidance of a qualified self-defense instructor. They can provide proper instruction, demonstrate the technique, and offer personalized feedback to ensure you are performing it effectively and safely. Regular practice and training in a controlled environment will help improve your technique and increase your confidence in executing the strike if needed for self-defense."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/alternative_elbow_strikes.mp4'),
                createTitle("Alternative elbow strikes"),
                createTextDescription("In addition to the basic elbow strike, there are alternative elbow strikes that can be effective for women's self-defense. These techniques provide additional options for striking an attacker and increasing your chances of escaping a dangerous situation."),
                createTextRemember("Remember that proper technique, accuracy, and timing are crucial for effective elbow strikes. Training with a qualified self-defense instructor is highly recommended to learn and practice these techniques safely. Additionally, situational awareness, assertiveness, and knowledge of self-defense principles can greatly enhance your overall personal safety."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/bear_hug_attack.mp4'),
                createTitle("bear hug attack"),
                createTextDescription("A bear hug attack is a situation where an assailant grabs you tightly around your body, usually from the front or behind. It can be a frightening and dangerous scenario, but there are techniques that women can employ for self-defense."),
                createTextRemember("It's crucial to practice these techniques with a qualified self-defense instructor to ensure proper form, technique, and application. Additionally, developing situational awareness, assertiveness, and knowing when to seek help are valuable skills that contribute to overall personal safety."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/escape_with_hands_trapped.mp4'),
                createTitle("Escape with hands trapped "),
                createTextDescription("When caught in a bear hug with your hands trapped, it can be a challenging situation. However, there are techniques that women can use to escape and protect themselves."),
                createTextRemember("Remember, the key to successfully escaping a bear hug with hands trapped is to create sudden movements and use your body weight and momentum to your advantage. Regular practice and training with a qualified self-defense instructor are highly recommended to develop the necessary skills and reflexes. Additionally, developing situational awareness, assertiveness, and knowing when to seek help are important aspects of personal safety."),

                const VideoPlayerWidget(videoPath: 'assets/videos/safety_videos/escape_from_a_side_headlock.mp4'),
                createTitle("Escape from a side headlock"),
                createTextDescription("Escaping from a side headlock is a crucial skill for women's self-defense."),
                createTextRemember("It is important to practice this technique with a qualified self-defense instructor to ensure proper form, timing, and effectiveness."),

                createTextRemember("There are also some additional techniques likeKnee Strike, Eye Gouge, Verbal Assertiveness etc. which you can learn to protect yourself in critical situation. Remember that self-defense is not just about physical techniques but also about situational awareness, assertiveness, and knowing when to seek help. Regular practice and training with a qualified self-defense instructor are highly recommended to develop skills, confidence, and reflexes. Additionally, understanding and implementing personal safety strategies can significantly contribute to overall well-being."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Avoid Alcohol Consumption tips page
class AlcoholConsumptionTips extends StatelessWidget {
  const AlcoholConsumptionTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Avoid Alcohol Consumption"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Excessive alcohol consumption can pose significant risks to women's safety. It can impair judgment, coordination, and decision-making abilities, making women more vulnerable to various dangers. Here are some reasons why excessive alcohol consumption can compromise women's safety:"),

                putImage("assets/images/safety_tips_images/alcohol_consumption/alcohol_consumption.jpg"),

                createTitle("Impaired Judgment"),
                createTextDescription("Alcohol affects cognitive function and impairs judgment. This can lead to poor decision-making, making women more susceptible to dangerous situations or making choices they wouldn't make when sober."),

                createTitle("Increased Vulnerability"),
                createTextDescription("Excessive alcohol consumption can make women more vulnerable to predatory behavior or exploitation. Impaired judgment and reduced physical coordination can make it easier for others to take advantage of them.",),

                createTitle("Risky Behavior"),
                createTextDescription("Alcohol can lower inhibitions and lead to engaging in risky behavior. Women may be more likely to engage in activities that put them in unsafe situations, such as accepting drinks from strangers, leaving with unfamiliar individuals, or venturing into unsafe areas."),

                createTitle("Sexual Assault and Violence"),
                createTextDescription(" Intoxication increases the risk of sexual assault and violence. Perpetrators may target individuals who are visibly impaired, taking advantage of their compromised state. Excessive alcohol consumption can also make it more challenging for women to defend themselves or seek help in such situations."),

                createTitle("Impaired Physical Ability"),
                createTextDescription("Alcohol affects physical coordination and reflexes, making it harder to react quickly in threatening situations. Women may have difficulty defending themselves or escaping dangerous situations if they are under the influence of alcohol."),

                createTitle("Alcohol-Related Accidents"),
                createTextDescription("Excessive alcohol consumption can lead to accidents, including falls, trips, or other physical injuries. Women may also be at higher risk of being involved in car accidents or other incidents if they choose to drive while intoxicated."),

                createTextRemember("To prioritize women's safety, it's essential to consume alcohol responsibly and in moderation. Understanding personal limits, planning ahead, and being aware of the potential risks associated with excessive alcohol consumption can help women make safer choices. Additionally, having a trusted friend or support system present, practicing situational awareness, and knowing how to recognize and avoid potentially dangerous situations are crucial for maintaining personal safety while socializing."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Safety Apps and Tools tips page
class SafetyAppsAndToolsTips extends StatelessWidget {
  const SafetyAppsAndToolsTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Utilize Safety Apps and Tools"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Women can utilize safety apps and tools to enhance their personal safety and have access to help in times of need. Here are some ways women can utilize safety apps and tools:"),

                putImage("assets/images/safety_tips_images/safety_app_and_tools/safety_apps.jpg"),
                createTitle("Personal Safety Apps"),
                createTextDescription('There are numerous personal safety apps available that can be installed on smartphones. These apps often have features like emergency alerts, GPS tracking, and the ability to send distress signals to pre-selected contacts or emergency services. Examples of popular personal safety apps include "bSafe," "Circle of 6," and "Kitestring."'),

                putImage(
                    "assets/images/safety_tips_images/safety_app_and_tools/location_sharing.jpg"),
                createTitle("Location Sharing"),
                createTextDescription(
                    "Many smartphone platforms have built-in features that allow users to share their location with trusted contacts in real-time. Women can utilize these features to share their whereabouts with family or friends, especially when going out alone or in unfamiliar places."),

                putImage(
                    "assets/images/safety_tips_images/safety_app_and_tools/panic_button.jpg"),
                createTitle("Panic Buttons"),
                createTextDescription(
                    "Some safety apps or devices come with panic buttons that can be easily triggered in emergency situations. These buttons send immediate alerts to selected contacts or emergency services, notifying them of the user's distress and providing information on their location."),

                putImage(
                    "assets/images/safety_tips_images/safety_app_and_tools/safety_tools.jpg"),
                createTitle("Self-Defense Tools"),
                createTextDescription(
                    "Women can carry self-defense tools such as personal alarms, pepper spray, or personal safety whistles. These tools can deter potential attackers or attract attention in case of an emergency. It's important to familiarize oneself with the proper use and local regulations regarding such tools."),

                putImage(
                    "assets/images/safety_tips_images/safety_app_and_tools/safety_escorts.jpg"),
                createTitle("Safety Escorts"),
                createTextDescription(
                    "Some ride-sharing or transportation apps offer safety features like sharing trip details with friends or family members, allowing them to track the journey in real-time. Women can use these features to enhance their safety during transportation."),

                putImage(
                    "assets/images/safety_tips_images/safety_app_and_tools/safety_wearable.jpg"),
                createTitle("Safety Wearables"),
                createTextDescription(
                    "There are wearable devices available, such as safety bracelets or smart jewelry, that offer discreet emergency alert features. These devices can be activated in case of danger to send alerts to chosen contacts or emergency services."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Trustworthy Transportation tips page
class TrustworthyTransportationTips extends StatelessWidget {
  const TrustworthyTransportationTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Trustworthy Transportation"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Ensuring trustworthy transportation is crucial for women's safety, especially when traveling alone or in unfamiliar areas. Here are some tips to consider for safe transportation:"),

                putImage("assets/images/safety_tips_images/trustworthy_transportation/licensed_and_registered.jpg"),
                createTitle("Licensed and Registered Services"),
                createTextDescription("Choose licensed and registered transportation services, such as reputable taxi companies or ride-sharing platforms. These services often have measures in place to verify the identity and background of their drivers, providing an added layer of security."),

                putImage("assets/images/safety_tips_images/trustworthy_transportation/verify_driver_information.jpg"),
                createTitle("Verify Driver Information"),
                createTextDescription(" Before getting into a vehicle, verify the driver's identity by comparing their name, photo, and vehicle details with the information provided by the transportation service. Some ride-sharing apps display driver information, including their name, photo, and license plate number, which can be cross-checked for accuracy."),

                putImage("assets/images/safety_tips_images/trustworthy_transportation/share_trip_details.jpg"),
                createTitle("Share Trip Details"),
                createTextDescription("Inform a trusted friend or family member about your travel plans, including the pick-up and drop-off locations, as well as the estimated time of arrival. Share this information in real-time, if possible, using location-sharing features on your smartphone or through messaging apps."),

                putImage("assets/images/safety_tips_images/trustworthy_transportation/stay_aware_and_alert.jpg"),
                createTitle("Stay Aware and Alert"),
                createTextDescription("When in a vehicle, stay vigilant and be aware of your surroundings. Avoid distractions like excessive phone use, and pay attention to the route being taken. If something feels off or suspicious, trust your instincts and take necessary action, such as requesting the driver to stop at a safe location or contacting authorities."),

                putImage("assets/images/safety_tips_images/trustworthy_transportation/travel_in_groups.jpg"),
                createTitle("Travel in Groups"),
                createTextDescription("Whenever possible, opt to travel with friends or in groups, as there is safety in numbers. If attending an event or going to a social gathering, consider coordinating transportation with others to ensure everyone reaches their destination safely."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create personal safety device tips page
class PersonalSafetyDeviceTips extends StatelessWidget {
  const PersonalSafetyDeviceTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Carry a Personal Safety Device"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Carrying a personal safety device can play a significant role in enhancing women's safety. Here are some ways in which personal safety devices can contribute to women's safety:"),

                putImage("assets/images/safety_tips_images/personal_safety_device/personal_safety_device.jpg"),

                createTitle("Deterrence"),
                createTextDescription("The mere presence of a personal safety device can act as a deterrent to potential attackers. Knowing that you have a means to defend yourself can discourage individuals from targeting you in the first place."),

                createTitle("Emergency Alerts"),
                createTextDescription("Many personal safety devices are equipped with features that allow you to send distress signals or emergency alerts to pre-selected contacts or authorities. These alerts can quickly notify others of your situation and location, increasing the chances of receiving timely help.",),

                createTitle("Immediate Access to Help"),
                createTextDescription("Personal safety devices often provide quick and easy access to emergency services. With the press of a button or activation of a specific feature, you can notify emergency responders and provide them with vital information about your situation.",),

                createTitle("Attract Attention"),
                createTextDescription("Personal safety devices like personal alarms or whistles are designed to attract attention. Activating these devices can draw the attention of people nearby, potentially deterring the attacker and prompting others to intervene or provide assistance.",),

                createTitle("Buy Time and Create Distance"),
                createTextDescription("Certain personal safety devices, such as pepper sprays or tasers, are designed to incapacitate attackers temporarily. By using these devices effectively, women can create a window of opportunity to escape, buy time for help to arrive, or create distance between themselves and the threat.",),

                createTitle("Psychological Empowerment"),
                createTextDescription("Carrying a personal safety device can provide women with a sense of empowerment and confidence. Knowing that they have a means to protect themselves can positively impact their mindset, making them more assertive, aware of their surroundings, and prepared to take necessary action if needed.",),

                createTitle("Versatility and Accessibility"),
                createTextDescription("Personal safety devices come in various forms and sizes, allowing women to choose options that suit their preferences and lifestyles. From keychain alarms and pocket-sized pepper sprays to wearable devices, there are options that can be easily incorporated into daily routines and readily accessible when needed.",),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create stay informed tips page
class StayInformedTips extends StatelessWidget {
  const StayInformedTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Stay Informed"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Staying informed about women's safety is crucial for taking proactive measures to protect oneself. Here are some ways women can stay informed:"),

                putImage("assets/images/safety_tips_images/stay_informed/stay_updated.jpg"),
                createTitle("Stay Updated on Current Issues"),
                createTextDescription("Stay informed about the latest news and current issues related to women's safety. Follow reputable news sources, websites, or social media accounts that provide updates on safety concerns, relevant legislation, or community initiatives."),

                putImage("assets/images/safety_tips_images/stay_informed/community_discussions.jpg"),
                createTitle("Engage in Community Discussions"),
                createTextDescription("Participate in community discussions or forums that focus on women's safety. This could involve attending local meetings, joining online groups, or participating in workshops or seminars dedicated to women's safety. Engaging with others who share similar concerns can help exchange information and insights."),

                putImage("assets/images/safety_tips_images/stay_informed/use_social_media.png"),
                createTitle("Use Social Media"),
                createTextDescription("Utilize social media platforms to your advantage. Share updates, photos, or check-ins during social events to indicate your well-being and activity. This helps keep your friends and family informed about your current situation and ensures that someone is aware of your presence."),

                putImage("assets/images/safety_tips_images/stay_informed/safety_organizations_and_authorities.jpg"),
                createTitle("Follow Safety Organizations/Authorities"),
                createTextDescription("Follow and stay connected with organizations and authorities that specialize in women's safety. This can include local law enforcement agencies, women's advocacy groups, non-profit organizations, or government bodies responsible for addressing women's safety issues. They often share valuable resources, tips, and updates related to women's safety."),

                putImage("assets/images/safety_tips_images/stay_informed/online_resources.jpg"),
                createTitle("Access Online Resources"),
                createTextDescription(" Utilize online resources dedicated to women's safety. Numerous websites, blogs, and online platforms provide information, articles, videos, and safety tips tailored for women. Explore these resources to learn about personal safety, self-defense techniques, travel safety, and other relevant topics."),

                putImage("assets/images/safety_tips_images/stay_informed/stay_connected.jpg"),
                createTitle("Stay Connected with Support Networks"),
                createTextDescription("Stay connected with friends, family, and support networks that prioritize women's safety. Engage in open conversations about safety concerns, share experiences, and exchange tips or advice. Building a support network can provide a platform for mutual learning and sharing valuable information."),

                putImage("assets/images/safety_tips_images/stay_informed/know_your_rights.jpg"),
                createTitle("Know Your Rights"),
                createTextDescription("Stay informed about your legal rights regarding women's safety. Familiarize yourself with local laws and regulations related to sexual harassment, assault, domestic violence, and gender-based violence. Being aware of your rights can help you navigate challenging situations and seek appropriate help or support."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create stay informed tips page
class TrustYourIntuitionTips extends StatelessWidget {
  const TrustYourIntuitionTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Trust Your Intuition"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Trusting intuition is an essential aspect of personal safety for women. Intuition is our instinctive feeling or inner voice that alerts us to potential dangers or uncomfortable situations. Here are some ways women can trust their intuition for their safety:"),

                putImage("assets/images/safety_tips_images/trust_your_intuition/acknowledge_intuition.jpg"),
                createTitle("Recognize and Acknowledge Intuition"),
                createTextDescription("Pay attention to your instincts and gut feelings. Intuition often manifests as a sense of unease, discomfort, or a nagging feeling that something is not right. Recognize these signals and take them seriously."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/validate_feelings.jpg"),
                createTitle("Validate Your Feelings"),
                createTextDescription("Trust that your feelings and intuition are valid. Women's intuition is often rooted in subconscious cues and past experiences that help us perceive potential threats or unsafe situations. Avoid dismissing or doubting your instincts."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/listen_to_your_body.jpg"),
                createTitle("Listen to Your Body"),
                createTextDescription("Our bodies can provide valuable clues about our safety. Notice physical reactions like increased heart rate, tense muscles, or a feeling of unease. These physical responses can be indications that something is not right, prompting you to trust your intuition."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/assess_the_situation.jpg"),
                createTitle("Assess the Situation"),
                createTextDescription("Take a step back and assess the situation objectively. Evaluate the environment, people involved, and any potential red flags or warning signs. Consider whether the situation aligns with your intuition and if it feels genuinely safe."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/trust_your_initial_impressions.jpg"),
                createTitle("Trust Your Initial Impressions"),
                createTextDescription("Often, our initial impressions or first reactions to people or situations are based on intuition. If you feel uncomfortable or uneasy around someone, trust that feeling. It's important not to ignore or downplay these initial impressions."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/prioritize_personal_safety.png"),
                createTitle("Prioritize Personal Safety"),
                createTextDescription("Make your safety a priority. If your intuition signals potential danger, take necessary precautions. This may involve removing yourself from a situation, seeking assistance, or notifying someone you trust about your concerns."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/practice_self_confidence.png"),
                createTitle("Practice Self-Confidence"),
                createTextDescription("Building self-confidence can help you trust your intuition more effectively. Cultivate a sense of empowerment and trust in your ability to make decisions that prioritize your safety. Strengthening your self-confidence can enhance your intuition's accuracy."),

                putImage("assets/images/safety_tips_images/trust_your_intuition/seek_support.jpg"),
                createTitle("Seek Support and Validation"),
                createTextDescription("Share your concerns with trusted friends, family members, or mentors. Discussing your feelings and intuition with others can help validate your experiences and provide different perspectives on the situation."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create community engagement tips page
class CommunityEngagementTips extends StatelessWidget {
  const CommunityEngagementTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Community Engagement"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Community engagement plays a vital role in promoting women's safety. By actively participating in the community and working together, women can create a safer environment for themselves and others. Here are some ways women can engage with their community to enhance safety:"),

                putImage("assets/images/safety_tips_images/community_engagement/join_women_safety_groups.jpg"),
                createTitle("Join or Support Women's Safety Groups"),
                createTextDescription("Look for local women's safety groups, organizations, or initiatives that focus on promoting women's safety. Join these groups or offer your support through volunteering, fundraising, or spreading awareness about their activities. These groups often organize workshops, self-defense classes, and community events related to women's safety."),

                putImage("assets/images/safety_tips_images/community_engagement/attend_community_meetings.jpg"),
                createTitle("Attend Community Meetings"),
                createTextDescription("Participate in community meetings, town halls, or forums where safety concerns are discussed. Share your perspectives, experiences, and suggestions on how to improve women's safety within the community. Collaborate with community leaders, local law enforcement, and organizations to develop strategies and initiatives."),

                putImage("assets/images/safety_tips_images/community_engagement/establish_neighborhood_watch_programs.jpg"),
                createTitle("Establish Neighborhood Watch Programs"),
                createTextDescription("Work with neighbors and local authorities to establish neighborhood watch programs. These programs involve community members actively looking out for one another's safety, reporting suspicious activities, and fostering a sense of unity and shared responsibility for the community's well-being."),

                putImage("assets/images/safety_tips_images/community_engagement/advocate_for_safe_public_spaces.jpg"),
                createTitle("Advocate for Safe Public Spaces"),
                createTextDescription("Advocate for safer public spaces within your community. This can involve supporting initiatives to improve lighting, increase police patrols, enhance security measures, and promote the presence of security cameras in public areas. Encourage local authorities to invest in infrastructure that prioritizes women's safety, such as well-maintained sidewalks, well-lit pathways, and secure public transportation options."),

                putImage("assets/images/safety_tips_images/community_engagement/educate_and_empower_others.jpg"),
                createTitle("Educate and Empower Others"),
                createTextDescription("Share your knowledge and empower others with information about women's safety. Conduct workshops or informational sessions on personal safety, self-defense techniques, and strategies for staying safe. Educate community members, including women, children, and elderly individuals, about their rights, recognizing and reporting harassment, and accessing support services."),

                putImage("assets/images/safety_tips_images/community_engagement/support_helpline_services.jpg"),
                createTitle("Support Helpline Services"),
                createTextDescription("Raise awareness about helpline services available for women in need. Share information about hotlines, crisis centers, or counseling services that provide support for victims of violence or harassment. Encourage community members to utilize these services and be aware of available resources."),

                putImage("assets/images/safety_tips_images/community_engagement/foster_a_culture_of_respect.jpg"),
                createTitle("Foster a Culture of Respect"),
                createTextDescription("Promote a culture of respect, consent, and zero tolerance for harassment or violence within the community. Engage in discussions, campaigns, and educational initiatives that address issues like gender equality, healthy relationships, and bystander intervention. Encourage respectful behavior, and challenge harmful attitudes or behaviors that perpetuate women's safety concerns."),

                createTextRemember("Remember, community engagement is an ongoing process that requires collective effort. By actively participating in community initiatives and collaborating with others, women can help create a safer and more inclusive environment for everyone."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Push Yourself tips page
class PushYourselfTips extends StatelessWidget {
  const PushYourselfTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Push Yourself"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Pushing yourself to stay safe is essential for women's personal well-being and security. Here are some ways women can motivate themselves to prioritize their safety:"),

                putImage("assets/images/safety_tips_images/push_yourself/set_clear_boundaries.jpg"),
                createTitle("Set Clear Boundaries"),
                createTextDescription("Establish clear personal boundaries and commit to honoring them. Identify what you are comfortable with and what feels safe to you in various situations. Assertively communicate and enforce these boundaries to protect yourself from potential risks or uncomfortable circumstances."),

                putImage("assets/images/safety_tips_images/push_yourself/develop_self_confidence.png"),
                createTitle("Develop Self-Confidence"),
                createTextDescription("Cultivate self-confidence and believe in your ability to make decisions that prioritize your safety. Recognize your strengths, skills, and resilience. Build a positive self-image and trust in your instincts and judgment."),

                putImage("assets/images/safety_tips_images/push_yourself/educate_yourself.jpg"),
                createTitle("Educate Yourself"),
                createTextDescription("Knowledge is power. Educate yourself about personal safety, self-defense techniques, and strategies for risk assessment. Stay informed about common safety risks, scams, and tactics used by potential offenders. The more you know, the better equipped you'll be to make informed decisions and take necessary precautions."),

                putImage("assets/images/safety_tips_images/push_yourself/practice_situational_awareness.jpg"),
                createTitle("Practice Situational Awareness"),
                createTextDescription("Develop the habit of being aware of your surroundings at all times. Pay attention to people, their behavior, and the overall environment. Trust your instincts and be mindful of any potential signs of danger. Avoid distractions like excessive phone usage or wearing headphones that may compromise your awareness."),

                putImage("assets/images/safety_tips_images/push_yourself/enhance_physical_fitness.jpg"),
                createTitle("Enhance Physical Fitness"),
                createTextDescription("Regular physical exercise and fitness can improve your overall well-being and contribute to your safety. Strengthening your body and increasing your stamina can enhance your ability to respond effectively in challenging situations. Consider activities like self-defense classes, martial arts, or general fitness routines."),

                putImage("assets/images/safety_tips_images/push_yourself/practice_risk_assessment.jpg"),
                createTitle("Practice Risk Assessment"),
                createTextDescription("Develop the skill of assessing risks in various situations. Evaluate potential hazards, vulnerabilities, and potential outcomes. Consider factors like time of day, location, and the presence of others. Assessing risks can help you make informed decisions and take proactive measures to mitigate them."),

                putImage("assets/images/safety_tips_images/push_yourself/establish_safety_plans.jpg"),
                createTitle("Establish Safety Plans"),
                createTextDescription("Create safety plans for different scenarios, such as traveling alone, going out at night, or attending social events. Plan your routes, inform someone you trust about your whereabouts, and establish check-in protocols. Having a safety plan in place can provide you with a sense of control and preparedness."),

                putImage("assets/images/safety_tips_images/push_yourself/embrace_continuous_learning.png"),
                createTitle("Embrace Continuous Learning"),
                createTextDescription("Stay open to learning and adapting. Seek out resources, books, or workshops that can enhance your understanding of personal safety and self-defense. Stay updated on emerging safety technologies, apps, and tools that can support your safety efforts."),

                createTextRemember("Remember, prioritizing your safety is an ongoing process that requires proactive effort and self-belief. Continuously challenge yourself to push beyond your comfort zone and embrace a mindset that values your well-being and security."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create do not fear tips page
class DoNotFearTips extends StatelessWidget {
  const DoNotFearTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Don't Fear in Panic Situation"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Remaining calm in a panic situation is crucial for women's safety. Here are some tips to help you overcome fear and maintain composure:"),

                putImage("assets/images/safety_tips_images/do_not_fear/take_deep_breaths.jpg"),
                createTitle("Take Deep Breaths"),
                createTextDescription("When faced with a panic-inducing situation, take slow, deep breaths. Deep breathing activates the body's relaxation response and helps calm your nervous system. Focus on your breath to center yourself and regain control."),

                putImage("assets/images/safety_tips_images/do_not_fear/stay_grounded.jpg"),
                createTitle("Stay Grounded"),
                createTextDescription("Keep your feet planted firmly on the ground to maintain stability. Feel the connection between your feet and the surface beneath you. This physical grounding technique can help you feel more present and centered."),

                putImage("assets/images/safety_tips_images/do_not_fear/use_positive_self_talk.jpg"),
                createTitle("Use Positive Self-Talk"),
                createTextDescription("Replace fearful thoughts with positive self-talk. Remind yourself that you are strong, capable, and prepared to handle the situation. Repeat affirmations or mantras that help boost your confidence and resilience."),

                putImage("assets/images/safety_tips_images/do_not_fear/activate_emergency_response_systems.jpg"),
                createTitle("Activate Emergency Response Systems"),
                createTextDescription("If available, activate any emergency response systems or tools at your disposal. This can include alerting authorities, triggering personal safety apps, or using panic buttons or alarms. Knowing that help is on the way can provide reassurance and reduce panic."),

                putImage("assets/images/safety_tips_images/do_not_fear/seek_assistance.jpg"),
                createTitle("Seek Assistance"),
                createTextDescription("If possible, reach out to nearby individuals for help or support. Look for people who may be able to intervene or provide assistance in the situation. Remember, there are often bystanders who are willing to help."),

                putImage("assets/images/safety_tips_images/do_not_fear/practice_self_defense_techniques.jpg"),
                createTitle("Practice Self-Defense Techniques"),
                createTextDescription("If necessary, utilize self-defense techniques that you have learned or practiced. These techniques can help create distance between yourself and the threat, providing an opportunity to escape and seek help."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create solidarity tips page
class SolidarityTips extends StatelessWidget {
  const SolidarityTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Solidarity"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Solidarity is a powerful tool for women's safety. When individuals come together to support and advocate for women's safety, it creates a collective force that can drive positive change. Here are some ways to promote solidarity for women's safety:"),

                putImage("assets/images/safety_tips_images/solidarity/support_survivors.png"),
                createTitle("Support Survivors"),
                createTextDescription("Show solidarity by providing support and empathy to survivors of gender-based violence. Create safe spaces for survivors to share their experiences, seek help, and access resources. Advocate for survivor-centered approaches and policies that prioritize their well-being and ensure they are not blamed or shamed for the violence they have experienced."),

                putImage("assets/images/safety_tips_images/solidarity/promote_gender_equality.jpeg"),
                createTitle("Promote Gender Equality"),
                createTextDescription("Work towards achieving gender equality in all aspects of society. Advocate for equal opportunities, rights, and representation for women. Solidarity involves recognizing and addressing the underlying societal norms and structures that perpetuate gender-based violence. Support initiatives and organizations that promote gender equality and challenge gender stereotypes and discrimination."),

                putImage("assets/images/safety_tips_images/solidarity/engage_men_as_allies.png"),
                createTitle("Engage Men as Allies"),
                createTextDescription("Solidarity is not limited to women alone. Engage men as allies in the fight against gender-based violence. Encourage men to actively participate in discussions, challenge harmful behaviors and attitudes, and support efforts to create safer environments for women. Promote healthy masculinity and positive role models who respect and value women's safety."),

                putImage("assets/images/safety_tips_images/solidarity/create_safe_spaces.png"),
                createTitle("Create Safe Spaces"),
                createTextDescription("Foster solidarity by creating safe spaces where women can gather, share experiences, and support one another. Establish community centers, support groups, or online platforms that offer a supportive environment for women to connect, seek guidance, and share resources. Solidarity thrives in spaces where women feel empowered and safe to express themselves."),

                putImage("assets/images/safety_tips_images/solidarity/collaborate_and_mobilize.png"),
                createTitle("Collaborate and Mobilize"),
                createTextDescription("Solidarity is strengthened through collaboration and collective action. Collaborate with community organizations, activists, and individuals working towards women's safety. Mobilize resources, share knowledge, and combine efforts to create a unified front against gender-based violence."),

                putImage("assets/images/safety_tips_images/solidarity/challenge_victim_blaming_and_stigma.jpg"),
                createTitle("Challenge Victim-Blaming and Stigma"),
                createTextDescription("Solidarity means challenging victim-blaming attitudes and reducing the stigma associated with gender-based violence. Create a culture where survivors are supported, believed, and treated with compassion. Foster an environment where women feel comfortable reporting incidents and seeking help without fear of judgment or retribution."),

                putImage("assets/images/safety_tips_images/solidarity/advocate_for_policy_changes.png"),
                createTitle("Advocate for Policy Changes"),
                createTextDescription("Stand in solidarity with organizations and movements that advocate for policy changes to address women's safety. Support initiatives that call for stronger laws, better enforcement, and improved support systems for survivors. Use your voice to amplify the voices of those fighting for change and collaborate with like-minded individuals and organizations to push for policy reforms."),

                putImage("assets/images/safety_tips_images/solidarity/active_bystander_intervention.png"),
                createTitle("Active Bystander Intervention"),
                createTextDescription("Encourage individuals to become active bystanders and intervene when they witness instances of harassment or violence against women. Solidarity involves standing up for others and taking action to prevent or address unsafe situations. Promote the importance of bystander intervention and provide resources or training to empower individuals to intervene safely and effectively."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create Courage tips page
class CourageTips extends StatelessWidget {
  const CourageTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Courage"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Women's courage plays a vital role in ensuring their safety. It empowers them to take proactive measures, stand up against injustice, and assert their rights. Here's how women's courage contributes to their safety:"),

                putImage("assets/images/safety_tips_images/courage/self_defense.jpeg"),
                createTitle("Self-Defense"),
                createTextDescription("Women who cultivate courage are more likely to seek self-defense training and learn techniques to protect themselves physically. They recognize the importance of being prepared and confident in their ability to defend themselves when faced with a threat or dangerous situation."),

                putImage("assets/images/safety_tips_images/courage/asserting_boundaries.jpeg"),
                createTitle("Asserting Boundaries"),
                createTextDescription("Courageous women have the strength to assert their personal boundaries and say no when they feel uncomfortable or unsafe. They understand that setting clear boundaries is crucial for maintaining their safety and well-being."),

                putImage("assets/images/safety_tips_images/courage/speak_up_against_harassment.jpeg"),
                createTitle("Speaking Up"),
                createTextDescription("Courage empowers women to speak up against harassment, discrimination, or violence. Whether it's confronting an offender, reporting an incident, or sharing their experiences, courageous women refuse to be silenced and contribute to breaking the cycle of silence and stigma."),

                putImage("assets/images/safety_tips_images/courage/challenging_societal_norms.jpg"),
                createTitle("Challenging Societal Norms"),
                createTextDescription("Courageous women challenge societal norms that perpetuate gender-based violence or discrimination. They refuse to accept oppressive attitudes or behaviors and actively work to dismantle harmful stereotypes and systems that undermine women's safety."),

                putImage("assets/images/safety_tips_images/courage/empowering_others.jpg"),
                createTitle("Empowering Others"),
                createTextDescription("Courageous women inspire and empower others by sharing their stories, advocating for change, and supporting fellow women. Their courage serves as a beacon of strength and encourages others to stand up for their own safety and rights."),

                putImage("assets/images/safety_tips_images/courage/overcoming_fear.png"),
                createTitle("Overcoming Fear"),
                createTextDescription("Courage allows women to overcome fear and take calculated risks to prioritize their safety. It enables them to confront their fears, step out of their comfort zones, and make choices that promote their well-being and personal safety."),

                putImage("assets/images/safety_tips_images/courage/leading_by_example.png"),
                createTitle("Leading by Example"),
                createTextDescription("Women who embody courage serve as role models for others. Their actions and choices inspire those around them to be courageous, assertive, and proactive about their safety. They contribute to a culture of empowerment and safety for all women."),

                putImage("assets/images/safety_tips_images/courage/resilience.png"),
                createTitle("Resilience"),
                createTextDescription("Courageous women demonstrate resilience in the face of adversity. They bounce back from challenging situations, learn from their experiences, and continue to prioritize their safety and well-being. Their resilience strengthens their ability to navigate through difficult circumstances and overcome obstacles."),

                createTextRemember("Women's courage is a powerful force that helps create safer environments and promotes the overall safety and empowerment of women. By embracing courage, women can take control of their safety, stand up against injustice, and contribute to a society that respects and protects the rights of all individuals."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Todo - class to create practice caution with strangers tips page
class PracticeCautionWithStrangersTips extends StatelessWidget {
  const PracticeCautionWithStrangersTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageHeading("Practice Caution with Strangers"),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTip("Practicing caution with strangers is an essential aspect of women's safety. Here are some guidelines to follow:"),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/maintain_awareness.jpg"),
                createTitle("Maintain Awareness"),
                createTextDescription("Stay alert and aware of your surroundings, especially when in public or unfamiliar places. Avoid distractions such as excessive use of electronic devices, which can make you more vulnerable to potential threats."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/use_caution_when_accepting_help.jpg"),
                createTitle("Use Caution When Accepting Help"),
                createTextDescription("Exercise caution when accepting help from strangers, especially in isolated or vulnerable situations. Assess the situation, trust your judgment, and consider alternative options for assistance if available."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/travel_in_groups.jpg"),
                createTitle("Travel in Groups"),
                createTextDescription("Whenever possible, travel with a companion or in groups, particularly during late hours or in areas that are less populated. There is safety in numbers, and being in a group can deter potential threats."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/report_suspicious_behavior.jpg"),
                createTitle("Report Suspicious Behavior"),
                createTextDescription("If you observe suspicious or potentially dangerous behavior from a stranger, trust your instincts and report it to the appropriate authorities. Your vigilance and willingness to report can help prevent harm to yourself and others."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/public_transportation_safety.jpg"),
                createTitle("Public Transportation Safety"),
                createTextDescription("When using public transportation, be aware of your surroundings and stay in well-lit and populated areas. Sit near other passengers, avoid empty compartments, and use reputable transportation services."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/avoid_walking_alone_at_night.jpg"),
                createTitle("Avoid Walking Alone at Night"),
                createTextDescription("Whenever possible, avoid walking alone at night in isolated or poorly lit areas. If you must walk alone, stick to well-populated areas and well-lit paths. Consider using transportation options like rideshares or taxis for added safety."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/be_assertive_and_confident.jpg"),
                createTitle("Be Assertive and Confident"),
                createTextDescription("Project confidence in your demeanor and body language. Stand tall, make eye contact, and walk with purpose. This sends a signal that you are aware and assertive, making you less vulnerable to potential threats."),

                putImage("assets/images/safety_tips_images/practice_caution_with_strangers/be_mindful_of_personal_information.jpg"),
                createTitle("Be Mindful of Personal Information"),
                createTextDescription("Avoid sharing personal information with strangers, especially in casual conversations or online interactions. Limit the amount of personal details you provide, such as your full name, address, phone number, or financial information."),

                createTextRemember("Remember, these guidelines are meant to enhance your personal safety. However, it's essential to strike a balance between caution and maintaining an open mind in your interactions with others. While it's crucial to be cautious, it's also important not to let fear limit your ability to engage with the world."),

                footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

