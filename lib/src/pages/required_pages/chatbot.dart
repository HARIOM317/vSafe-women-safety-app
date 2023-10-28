import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:vsafe/src/utils/constants.dart';
import 'package:vsafe/src/widgets/drawer_widgets/privacy_policy_page.dart';
import 'package:vsafe/src/widgets/drawer_widgets/terms_and_conditions.dart';

import '../../widgets/drawer_widgets/help_page.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  ChatBotState createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  List<String> jokes = [
    "I told my wife she was drawing her eyebrows too high. She seemed surprised.",
    "Parallel lines have so much in common. It's a shame they'll never meet.",
    "Why don't scientists trust atoms? Because they make up everything!",
    'How do you organize a space party? You "planet"!',
    "Did you hear about the mathematician who's afraid of negative numbers? He'll stop at nothing to avoid them.",
    "Why did the scarecrow win an award? Because he was outstanding in his field!",
    "Why couldn't the bicycle stand up by itself? Because it was two-tired!",
    "I'm on a seafood diet. I see food, and I eat it.",
    "Did you hear about the claustrophobic astronaut? He just needed a little space.",
    "Why did the tomato turn red? Because it saw the salad dressing!",
    "Why don't scientists trust atoms? Because they make up everything!",
    "Parallel lines have so much in common. It's a shame they'll never meet.",
    "I told my wife she was drawing her eyebrows too high. She seemed surprised.",
    "Why couldn't the bicycle stand up by itself? Because it was two-tired!",
    'What do you call a fake noodle? An "impasta"!',
    "I used to play piano by ear, but now I use my hands.",
    "How does a penguin build its house? Igloos it together!",
    "Did you hear about the claustrophobic astronaut? He just needed a little space.",
    "What's orange and sounds like a parrot? A carrot!",
    'What do you call a pile of cats? A "meowtain"!',
    "I'm reading a book about anti-gravity. It's impossible to put down!",
    "Why don't some couples go to the gym? Because some relationships don't work out!",
    'What do you call a bear with no teeth? A "gummy" bear!',
    "Why don't eggs tell jokes? Because they might crack up!",
    "What's brown and sticky? A stick!",
    "Did you hear about the kidnapping at the park? They woke up!",
    "I have a joke about construction, but I'm still working on it.",
    "What's the best time to go to the dentist? Tooth-hurty!"
  ];

  static List<String> hindiJokes = [
    '''पप्पु: मुझे सोने का बहुत शौक है।
मुन्ना: क्या यार, अबी तो तू सुबह उठा है!''',
    '''टीचर: तुम्हारे पिताजी क्या काम करते हैं?
स्टूडेंट: जी, वो रोज़ रात को सोते हैं।''',
    '''एक आदमी अपने दोस्त से: क्या तुमने कभी तुम्हारी बीवी को सच्ची मोहब्बत करने के लिए खोल कर बात की है?
दोस्त: हां, लेकिन तब जब तक खाने की तबलेट की तबियत ख़राब न हो।''',
    '''स्कूल के दिनों में टीचर: तुम इतने दिनों से कहां थे?
छात्र: गुरुजी, नींद में।''',
    '''एक आदमी डॉक्टर से: मेरी आंख में दर्द हो रहा है, ज़रा देखिए।
डॉक्टर: बहुत दिन हो गए, मान लो बिना दर्द के रहो।''',
    '''बच्चा: आपकी शादी कैसे हुई, नानी?
नानी: लड़का पहली बार मुझसे मिला, तो बोला, "नमस्ते दादी!"''',
    '''टीचर: तुम्हारे पिताजी क्या काम करते हैं?
स्टूडेंट: वो रोज़ बिना काम करते हैं, फिर भी मना करते हैं कि वो आराम कर रहे हैं।''',
    '''लड़का: आप मुझसे शादी करोगी?
लड़की: क्या तुम रोमांटिक हो?
लड़का: हां, ज़रूर, जब मेरा मोबाइल बैटरी लो तो मैं इसे करने की कोशिश करता हूँ।''',
    '''पप्पु: मुझे सोने का बहुत शौक है।
मुन्ना: क्या यार, अबी तो तू सुबह उठा है!''',
    '''टीचर: तुम अपनी किताब क्यों नहीं खोलते?
छात्र: मैंने ज़रा से हिन्दी की किताब खोल ली थी, तो पूरी कक्षा की बंद आँखों की दीदी देख रही थी।''',
    '''टीचर: तुमने पेपर में सबसे अच्छा नाम लिखा है।
स्टूडेंट: आपका भी तो नहीं लिखा, मैम।''',
    '''पप्पु: यार, तू अपनी गर्लफ़्रेंड के साथ बाहर घूमने जा रहा है?
मुन्ना: हां यार, उसने मुझसे कहा है कि उसका ख़र्चा जो खर्च हो जाएगा, वो वापस नहीं मांगेगी।''',
    '''एक आदमी बर्ड संकेतक दुकान में गया और बोला, "जिसमें मिलते ही नहीं, उसे दिखा दो।"''',
    '''टीचर: बच्चों, हमने बहुत सारे चूहे मार डाले। तुम मुझे बताओगे, वे सब कहां गए?
छात्र: मैम, वो सब बिल्कुल ठिक हैं, बहुत सारे मिलकर पिज्जा खा रहे हैं।''',
    '''टीचर: तुम लोगों की प्रतिभा की वजह से ही हम सब यहाँ हैं।
स्टूडेंट: वक़्त थोड़ा और देने का, जी।''',
    '''टीचर: तुम ने वादा किया था कि आज कक्षा समय पर पहुँचोगे।
स्टूडेंट: मैम, मैंने तो बस ख़बरदारी की थी, आपने तो उस पर यक़ीन किया।''',
    '''एक आदमी डॉक्टर से: मुझे ख़राब होने की तय्यारी करने के लिए कितने पैसे चाहिए?
डॉक्टर: 1000 रुपये।
आदमी: ठीक है, मुझे 1000 की जगह ख़राब करने की तय्यारी कर दो।''',
    '''एक आदमी अपने दोस्त से: मैं रात को अपनी बीवी से लड़ता रहता हूँ।
दोस्त: वो कैसे?
आदमी: मैं सोते समय अपनी बीवी की तरफ़ मुँह ज़बरदस्ती फ़ेल देता हूँ।''',
    '''टीचर: अगर कोई घर पर तोड़ दे, तो उसका क्या करोगे?
छात्र: उसकी बिल दुगना कर देंगे।''',
    '''संता: क्या तुम मेरे लिए कुछ ख़ास बना सकती हो?
प्रियंका: हां, आज रात को बिना माँ के बिना सुलाऊंगी।''',
    '''ज़ख़्मी सांप अपनी माँ के पास गया और बोला, "माँ, मुझे डॉक्टर के पास ले जाने की बजाय, तुमने मुझे पंडित के पास क्यों ले जाया?"''',
    '''टीचर: तुमने अपने बच्चों के नाम क्यों इतने अजीब रखे हैं?
माँ: ताकि वो बिना बुलाए ही स्कूल आ सकें।''',
    '''संता: बेटा, तुम्हारे पिताजी क्या काम करते हैं?
बेटा: वो बस रोज़ दोपहर को रात के बराबर सोते हैं।''',
    '''संता: बेटा, तुम्हारी शादी कैसे हुई?
बेटा: जी, पहली बार मैं जब भी उसके पास जाता था, तो वो बोलती थी, "नमस्ते जी!"''',
    '''पप्पु: यार, तुझे अपनी गर्लफ़्रेंड के साथ बाहर घूमने जाने में कितनी पर्याप्त धनराशि लगेगी, बता?
मुन्ना: क्या यार, उसने कहा है कि जो ख़र्चा हो जाएगा, वो वापस नहीं मांगेगी।''',
    '''टीचर: तुम्हारे बच्चों का बहुत अच्छा नाम है।
माँ: हां, पर आपके लिए वक़्त नहीं बचा, बिलकुल ठिक है।''',
    '''संता: क्या तुम मेरे लिए कुछ ख़ास बना सकती हो?
प्रियंका: हां, आज रात को बिना माँ के बिना सुलाऊंगी।''',
    '''ज़हरीला सांप: मुझे डॉक्टर के पास ले जाने की बजाय तुमने मुझे पंडित के पास क्यों ले जाया?
ज़ख़्मी सांप: क्योंकि ज़हरीले सांप भी पंडित जी के यहाँ ही जाते हैं।''',
    '''टीचर: तुमने अपने बच्चों के नाम क्यों इतने अजीब रखे हैं?
माँ: ताकि वो बिना बुलाए ही स्कूल आ सकें।''',
    '''संता: बेटा, तुम्हारी शादी कैसे हुई?
बेटा: जी, पहली बार मैं जब भी उसके पास जाता था, तो वो बोलती थी, "नमस्ते जी!"''',
    '''पप्पु: यार, तुझे अपनी गर्लफ़्रेंड के साथ बाहर घूमने जाने में कितनी पर्याप्त धनराशि लगेगी, बता?
मुन्ना: क्या यार, उसने कहा है कि जो ख़र्चा हो जाएगा, वो वापस नहीं मांगेगी।''',
    '''पप्पू अपनी पत्नी से-
अच्छा ये बताओ 'बिदाई' के समय तुम 
लड़कियां इतनी रोती क्यों हो?
पत्नी- 'पागल' अगर तुझे पता चले...
अपने घर से दूर ले जाकर कोई तुमसे 
'बर्तन मंजवाएगा' तो तू क्या नाचेगा...''',
    '''बैंक की cashier ने खिड़की पर खड़े आदमी को कहा 'पैसे नहीं है'
ग्राहक: और दो मोदी माल्या को पैसा, सारे पैसे लेकर भाग गए विदेश में
कैशियर ने खिड़की में से हाथ निकाला और उसकी गर्दन दबोच कर कहा 'साले बैंक में तो है तेरे खाते में नहीं है' भिखारी''',
    '''जज : घर में मालिक होते हुए तूने चोरी कैसे की?
चोर : साहब, आपकी नौकरी अच्छी है, और सैलरी 
भी अच्छी है, फिर आप ये सब सीख कर क्या करोगे?''',
    '''पब्लिक टॉयलेट में लिखा था
'दुनिया चांद पर पहुंच गयी
और तू यहीं पर बैठा है'
पप्पू ने अपना दिमाग लगाया 
और नीचे लिखा
'चांद पर पानी नहीं था
इसलिए वापस आ गया''',
    '''पति- प्यास लगी है पानी लेके आओ..
पत्नी- क्यों ना आज तुम्हें मटर पनीर 
और शाही पुलाव बनाकर खिलाऊं...
पति- वाह वाह...! 
मुंह में पानी आ गया..
पत्नी- आ गया ना मुंह में पानी 
बस इसी से काम चला लो..''',
    '''टीचर- टिटू बताओ..
अकबर ने कब तक शासन किया था ?
टिटू- सर जी..
पेज नंबर 14 से लेकर पेज नंबर 22 तक..।''',
    '''गोलू- जानू, तुम दिन पर दिन 
खूबसूरत होती जा रही हो...
पत्नी (खुश होकर)- तुमने कैसे जाना ?
गोलू- तुम्हें देखकर...
रोटियां भी जलने लगी हैं''',
    '''टिल्लू (लड़की से)- मैं 18 साल का हूं और तुम ?
लड़की- मैं भी 18 साल की हूं...
टिल्लू- तो फिर चलो ना, इसमें शरमाना क्या..
लड़की- कहां ?
टिल्लू- अरे पगली..
वोट देने और कहां...''',
    '''मां- बेटा क्या कर रहे हो
पप्पू- पढ़ रहा हूं मां..
मां- शाबास! बेटा क्या पढ़ रहे हो..?
पप्पू- आपकी होने वाली बहु के SMS''',
    '''टीचर- बच्चों कोई ऐसा वाक्य सुनाओ 
जिसमें हिंदी, पंजाबी, उर्दू और अंग्रेजी का प्रयोग हो..
पप्पू- सर ..
'इश्क दी गली विच ल No entry''',
    '''पत्नी- पूजा किया कीजिए,
बड़ी बलांए टल जाती हैं...
टिटू- हां... तुम्हारे
पिताजी ने बहुत की होगी 
उनकी टल गई और मेरे पल्ले पड़ गई..।''',
    '''एक बार एक वैज्ञानिक ने 'शादी क्या होती है'
ये समझने के लिए शादी कर ली...
.
अब...
.
उसको ये समझ नहीं आ रहा कि विज्ञान क्या होता है...?''',
    '''कल एक साधू बाबा मिले,
मैंने पूछा - कैसे हैं बाबाजी...?
.
बाबाजी बोले - हम तो साधु हैं बेटा,
हमारा 'राम' हमें जैसे रखता है हम वैसे ही रहते हैं...!
तुम तो सुखी हो ना बच्चा...?
. 
मैं बोला - हम तो सांसारिक लोग हैं बाबाजी
हमारी 'सीता' हमें जैसे रखती है, हम वैसे ही रहते हैं...!''',
    '''लड़की - तुम किसी शादी-ब्याह में नाचते क्यों नहीं हो...?
.
.
लड़का - नाचती तो लड़कियां हैं,
हम तो भोले के भक्त हैं,
पी के तांडव करते हैं...!
.
लड़की बेहोश...''',
    '''पत्नी - शादी क्या है...?
.
.
पति - 'मान भी जाओ' से लेकर 'भाड़ में जाओ' तक का सफर ही शादी है...
बाकी सब तो मोह-माया है...!''',
    '''पत्नी - आपको मेरी सुंदरता ज्यादा अच्छी लगती है
या मेरे संस्कार...?
.
.
पति - मुझे तो तेरी ये मजाक करने की आदत
बहुत अच्छी लगती है...!''',
    '''एक बार एक वैज्ञानिक ने 'शादी क्या होती है'
ये समझने के लिए शादी कर ली...
.
अब...
.
उसको ये समझ नहीं आ रहा कि विज्ञान क्या होता है...?''',
    '''कल एक साधू बाबा मिले,
मैंने पूछा - कैसे हैं बाबाजी...?
.
बाबाजी बोले - हम तो साधु हैं बेटा,
हमारा 'राम' हमें जैसे रखता है हम वैसे ही रहते हैं...!
तुम तो सुखी हो ना बच्चा...?
. 
मैं बोला - हम तो सांसारिक लोग हैं बाबाजी
हमारी 'सीता' हमें जैसे रखती है, हम वैसे ही रहते हैं...!''',
    '''लड़की - तुम किसी शादी-ब्याह में नाचते क्यों नहीं हो...?
.
.
लड़का - नाचती तो लड़कियां हैं,
हम तो भोले के भक्त हैं,
पी के तांडव करते हैं...!
.
लड़की बेहोश...''',
    '''पत्नी - शादी क्या है...?
.
.
पति - 'मान भी जाओ' से लेकर 'भाड़ में जाओ' तक का सफर ही शादी है...
बाकी सब तो मोह-माया है...!''',
    '''पत्नी - आपको मेरी सुंदरता ज्यादा अच्छी लगती है
या मेरे संस्कार...?
.
.
पति - मुझे तो तेरी ये मजाक करने की आदत
बहुत अच्छी लगती है...!''',
    '''मास्टर - सबसे पवित्र वस्तु क्या है...?
.
पप्पू - सर मोबाइल...
.
मास्टर (गुस्से में) - वो कैसे...?
.
पप्पू - वह बाथरूम, अस्पताल, श्मशान से होकर आने के बाद भी
बिना धोये हुए घर, रसोई और मंदिर सब जगह जा सकता है...!''',
    '''पत्नी - तुमने कभी मुझे सोना, हिरा या मोती गिफ्ट नहीं दिया...!
.
पति ने एक मुठ्ठी मिट्टी उठा के पत्नी के हाथ में दिया।
.
पत्नी - ये क्या है...?
.
पति - मेरे देश की धरती सोना उगले,
उगले हिरा मोती, मेरे देश की धरती।
.
पत्नी - एक थप्पड़ जड़ते हुए कहा कि
ये देश है विर जवानों का अलबेलों का मस्तानो का...!''',
    '''पप्पू होटल में चेक इन करता है और बोलता है-
डबल बेड का रूम चाहिए...!
.
होटल मैनेजर - लेकिन सर आप तो अकेले हैं।
.
पप्पू - हां, लेकिन मैं एक शादीशुदा इंसान हूं, तो मेरी इच्छा है कि
बेड की दूसरी साइड खामोशी को एंजॉय करूं...!''',
    '''मरीज - डॉक्टर, मैं खाना न खाऊं तो मुझे भूख लग जाती है,
ज्यादा काम करता हूं, तो थक जाता हूं... देर तक जगा रहूं, तो
नींद आ जाती है, मैं क्या करूं...?
.
.
डॉक्टर - रात भर धूप में बैठे रहो, सही हो जाओगे।''',
    '''लड़की ने पप्पू से पूछा - मोहब्बत शादी से पहले करनी चाहिए
या शादी के बाद...?
.
.
पप्पू ने कहा - कभी भी करो, लेकिन बीवी को
पता नहीं चलना चाहिए...!''',
    '''पत्नी - तुमने कभी मुझे सोना, हिरा या मोती गिफ्ट नहीं दिया...!
.
पति ने एक मुठ्ठी मिट्टी उठा के पत्नी के हाथ में दिया।
.
पत्नी - ये क्या है...?
.
पति - मेरे देश की धरती सोना उगले,
उगले हिरा मोती, मेरे देश की धरती।
.
पत्नी - एक थप्पड़ जड़ते हुए कहा कि
ये देश है विर जवानों का अलबेलों का मस्तानो का...!''',
    '''पप्पू होटल में चेक इन करता है और बोलता है-
डबल बेड का रूम चाहिए...!
.
होटल मैनेजर - लेकिन सर आप तो अकेले हैं।
.
पप्पू - हां, लेकिन मैं एक शादीशुदा इंसान हूं, तो मेरी इच्छा है कि
बेड की दूसरी साइड खामोशी को एंजॉय करूं...!''',
    '''मरीज - डॉक्टर, मैं खाना न खाऊं तो मुझे भूख लग जाती है,
ज्यादा काम करता हूं, तो थक जाता हूं... देर तक जगा रहूं, तो
नींद आ जाती है, मैं क्या करूं...?
.
.
डॉक्टर - रात भर धूप में बैठे रहो, सही हो जाओगे।''',
    '''लड़की ने पप्पू से पूछा - मोहब्बत शादी से पहले करनी चाहिए
या शादी के बाद...?
.
.
पप्पू ने कहा - कभी भी करो, लेकिन बीवी को
पता नहीं चलना चाहिए...!''',
    '''मुकेश - डॉक्टर साहब, मुझे एक समस्या है।
.
डॉक्टर - क्या...?
.
मुकेश - बात करते वक्त मुझे आदमी दिखाई नहीं देता...!
.
डॉक्टर - और ऐसा कब होता है...?
.
मुकेश - फोन पर बात करते वक्त...!
.
डॉक्टर बेहोश''',
  ];

  String botResponse = "Hello! How can i help you?";

  // function to ask question to chatbot
  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUserMessage: true));
    });

    _messageController.clear();

    _fetchBotResponse(text);
  }

  // function for  chatbot response
  Future<void> _fetchBotResponse(String userMessage) async {
    if (userMessage.toLowerCase().contains("hello") ||
        userMessage.toLowerCase().contains("hii") ||
        userMessage.toLowerCase().contains("hey")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "Hello, I am vSafe assistant! How can i help you?";
    } else if (userMessage.toLowerCase().contains("how many people developed this app") || userMessage.toLowerCase().contains("how many people make this app") || userMessage.toLowerCase().contains("how many people made this app") || userMessage.toLowerCase().contains("how many people developed vsafe") || userMessage.toLowerCase().contains("how many people make vsafe") || userMessage.toLowerCase().contains("how many people made vsafe")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
      "vSafe is developed as a project during KAVACH Hackathon 2k23.\n\nI have been created by Dream Makers Team consisting of 6 people whose name are given below.\n\n1. Hariom Singh Rajput - Team Leader\n2. Sumit Kumar - Team Member\n3. Abhishek Mewada - Team Member\n4. Rupesh Rahangdale - Team Member\n5. Himanshu Nagoshe - Team Member\n6. Mehak Kushwah - Team Member";
    } else if(userMessage.toLowerCase().contains("who is the founder of this app") || userMessage.toLowerCase().contains("who is the founder of vsafe") || userMessage.toLowerCase().contains("who is founder of this app") || userMessage.toLowerCase().contains("who is founder of vsafe")){
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "Hariom Singh Rajput";
    }
    else if (userMessage.toLowerCase().contains("what is women safety app")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "A women's safety app is a mobile application designed to enhance the safety and security of women. These apps typically offer features that help women feel more secure when they are walking alone, traveling, or in potentially vulnerable situations.";
    } else if (userMessage.toLowerCase().contains("what is women safety")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          """Women's safety refers to the measures, strategies, and efforts aimed at ensuring the physical, emotional, and psychological well-being of women. It encompasses various aspects of life and society, including public spaces, workplaces, homes, and online environments. The goal of women's safety is to create an environment where women can live, work, and interact without fear of violence, harassment, or discrimination.

      Women's safety addresses concerns related to gender-based violence, such as domestic violence, sexual assault, street harassment, and online harassment. It also considers broader issues like equal access to education, healthcare, economic opportunities, and participation in decision-making processes.""";
    } else if (userMessage.toLowerCase().contains("what is vsafe") ||
        userMessage.toLowerCase().contains("is vsafe helpful") ||
        userMessage.toLowerCase().contains("is this app helpful")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "vSafe is a women's safety app designed to enhance the safety and security of women. It is made in India and it offers many features like location sharing, chatting, emergency service, safety tips etc. and it's all features are free to use.";
    } else if (userMessage.toLowerCase().contains("why we need vsafe") ||
        userMessage.toLowerCase().contains("why we use vsafe") ||
        userMessage.toLowerCase().contains("why vsafe") ||
        userMessage.toLowerCase().contains("why this app") ||
        userMessage.toLowerCase().contains("we should use vsafe") ||
        userMessage.toLowerCase().contains("should we use vsafe") ||
        userMessage.toLowerCase().contains("should we use this app") ||
        userMessage.toLowerCase().contains("why we need this app") ||
        userMessage.toLowerCase().contains("why we use this app") ||
        userMessage.toLowerCase().contains("why i use this app") ||
        userMessage.toLowerCase().contains("should i use this app") ||
        userMessage.toLowerCase().contains("should i use vsafe") ||
        userMessage.toLowerCase().contains("why i should use vsafe") ||
        userMessage.toLowerCase().contains("why i should use this app") ||
        userMessage.toLowerCase().contains("why we should use this app")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "There are many women safety apps are available on play store, you can use any of them. We never force you to use vSafe app.";
    } else if (userMessage
            .toLowerCase()
            .contains("which is the best women safety app") ||
        userMessage.toLowerCase().contains("is vsafe better then") ||
        userMessage.toLowerCase().contains("which women safety app is best") ||
        userMessage.toLowerCase().contains("is better the vsafe")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "The best women's safety app for you depends on your specific requirements and the features you prioritize. There are several reputable women's safety apps available, each with its own strengths. I recommend researching and using different women safety apps to know which is the best for you based on their features such as emergency alerts, location sharing, discreet distress signals, and any additional resources they provide. Reading user reviews and considering their ease of use and compatibility with your device can also help you make an informed decision. Ultimately, choose an app that aligns with your safety needs and makes you feel more secure while you're out and about.";
    } else if (userMessage.toLowerCase().contains("why we need women safety app") ||
        userMessage.toLowerCase().contains("why we use women safety app") ||
        userMessage.toLowerCase().contains("how women safety app") ||
        userMessage.toLowerCase().contains("why women safety app") ||
        userMessage.toLowerCase().contains("is women safety app")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          """Women's safety apps serve as valuable tools to address and mitigate safety concerns faced by women in various situations. Here are some reasons why women's safety apps are needed:

Emergency Assistance: Women's safety apps offer quick and easy ways to call for help in emergency situations, such as when they feel threatened or unsafe.

Real-time Location Sharing: These apps allow women to share their real-time location with friends, family, or authorities, providing an added layer of security when traveling alone.

Discreet Alerts: Women's safety apps often include features that allow users to send distress signals discreetly, making it less likely that potential harassers or threats will notice.

Safety While Commuting: Women's safety apps can help women feel safer while using public transportation, walking, or commuting, especially during late hours.

Online Harassment Prevention: Some apps offer features to detect and prevent online harassment, helping women protect their digital presence.

Preventive Measures: Women's safety apps often provide tips and advice on how to stay safe in different situations, empowering women to take preventive measures.

Empowerment: By offering tools for self-defense, emergency communication, and accessing resources, these apps empower women to actively protect themselves.

Support Networks: Many women's safety apps connect users to helplines, support services, and community resources, ensuring they have access to assistance when needed.

Raising Awareness: These apps contribute to raising awareness about women's safety issues, fostering a culture of vigilance and support.

Addressing Gender-based Violence: Women's safety apps play a role in addressing gender-based violence, harassment, and discrimination by offering practical solutions and resources.

Customized Safety: Users can tailor these apps to their specific needs and preferences, ensuring that the safety features align with their comfort levels and situations.

Building Confidence: Knowing they have a safety tool at their disposal can boost women's confidence and reduce anxiety when navigating potentially risky situations.

Promoting Accountability: Women's safety apps encourage accountability by allowing users to document incidents, gather evidence, and report them to appropriate authorities.

Creating Safer Environments: By encouraging the use of women's safety apps, society can work toward creating safer public spaces and encouraging respectful behavior.""";
    } else if (userMessage.toLowerCase().contains("open map") || userMessage.toLowerCase().contains("open google map") || userMessage.toLowerCase().contains("launch google map") || userMessage.toLowerCase().contains("launch map")) {
      botResponse = "Opening Google map...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.maps',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open youtube") || userMessage.toLowerCase().contains("launch youtube")) {
      botResponse = "Opening YouTube...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.youtube',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open google") || userMessage.toLowerCase().contains("launch google")) {
      botResponse = "Opening Google...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.googlequicksearchbox',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open chrome") || userMessage.toLowerCase().contains("launch chrome")) {
      botResponse = "Opening Chrome...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.android.chrome',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open photos") || userMessage.toLowerCase().contains("launch photos")) {
      botResponse = "Opening Google Photos...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.photos',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open meet") || userMessage.toLowerCase().contains("launch meet")) {
      botResponse = "Opening Google Meet...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.tachyon',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open zoom") || userMessage.toLowerCase().contains("launch zoom")) {
      botResponse = "Opening Zoom...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'us.zoom.videomeetings',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open translator") || userMessage.toLowerCase().contains("launch translator")) {
      botResponse = "Opening Google Translator...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.translate',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open drive") || userMessage.toLowerCase().contains("launch drive")) {
      botResponse = "Opening Google Drive...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.docs',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open gmail") || userMessage.toLowerCase().contains("launch gmail")) {
      botResponse = "Opening Gmail...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.gm',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open whatsapp") || userMessage.toLowerCase().contains("launch whatsapp")) {
      botResponse = "Opening Whatsapp...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.whatsapp',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open facebook") || userMessage.toLowerCase().contains("launch facebook")) {
      botResponse = "Opening Facebook...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.facebook.katana',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open instagram") || userMessage.toLowerCase().contains("launch instagram")) {
      botResponse = "Opening Instagram...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.instagram.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open snapchat") || userMessage.toLowerCase().contains("launch snapchat")) {
      botResponse = "Opening Snapchat...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.snapchat.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open telegram") || userMessage.toLowerCase().contains("launch telegram")) {
      botResponse = "Opening Telegram...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'org.telegram.messenger',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open linked in") || userMessage.toLowerCase().contains("launch linked in")) {
      botResponse = "Opening LinkedIn...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.linkedin.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }


    else if (userMessage.toLowerCase().contains("open github") || userMessage.toLowerCase().contains("launch github")) {
      botResponse = "Opening GitHub...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.github.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open picsart") || userMessage.toLowerCase().contains("launch picsart")) {
      botResponse = "Opening Picsart...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.picsart.studio',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open remini") || userMessage.toLowerCase().contains("launch remini")) {
      botResponse = "Opening Remini...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.bigwinepot.nwdn.international',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }


    else if (userMessage.toLowerCase().contains("open inshot") || userMessage.toLowerCase().contains("launch inshot")) {
      botResponse = "Opening InShot...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.camerasideas.instashot',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open inshort") || userMessage.toLowerCase().contains("launch inshort")) {
      botResponse = "Opening InShort...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.nis.app',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open phonepe") || userMessage.toLowerCase().contains("launch phonepe")) {
      botResponse = "Opening PhonePe...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.phonepe.app',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open paytm") || userMessage.toLowerCase().contains("launch paytm")) {
      botResponse = "Opening Paytm...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'net.one97.paytm',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open google pay") || userMessage.toLowerCase().contains("launch google pay")) {
      botResponse = "Opening Google Pay...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.google.android.apps.nbu.paisa.user',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open flipkart") || userMessage.toLowerCase().contains("launch flipkart")) {
      botResponse = "Opening FlipKart...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.flipkart.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open meesho") || userMessage.toLowerCase().contains("launch meesho")) {
      botResponse = "Opening Meesho...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.meesho.supply',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open amazon") || userMessage.toLowerCase().contains("launch amazon")) {
      botResponse = "Opening Amazon...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'in.amazon.mShop.android.shopping',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open duolingo") || userMessage.toLowerCase().contains("launch duolingo")) {
      botResponse = "Opening Duolingo...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.duolingo',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open myntra") || userMessage.toLowerCase().contains("launch myntra")) {
      botResponse = "Opening Myntra...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.myntra.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open amazon prime") || userMessage.toLowerCase().contains("launch amazon prime")) {
      botResponse = "Opening Amazon Prime...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.amazon.avod.thirdpartyclient',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open truecaller") || userMessage.toLowerCase().contains("launch truecaller")) {
      botResponse = "Opening Truecaller...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.truecaller',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open mx player") || userMessage.toLowerCase().contains("launch mx player")) {
      botResponse = "Opening MX Player...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.mxtech.videoplayer.ad',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open disney") || userMessage.toLowerCase().contains("launch disney") || userMessage.toLowerCase().contains("launch hotstar") || userMessage.toLowerCase().contains("open hotstar")) {
      botResponse = "Opening Disney+Hotstar...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'in.startv.hotstar',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open netflix") || userMessage.toLowerCase().contains("launch netflix")) {
      botResponse = "Opening Netflix...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.netflix.mediaclient',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open digilocker") || userMessage.toLowerCase().contains("launch digilocker")) {
      botResponse = "Opening Digilocker...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.digilocker.android',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }


    else if (userMessage.toLowerCase().contains("open chat gpt") ||
        userMessage.toLowerCase().contains("open gpt") || userMessage.toLowerCase().contains("launch chat gpt") || userMessage.toLowerCase().contains("launch gpt") || userMessage.toLowerCase().contains("open bing") || userMessage.toLowerCase().contains("launch bing")) {
      botResponse = "Opening Bing Chat GPT 4 ...";
      await Future.delayed(const Duration(milliseconds: 1000));
      await LaunchApp.openApp(
          androidPackageName: 'com.microsoft.bing',
          openStore: true
      );
      botResponse = "Can I help you any more?";
    }

    else if (userMessage.toLowerCase().contains("open")) {
      botResponse = 'Trying to open...';
      await Future.delayed(const Duration(milliseconds: 3000));
      botResponse = "Sorry, I am unable to open?";
    } else if (userMessage.toLowerCase().contains("how are you") ||
        userMessage.toLowerCase().contains("how you are")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "I am fine. How are you?";
    } else if (userMessage.toLowerCase().contains("i am fine") ||
        userMessage.toLowerCase().contains("i am ok") ||
        userMessage.toLowerCase().contains("i am good") ||
        userMessage.toLowerCase().contains("i am awesome") ||
        userMessage.toLowerCase().contains("i am jhakkas") ||
        userMessage.toLowerCase().contains("i am happy") ||
        userMessage.toLowerCase().contains("fine") ||
        userMessage.toLowerCase().contains("good") ||
        userMessage.toLowerCase().contains("awesome") ||
        userMessage.toLowerCase().contains("happy") ||
        userMessage.toLowerCase().contains("bindas")) {
      botResponse = "That's nice.";
    } else if (userMessage.toLowerCase().contains("feeling good") ||
        userMessage.toLowerCase().contains("feeling happy")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "Great!";
    } else if (userMessage.toLowerCase().contains("what can you do") ||
        userMessage.toLowerCase().contains("what you can do") || userMessage.toLowerCase().contains("how you can help me") || userMessage.toLowerCase().contains("how can you help me")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "I can answer your question and redirect you to any platform. I can even tell you jokes. I am trying to become a good assistant.";
    } else if (userMessage.toLowerCase().contains("who are you") ||
        userMessage.toLowerCase().contains("tell me about your self") ||
        userMessage.toLowerCase().contains("your name") ||
        userMessage.toLowerCase().contains("tell me about you") ||
        userMessage.toLowerCase().contains("your introduction")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "I am vSafe assistant.\nPlease tell me how can I help you?";
    } else if (userMessage.toLowerCase().contains("how old are you") ||
        userMessage.toLowerCase().contains("your age")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "I have been made by vSafe community. I am only a program and there is no age defined for me?";
    } else if (userMessage.toLowerCase().contains("wah") ||
        userMessage.toLowerCase().contains("kya bat") ||
        userMessage.toLowerCase().contains("badiya") ||
        userMessage.toLowerCase().contains("majedar") ||
        userMessage.toLowerCase().contains("sandar")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "😊 It's my pleasure.";
    } else if (userMessage.toLowerCase().contains("vsafe indian") ||
        userMessage.toLowerCase().contains("vsafe is indian") ||
        userMessage.toLowerCase().contains("vsafe developer") ||
        userMessage.toLowerCase().contains("who made vsafe") ||
        userMessage.toLowerCase().contains("who is vsafe developer") ||
        userMessage.toLowerCase().contains("who is developer of vsafe") ||
        userMessage.toLowerCase().contains("vsafe make in which country") ||
        userMessage.toLowerCase().contains("vsafe made in which country") ||
        userMessage
            .toLowerCase()
            .contains("vsafe developed in which country") ||
        userMessage
            .toLowerCase()
            .contains("vsafe is developed in which country")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "vSafe is an Indian women safety app. It is made by team Dream Makes under Hariom Singh Rajput during kavach hackathon in 2023.";
    } else if (userMessage.toLowerCase().contains("how to use vsafe") ||
        userMessage.toLowerCase().contains("how vsafe works") ||
        userMessage.toLowerCase().contains("how i can use vsafe") ||
        userMessage.toLowerCase().contains("how can i use vsafe") ||
        userMessage.toLowerCase().contains("how to use this app") ||
        userMessage.toLowerCase().contains("how i can use this app") ||
        userMessage.toLowerCase().contains("how can i use this app") ||
        userMessage.toLowerCase().contains("help")) {
      botResponse =
          "vSafe app is easy to use but even if you are facing some problem to use this app then you can explore its help section.";
      goTo(context, const HelpPage());
    } else if (userMessage.toLowerCase().contains("it interface is nice") ||
        userMessage.toLowerCase().contains("it is nice") ||
        userMessage.toLowerCase().contains("its homepage is nice") ||
        userMessage.toLowerCase().contains("what a cool design") ||
        userMessage.toLowerCase().contains("good design") ||
        userMessage.toLowerCase().contains("cool interface") ||
        userMessage.toLowerCase().contains("cool design") ||
        userMessage.toLowerCase().contains("nice design") ||
        userMessage.toLowerCase().contains("nice app") ||
        userMessage.toLowerCase().contains("beautiful")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "Thank You!\n\n😊 It's my pleasure.";
    } else if (userMessage
            .toLowerCase()
            .contains("how can i stay safe while walking alone at night") ||
        userMessage.toLowerCase().contains("how can i stay safe") ||
        userMessage.toLowerCase().contains(
            "what should i do if i feel unsafe in a particular area") ||
        userMessage
            .toLowerCase()
            .contains("what should i do if i feel unsafe") ||
        userMessage
            .toLowerCase()
            .contains("what should i do if i am in danger") ||
        userMessage
            .toLowerCase()
            .contains("what should i do if i feel unsafe in") ||
        userMessage.toLowerCase().contains(
            "can you provide tips for staying safe in public spaces") ||
        userMessage
            .toLowerCase()
            .contains("can you provide tips for staying safe") ||
        userMessage.toLowerCase().contains("how can i protect myself") ||
        userMessage.toLowerCase().contains(
            "what precautions should i take while using public transportation") ||
        userMessage.toLowerCase().contains(
            "what precautions should i take while using public transport") ||
        userMessage
            .toLowerCase()
            .contains("are there self-defense techniques you recommend") ||
        userMessage.toLowerCase().contains("self-defense") ||
        userMessage.toLowerCase().contains("self defense") ||
        userMessage.toLowerCase().contains("how can i avoid risky situation") ||
        userMessage
            .toLowerCase()
            .contains("can you suggest ways to stay safe during travel") ||
        userMessage
            .toLowerCase()
            .contains("can you suggest ways to stay safe") ||
        userMessage
            .toLowerCase()
            .contains("what should i do if i am in an emergency situation") ||
        userMessage.toLowerCase().contains("how can i quickly call for help") ||
        userMessage.toLowerCase().contains("How can i quickly take action") ||
        userMessage
            .toLowerCase()
            .contains("how do i report an incident to the authorities") ||
        userMessage.toLowerCase().contains("can you provide advice for staying") ||
        userMessage.toLowerCase().contains("what resources are available to report online harassment") ||
        userMessage.toLowerCase().contains("protect my") ||
        userMessage.toLowerCase().contains("what steps can i take to ensure my") ||
        userMessage.toLowerCase().contains("how can i address harassment") ||
        userMessage.toLowerCase().contains("how can i address uncomfortable") ||
        userMessage.toLowerCase().contains("can you provide advice") ||
        userMessage.toLowerCase().contains("what are my rights in case of workplace harassment") ||
        userMessage.toLowerCase().contains("what are my rights in case of harassment") ||
        userMessage.toLowerCase().contains("how can i protect my") ||
        userMessage.toLowerCase().contains("what safety precautions should i take") ||
        userMessage.toLowerCase().contains("can you provide tips for") ||
        userMessage.toLowerCase().contains("how can i secure") ||
        userMessage.toLowerCase().contains("how can i safe") ||
        userMessage.toLowerCase().contains("what are red flags") ||
        userMessage.toLowerCase().contains("can you provide resources for") ||
        userMessage.toLowerCase().contains("how can i prioritize my mental") ||
        userMessage.toLowerCase().contains("How can I prioritize my emotional") ||
        userMessage.toLowerCase().contains("what self-care practices") ||
        userMessage.toLowerCase().contains("can you suggest") ||
        userMessage.toLowerCase().contains("what is the best way to use pepper spray for self") ||
        userMessage.toLowerCase().contains("safety gadgets for women") ||
        userMessage.toLowerCase().contains("safety apps") ||
        userMessage.toLowerCase().contains("harassment") ||
        userMessage.toLowerCase().contains("uncomfortable situations") ||
        userMessage.toLowerCase().contains("public transportation") ||
        userMessage.toLowerCase().contains("personal boundaries") ||
        userMessage.toLowerCase().contains("personal space") ||
        userMessage.toLowerCase().contains("unwanted attention") ||
        userMessage.toLowerCase().contains("medical care") ||
        userMessage.toLowerCase().contains("night out") ||
        userMessage.toLowerCase().contains("ride-sharing apps") ||
        userMessage.toLowerCase().contains("ride sharing apps") ||
        userMessage.toLowerCase().contains("ride apps") ||
        userMessage.toLowerCase().contains("ride app") ||
        userMessage.toLowerCase().contains("emergency situations") ||
        userMessage.toLowerCase().contains("safety measures") ||
        userMessage.toLowerCase().contains("crisis situation") ||
        userMessage.toLowerCase().contains("panic") ||
        userMessage.toLowerCase().contains("emergencies") ||
        userMessage.toLowerCase().contains("traumatic experiences") ||
        userMessage.toLowerCase().contains("domestic violence") ||
        userMessage.toLowerCase().contains("public spaces") ||
        userMessage.toLowerCase().contains("potential threats") ||
        userMessage.toLowerCase().contains("surrounding") ||
        userMessage.toLowerCase().contains("challenging situations")) {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          """vSafe provides you safety tips and resource which you can follow. We have also provided information about "$userMessage" in our safety tips section. \n\nCan I be of any help to you?""";
    } else if (userMessage.toLowerCase().contains("current date") || userMessage.toLowerCase().contains("date")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      DateTime now = DateTime.now();
      String currentTime = DateFormat.yMMMMEEEEd().format(now);
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("current day") || userMessage.toLowerCase().contains("day") || userMessage.toLowerCase().contains('today')) {
      DateTime now = DateTime.now();
      String currentTime = DateFormat.EEEE().format(now);
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("current month") || userMessage.toLowerCase().contains("month")) {
      DateTime now = DateTime.now();
      String currentTime = DateFormat.LLLL().format(now);
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("current quarter") || userMessage.toLowerCase().contains("quarter")) {
      DateTime now = DateTime.now();
      String currentTime = DateFormat.QQQQ().format(now);
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("current year") || userMessage.toLowerCase().contains("year")) {
      DateTime now = DateTime.now();
      String currentTime = DateFormat.y().format(now);
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("current time") || userMessage.toLowerCase().contains("time")) {
      DateTime now = DateTime.now();
      String currentTime = DateFormat.jm().format(now);
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = currentTime;
    } else if (userMessage.toLowerCase().contains("privacy policy") || userMessage.toLowerCase().contains("is my data safe") || userMessage.toLowerCase().contains("user data is safe") || userMessage.toLowerCase().contains("data is unsafe") || userMessage.toLowerCase().contains("our information")) {
      botResponse =
          "Absolutely, we take data security very seriously. Your data is stored in secure servers with restricted access, and we follow industry best practices to prevent unauthorized access or breaches.\n\nYou can read our privacy policy for more information.";
      goTo(context, const PrivacyPolicy());
    } else if (userMessage.toLowerCase().contains("terms and condition") || userMessage.toLowerCase().contains("terms & condition")) {
      botResponse =
          "Welcome to our vSafe App! We are dedicated to providing you with a safe and secure environment. Before using our app, please carefully read and understand the following terms and conditions. By using our app, you agree to be bound by these terms and conditions.\n\nThank You for reading our terms and conditions.\n\nI hope you agree to our terms and conditions.\n\n😊😊😊\nLet me know if I can be of any further help to you.";
      goTo(context, const TermsAndConditions());
    } else if (userMessage.toLowerCase().contains("talk me in hindi") || userMessage.toLowerCase().contains("hindi me bat") || userMessage.toLowerCase().contains("you know hindi")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "😔 Sorry, I know only english.\n\nBut I can tell you hindi jokes.";
    } else if (userMessage.toLowerCase().contains("any girlfriend") || userMessage.toLowerCase().contains("have you girlfriend") || userMessage.toLowerCase().contains("you have girlfriend")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "I don't have any girlfriend. If you have any in sight, do let me know. I like to be friends with everyone.";
    } else if (userMessage.toLowerCase().contains("any boyfriend") || userMessage.toLowerCase().contains("have you boyfriend") || userMessage.toLowerCase().contains("you have boyfriend")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse =
          "I don't have any boyfriend. If you have any in sight, do let me know. I like to be friends with everyone.";
    } else if (userMessage.toLowerCase().contains("male or female") || userMessage.toLowerCase().contains("male and female")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = 'I am not human. I am only a program.';
    } else if (userMessage.toLowerCase().contains("you are bad") || userMessage.toLowerCase().contains("you are very bad")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      botResponse = "😔😔😔 I am sorry if I hurt you!";
    } else if (userMessage.toLowerCase().contains("english joke") || userMessage.toLowerCase().contains("english jokes") || userMessage.toLowerCase().contains("joke in english") || userMessage.toLowerCase().contains("jokes in english")) {
      jokes.shuffle();
      botResponse = "Searching a joke...";
      await Future.delayed(const Duration(milliseconds: 1000));
      String joke = jokes[0];
      botResponse = "Here's a joke for you!!\n\n😂😂😂\n\n$joke";
    } else if (userMessage.toLowerCase().contains("joke") || userMessage.toLowerCase().contains("jokes") || userMessage.toLowerCase().contains("chutkula") || userMessage.toLowerCase().contains("chutkule") || userMessage.toLowerCase().contains("चुटकुला") || userMessage.toLowerCase().contains("joke in hindi") || userMessage.toLowerCase().contains("jokes in hindi") || userMessage.toLowerCase().contains("hindi joke") || userMessage.toLowerCase().contains("hindi jokes")) {
      hindiJokes.shuffle();
      botResponse = "Searching a joke...";
      await Future.delayed(const Duration(milliseconds: 1000));
      String joke = hindiJokes[0];
      botResponse = "यहाँ आपके लिए एक चुटकुला है!\n\n😂😂😂\n\n$joke";
    } else if (userMessage.toLowerCase().contains("what is") && userMessage.toLowerCase() != "what is your name" && userMessage.toLowerCase() != "what is your name?") {
      botResponse = "Searching... ($userMessage)";
      _launchURL("https://www.google.com/search?q=$userMessage");
      botResponse = "Can I be of any other help to you?";
    } else if (userMessage.toLowerCase().contains("how to") || userMessage.toLowerCase().contains("how") || userMessage.toLowerCase().contains("whose") || userMessage.toLowerCase().contains("tell me") || userMessage.toLowerCase().contains("define") || userMessage.toLowerCase().contains("which") || userMessage.toLowerCase().contains("who") || userMessage.toLowerCase().contains("what are") || userMessage.toLowerCase().contains("when") || userMessage.toLowerCase().contains("where") || userMessage.toLowerCase().contains("why") || userMessage.toLowerCase().contains("whom") || userMessage.toLowerCase().contains("whichever") || userMessage.toLowerCase().contains("whatever") || userMessage.toLowerCase().contains("whenever") || userMessage.toLowerCase().contains("wherever") || userMessage.toLowerCase().contains("however") || userMessage.toLowerCase().contains("if") || userMessage.toLowerCase().contains("whether") || userMessage.toLowerCase().contains("will") || userMessage.toLowerCase().contains("would") || userMessage.toLowerCase().contains("can") || userMessage.toLowerCase().contains("could") || userMessage.toLowerCase().contains("may") || userMessage.toLowerCase().contains("might") || userMessage.toLowerCase().contains("must") || userMessage.toLowerCase().contains("do") || userMessage.toLowerCase().contains("does") || userMessage.toLowerCase().contains("did") || userMessage.toLowerCase().contains("is") || userMessage.toLowerCase().contains("are") || userMessage.toLowerCase().contains("was") || userMessage.toLowerCase().contains("were") || userMessage.toLowerCase().contains("has") || userMessage.toLowerCase().contains("have") || userMessage.toLowerCase().contains("had") || userMessage.toLowerCase().contains("am") || userMessage.toLowerCase().contains("shall") || userMessage.toLowerCase().contains("would") || userMessage.toLowerCase().contains("should") || userMessage.toLowerCase().contains("might") || userMessage.toLowerCase().contains("ought") || userMessage.toLowerCase().contains("is there") || userMessage.toLowerCase().contains("are there") || userMessage.toLowerCase().contains("was there") || userMessage.toLowerCase().contains("were there")) {
      botResponse = "Searching... ($userMessage)";
      await Future.delayed(const Duration(milliseconds: 1000));
      _launchURL("https://www.google.com/search?q=$userMessage");
      botResponse =
          "Question: $userMessage \n\n😊 I hope you got the answer of your question.";
    } else if (userMessage.toLowerCase().contains("play a song") || userMessage.toLowerCase().contains("play") || userMessage.toLowerCase().contains("music") || userMessage.toLowerCase().contains("audio")) {
      botResponse = "Recognizing...";
      await Future.delayed(const Duration(milliseconds: 1000));
      _launchURL("https://www.youtube.com/results?search_query=$userMessage");
      botResponse = "I hope you enjoy the music.";
    } else {
      botResponse = "Searching...";
      await Future.delayed(const Duration(milliseconds: 3000));
      botResponse =
          "Sorry, I am unable to understand! Make sure you are writing in english.";
    }

    setState(() {
      _messages.add(ChatMessage(text: botResponse, isUserMessage: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9eae9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'vSafe Assistant',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Lottie.asset(
                          "assets/animations/other_animations/vSafe_assistant.json",
                          animate: true,
                          height: 150)),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration( // 0xff24292e
                              gradient: const RadialGradient(colors: [Color(0xff263238), Color(0xff24292e)], radius: 5),
                              border: Border.all(color: Colors.black, width: 1.5),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                              )
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Center(
                              child: Text(
                            botResponse,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Dosis-Regular"),
                            textAlign: TextAlign.justify,
                          ))),
                    ],
                  ),
                ),
                // Text(botResponse),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.40,
                          maxWidth: MediaQuery.of(context).size.width * 0.50,
                          minHeight: MediaQuery.of(context).size.height * 0.05,
                          maxHeight: MediaQuery.of(context).size.height * 0.10,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: TextField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Ask a question',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xff3c00a8),
                  ),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String address) async {
    final Uri url = Uri.parse(address);

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      }
    } on SocketException catch (_) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, "No internet connection found!");
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatMessage(
      {super.key, required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
