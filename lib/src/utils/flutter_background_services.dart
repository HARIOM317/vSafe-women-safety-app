// import 'dart:async';
// import 'dart:ui';
// import 'package:background_sms/background_sms.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shake/shake.dart';
// import 'package:v_safe/src/db/db_services.dart';
// import 'package:v_safe/src/model/contact_model.dart';
// import 'package:vibration/vibration.dart';
//
// String lat = "";
// String long = "";
//
// _isPermissionGranted() async => await Permission.sms.status.isGranted;
//
// _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
//   await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: message, simSlot: simSlot);
// }
//
// _getLatLong() async{
//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//   long = position.longitude.toString();
//   lat = position.latitude.toString();
// }
//
// @pragma("vm-entry-point")
// void onStart(ServiceInstance service) async{
//   DartPluginRegistrant.ensureInitialized();
//
//   _getLatLong();
//
//   ShakeDetector.autoStart(
//     onPhoneShake: () async{
//       if (await Vibration.hasVibrator() ?? false) {
//         if(await Vibration.hasCustomVibrationsSupport() ?? false) {
//           Vibration.vibrate(duration: 1000);
//           await Future.delayed(const Duration(milliseconds: 500));
//           Vibration.vibrate();
//         }
//       }
//
//       List<TContactModel> contactList = await DataBaseHelper().getContactList();
//       String messageBody = "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
//
//       String msg = "";
//
//       if(lat == "" || long == ""){
//         msg = "I am in danger and need your help! Please try to reach me as soon as possible.";
//       } else {
//         msg = "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody";
//       }
//
//       const Duration(milliseconds: 3000);
//       if(await _isPermissionGranted()) {
//         for (var element in contactList) {
//           _sendSMS(element.number, msg, simSlot: 1);
//         }
//         Fluttertoast.showToast(msg: "SOS alert sent successfully!");
//       }
//       else{
//         Fluttertoast.showToast(msg: "Unable to fetch location!");
//       }
//       // Do stuff on phone shake
//     },
//     minimumShakeCount: 3,
//     shakeSlopTimeMS: 1000,
//     shakeCountResetTime: 3000,
//     shakeThresholdGravity: 5,
//   );
//
//   if(service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
// }
//
// Future<void> initializeService() async{
//   final service = FlutterBackgroundService();
//   AndroidNotificationChannel channel = const AndroidNotificationChannel(
//       "vSafe Notification",
//       "vSafe foreground safety service",
//       description: "Used for important safety services notification",
//       importance: Importance.high
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//
//   await service.configure(iosConfiguration: IosConfiguration(), androidConfiguration: AndroidConfiguration(
//     onStart: onStart,
//     isForegroundMode: true,
//     autoStart: true,
//     notificationChannelId: "vSafe Notification",
//     initialNotificationTitle: "vSafe",
//     initialNotificationContent: "Shake mobile to send SOS",
//     foregroundServiceNotificationId: 10001  // it can be random
//   ));
//
//   service.startService();
// }