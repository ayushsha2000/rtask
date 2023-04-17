// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class UserManager {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken() ?? 'token';
    return token;
  }

  Future<void> storeToken(String userId, String token) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId);
    final data = await doc.get();
    if (data.exists) {
      doc.update({"notificationToken": token});
    } else {
      doc.set({"notificationToken": token});
    }
  }

  Future<void> sendNotification(String title, String body, String imageUrl,
      BuildContext context, String token) async {
    final String serverToken =
        "AAAAcTEhZho:APA91bGqzcys2julnj0h5MomIGwzlKP6hgl5byMVlUPYo5CFw-3PE1a3qDDhqLuFgkhV6SnpPAUxrgpYNjmSpp1RH5VuMW5JCIhNiE__v2nKWrd3KHlKCbSkcv6hRZib2Wn8oTNT6lcj";
    final String apiUrl = 'https://fcm.googleapis.com/fcm/send';

    Future<String> token() async {
      final data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      return data.data()!["notificationToken"];
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'image': imageUrl,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await token()
        },
      ),
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Sent"),
            content: new Text("Notification sent successfully"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (response.statusCode == 200) {
      print('Notification Sent ${response.statusCode} ${response.body}');
      _showDialog();

      print('Notification sent successfully');
    } else {
      print(
          'Failed to send notification. ${response.statusCode} ${response.body}');
    }
  }
}
