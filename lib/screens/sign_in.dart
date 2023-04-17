import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskrbuy/notification_service.dart';
import 'package:taskrbuy/screens/home_screen.dart';
import 'package:taskrbuy/screens/sign_up.dart';
import 'package:taskrbuy/screens/welcome_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserManager userManager = UserManager();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignIn"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null &&
                                      !EmailValidator.validate(value)
                                  ? 'Enter a valid email'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null && value.length < 6
                                  ? "Enter min. 6 characters"
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final user = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  String uid =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  String token = await userManager.getToken();
                                  userManager.storeToken(uid, token);
                                  firebaseMessaging
                                      .subscribeToTopic("notifications");

                                  print(user);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    throw Exception(
                                        'No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    throw Exception(
                                        'Wrong password provided for that user.');
                                  }
                                }
                              },
                              child: const Text('Sign In'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const Text("Don't have an account?"),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text("Sign Up"),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
