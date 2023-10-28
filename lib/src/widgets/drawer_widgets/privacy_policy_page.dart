import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/widgets/drawer_widgets/terms_and_conditions.dart';

class PrivacyPolicy extends StatelessWidget{
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "vSafe",
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
          children: [
            Container(
              color: const Color(0xff2b2846),
              height: 300,
              width: double.infinity,
              child: const Center(
                child: Text("Privacy Policy", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: "BebasNeue-Regular"),),
              ),
            ),

            const SizedBox(height: 50,),

            writeSubHeading("Your privacy is important to us."),
            const SizedBox(height: 20,),

            writeDescription('This Privacy Policy governs the manner in which the vSafe App collects, uses, maintains, and discloses information collected from users (referred to as "you" or "users") of the Women Safety App (referred to as "we," "our," or "the app"). This policy applies to the app and all products and services offered by it.'),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: RichText(
                text: TextSpan(
                  // Default Style
                    style: const TextStyle(
                        fontFamily: 'PTSans-Regular',
                        fontSize: 15,
                        color: Color(0xff383838)
                    ),

                    children: <TextSpan>[
                      const TextSpan(text: "This Policy shall, at all times be read and construed in consonance and along with the terms of use and access available at "),

                      TextSpan(
                          text: "T&Cs",
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () async{
                            goTo(context, const TermsAndConditions());
                          }
                      ),
                      const TextSpan(text: ".")
                    ]
                ),
              ),
            ),

            writeHeading("1. INFORMATION COLLECTION:"),
            writeSubHeading("1.1 PERSONAL INFORMATION:"),
            writeDescription("We may collect personal information from users when they register on the app, subscribe to our services, or interact with certain features of the app. This information may include but is not limited to your name, email address, contact number, and other details necessary for providing you with our services."),
            writeSubHeading("1.2 LOCATION INFORMATION:"),
            writeDescription("To enhance your safety and security, we may collect and use your device's location data with your consent. This information helps us provide location-based safety features, such as emergency alerts and location sharing with trusted contacts."),
            
            writeHeading("2. INFORMATION USAGE:"),
            writeSubHeading("2.1 COMMUNICATION:"),
            writeDescription("We may use your email address or contact number to send you important updates, notifications, and safety-related information. You can opt-out of receiving non-essential communications at any time."),
            writeSubHeading("2.2 IMPROVEMENT OF SERVICES:"),
            writeDescription("We use the feedback and information provided by users to improve our services, troubleshoot issues, and enhance user satisfaction."),

            writeHeading("3. DATA SECURITY:"),
            writeDescription("We take appropriate data security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information. However, no data transmission over the internet or any wireless network can be guaranteed to be 100% secure. While we strive to protect your personal information, we cannot ensure or warrant the security of any information you transmit to us."),

            writeHeading("4. SHARING OF INFORMATION:"),
            writeSubHeading("4.1 THIRD-PARTY SERVICE PROVIDERS:"),
            writeDescription("We may share your information with third-party service providers who assist us in operating the app and providing our services. These providers are obligated to maintain the confidentiality of your information and are not authorized to use it for any other purpose."),

            writeSubHeading("4.2 LEGAL COMPLIANCE:"),
            writeDescription("We may disclose your information if required by law or in response to a valid legal request. We will also cooperate with law enforcement agencies and comply with court orders or subpoenas."),

            writeHeading("5. CHILDREN'S PRIVACY:"),
            writeDescription("The vSafe is not intended for use by children under the age of 18. We do not knowingly collect personal information from children. If you are a parent or guardian and believe that your child has provided us with personal information, please contact us, and we will take steps to remove such information from our records."),

            writeHeading("6. CHANGE TO THIS PRIVACY POLICY:"),
            writeDescription('We reserve the right to update this Privacy Policy at any time. When we do, we will revise the "Last Updated" date at the bottom of this page. We encourage users to check this page regularly for any changes. By using the app, you acknowledge and agree to the most recent version of this Privacy Policy.'),
            
            writeHeading("7. CONTACT INFORMATION:"),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: RichText(
                text: TextSpan(
                  // Default Style
                  style: const TextStyle(
                      fontFamily: 'PTSans-Regular',
                      fontSize: 15,
                      color: Color(0xff383838)
                  ),

                  children: <TextSpan>[
                    const TextSpan(text: "If you have any questions or concerns about this Privacy Policy or the vSafe's practices, please contact us at "),

                    TextSpan(
                        text: "community.vsafe@gmail.com",
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () async{
                          openEmail();
                      }
                    ),
                    const TextSpan(text: ".")
                  ]
                ),
              ),
            ),

            writeSubHeading("Last Updated: 06-08-23"),
            writeDescription("By using the vSafe App, you signify your acceptance of this Privacy Policy. If you do not agree with this policy, please refrain from using the app.\n\n")
          ],
        ),
      ),
    );
  }
}