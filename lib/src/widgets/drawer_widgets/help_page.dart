import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';

class HelpPage extends StatelessWidget{
  const HelpPage({super.key});

  Widget frequentlyAskedQuestion(String ques, String ans){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FAQ(
        question: ques,
        answer: ans,
        showDivider: false,
        queDecoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            gradient: LinearGradient(colors: [Colors.deepPurple.withOpacity(0.1), Colors.deepPurpleAccent.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(width: 1, color: Colors.deepPurple.withOpacity(0.4))
        ),
        ansDecoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: const Color(0xfff9e7e7).withOpacity(0.5),
            border: Border.all(width: 1, color: Colors.deepPurple.withOpacity(0.25))
        ),
        queStyle: const TextStyle(fontSize: 16),
        ansStyle: const TextStyle(fontFamily: "PTSans-Regular"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "FAQs",
          style: TextStyle(
              fontFamily: 'Dosis-Regular',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff9d2cf).withOpacity(0.5),
        ),
        
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),

            frequentlyAskedQuestion("What is a vSafe App, and how can it help me?", "The vSafe app is a mobile application designed to enhance the safety and security of women. It offers various features such as emergency alerts, location sharing, self-defense resources, and more, empowering women to feel safer in various situations."),

            frequentlyAskedQuestion("Is the vSafe app free to use?", "All features of the vSafe app are available for free. However, some apps offer premium features that require a subscription or one-time purchase but vSafe provides you all features free of cost."),

            frequentlyAskedQuestion("How do I register and create an account?", 'To use the vSafe app, you need to create an account. To create an account open the app, click on the "Sign Up" or "Register" button, and provide the required information, such as your name, email address, and contact number. Follow the on-screen instructions to complete the registration process.'),

            frequentlyAskedQuestion("Can I use the vSafe app without an internet connection?", "Some features of the vSafe app may require an internet connection to function properly, such as chatting, real-time location sharing or emergency alerts. However, certain self-defense resources or stored emergency contact information may be accessible offline."),

            frequentlyAskedQuestion("How can I access the safety features of the app?", "Explore the app's interface to find safety features like trusted contacts, sos buttons, and nearby places options. Familiarize yourself with these features so that you can use them quickly during emergencies. We have tried to make our app's interface user friendly and easy to use."),

            frequentlyAskedQuestion("How does the emergency alert feature work?", '''The emergency alert feature allows you to send distress signals to your designated emergency contacts with your current location when you're in a dangerous situation. To activate it, press the SOS button available in "Panic Situation Section" within the app or shake mobile phone frequently for a while.'''),

            frequentlyAskedQuestion("How do I add emergency contacts to the app?", '''You can add emergency contacts to the vSafe app by accessing the settings or contact section within the app. To add a contact in trusted contact list click on "Add Trusted Contacts" button and search for contact and click on that  contact, such as family members or friends that one you trust, who can be notified during emergencies. \n\nThe trusted contact list is stored in your local storage of phone due to your personal information, so if you uninstall the app then you need to recreate the trusted contact list.'''),

            frequentlyAskedQuestion("How can I access self-defense resources or tips within the app?", "Explore the app's carousel available in Tips sections to find self-defense resources with personal safety tips and information."),

            frequentlyAskedQuestion("How can I chat with my friend or relative using vSafe?", "Explore the app's chat section and add your friends or relative using email id or mobile number, if it is already register with vSafe then it will be show in your chatting list and then you can send message and images and your current location using vSafe."),

            frequentlyAskedQuestion("Is my personal information safe on the vSafe app?", "The security and privacy of your personal information are taken seriously. The app will have a privacy policy outlining how your data is collected, used, and protected. Always ensure you read and understand the privacy policy before using the app."),

            frequentlyAskedQuestion("How can I provide feedback or report issues with the app?", "To provide feedback or report any issues with the vSafe app, you can use the app's built-in feedback form or contact the app's support team via the provided contact information. Your feedback is valuable in improving the app's performance and features."),

            const SizedBox(
              height: 20,
            )
          ],
        ),
      )
    );
  }
}