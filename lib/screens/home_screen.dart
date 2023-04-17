import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskrbuy/notification_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

UserManager userManager = UserManager();

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  String _ImageURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Push Notification',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'body'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (value) {
                  setState(() {
                    _ImageURL = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
// awaitStrin

                  String token = await userManager.getToken();
                  
                  await userManager.sendNotification(_title, _message,
                      'https://example.com/image.jpg', context, token);
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
