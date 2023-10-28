import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:vsafe/src/model/user_message.dart';
import 'package:vsafe/src/model/user_model.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud fire store database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static UserModel me = UserModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using vSafe!",
      profilePic: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push token: $t');
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      UserModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "data": "User ID: ${me.id}",
        },
      };

      await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAA5YOV_Bk:APA91bH9Be1KYE9VXbDUP1W9tRc2moSbtyObi1kTrGo7qfvM66fhdWh76MUTc35kp-9shBgBvcXJXL-jqhluFLUQq8wAulML-AifPYcpD6KfzzTaCbLMzKZrAWjz2y7Ci4B7ue8M9958'
          },
          body: jsonEncode(body));
    } catch (e) {
      log("Error Found: $e");
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);

        // for setting user status active
        await APIs.updateActiveStatus(true);

        getFirebaseMessagingToken();
      } else {
        await createNewUser().then((value) => getSelfInfo());
      }
    });
  }

  // // for checking if user exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for creating a new user
  static Future<void> createNewUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = UserModel(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using vSafe!",
        profilePic: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '',
        type: "user");

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_contacts')
        .snapshots();
  }

  // for getting all users from firebase database except current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      UserModel chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_contacts')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /// *************** Chat Screen Related APIs ***************

  // useful for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all users from firebase database except current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id.toString())}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      UserModel chatUser, String msg, Type type) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send
    final UserMessage message = UserMessage(
        toId: chatUser.id.toString(),
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore.collection(
        'chats/${getConversationId(chatUser.id.toString())}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(UserMessage message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id.toString())}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationId(chatUser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // log("Data Transferred: ${p0.bytesTransferred/1000} kb");
    });

    // updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // delete message
  static Future<void> deleteMessage(UserMessage message) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  // update message
  static Future<void> updateMessage(
      UserMessage message, String updateMsg) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .update({"msg": updateMsg});
  }

  // todo - To add a user in our chatting list
  // for adding a chat user for our conversation
  static Future<bool> addChatUser(String emailOrPhone) async {
    final data1 = await firestore
        .collection('users')
        .where('email', isEqualTo: emailOrPhone)
        .get();

    final data2 = await firestore
        .collection('users')
        .where('phone', isEqualTo: emailOrPhone)
        .get();

    if (data1.docs.isNotEmpty && data1.docs.first.id != user.uid) {
      // user exist
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_contacts')
          .doc(data1.docs.first.id)
          .set({});

      return true;
    } else if (data2.docs.isNotEmpty && data2.docs.first.id != user.uid) {
      // user exist
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_contacts')
          .doc(data2.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }
}
