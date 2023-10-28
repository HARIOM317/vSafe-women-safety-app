import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vsafe/src/utils/constants.dart';

class TermsAndConditions extends StatelessWidget{
  const TermsAndConditions({super.key});

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
                child: Text("Terms and Conditions", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: "BebasNeue-Regular"),),
              ),
            ),

            const SizedBox(height: 50,),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text("NON-DISCLOSURE AGREEMENT, TERMS AND CONDITIONS OF USE AND ACCESS", style: TextStyle(
                fontSize: 28,
                color: Color(0xff010046),
                fontFamily: 'PTSans-Regular',
              ),
              textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20,),

            writeDescription("Welcome to our vSafe App! We are dedicated to providing you with a safe and secure environment. Before using our app, please carefully read and understand the following terms and conditions. By using our app, you agree to be bound by these terms and conditions."),

            writeHeading("1. PURPOSE AND USE OF THE APP:"),
            writeDescription("The vSafe App is designed to enhance the safety and security of women. It offers features such as emergency alerts, location sharing, self-defense resources, chatting with your connection and more. The app is intended for personal safety and assistance purposes only."),

            writeHeading("2. ELIGIBILITY:"),
            writeDescription("You must be at least 18 years old to use this app. By using the app, you confirm that you are of legal age to enter into this agreement."),

            writeHeading("3. DATA PRIVACY AND SECURITY:"),
            writeDescription("We take data privacy seriously. Our Privacy Policy explains how we collect, use, and protect your personal information. By using the app, you consent to the collection and use of your data as described in the Privacy Policy."),

            writeHeading("4. USER CONDUCT:"),
            writeDescription("You agree to use the vSafe App responsibly and lawfully. Do not engage in any illegal, harmful, or unauthorized activities while using the app. Additionally, you must not misuse the app or interfere with its functionality."),

            writeHeading("5. EMERGENCY SERVICES AND CONTACTS:"),
            writeDescription("The Women Safety App (vSafe) may provide access to emergency services or contacts. However, we do not guarantee the availability or response time of emergency services. You should always contact emergency services directly in case of an emergency."),

            writeHeading("6. ACCURACY OF INFORMATION:"),
            writeDescription("While we strive to provide accurate and up-to-date information, we cannot guarantee the accuracy, completeness, or reliability of the content within the app. Therefore, you should not solely rely on the app's information for critical decisions."),

            writeHeading("7. USER RESPONSIBILITY:"),
            writeDescription("You are solely responsible for your actions and safety while using the app. We recommend using the app in conjunction with other safety measures and common sense practices."),

            writeHeading("8. INTELLECTUAL PROPERTY:"),
            writeDescription("All intellectual property rights related to the Women Safety App, including but not limited to trademarks, logos, and content, are owned by us or our licensors. You may not use, copy, or reproduce any part of the app without our explicit permission.\n\nWe used only third-party images, lottie animations and videos in our app which are not owned by us.\n\nWe have launched vSafe app only as a project and in this we do not use third party resources to earn any kind of money."),

            writeHeading("9. UPDATES AND MODIFICATIONS:"),
            writeDescription("We reserve the right to update, modify, or discontinue the vSafe App at any time. Such changes may include adding or removing features or functionalities. We will endeavor to notify users of significant changes, but it is your responsibility to check for updates regularly."),

            writeHeading("10. INDEMNIFICATION:"),
            writeDescription("You agree to indemnify and hold harmless the vSafe App and its creators from any claims, damages, liabilities, or expenses arising out of your use of the app."),

            writeHeading("11. LIMITATION OF LIABILITY:"),
            writeDescription("To the extent permitted by law, we shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from the use or inability to use the app."),

            writeHeading("12. GOVERNING LAW AND DISPUTE RESOLUTION:"),
            writeDescription("These terms and conditions shall be governed by and construed in accordance with the laws of Indian Government. Any dispute arising from the use of the app shall be resolved through arbitration."),

            writeHeading("13. SEVERABILITY:"),
            writeDescription("If any provision of these terms and conditions is deemed invalid or unenforceable, the remaining provisions shall remain in full force and effect."),

            writeHeading("14. CONTACT INFORMATION:"),
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
                      const TextSpan(text: "If you have any questions, concerns, or feedback regarding the vSafe App or these terms and conditions, please contact us at "),

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

            writeSubHeading("By using the Women Safety App, you acknowledge that you have read, understood, and agreed to these terms and conditions.\n\n")
          ],
        ),
      ),
    );
  }
}