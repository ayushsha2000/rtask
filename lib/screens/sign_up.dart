import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskrbuy/notification_service.dart';
import 'package:taskrbuy/screens/home_screen.dart';
import 'package:taskrbuy/screens/sign_in.dart';
import 'package:taskrbuy/screens/welcome_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserManager userManager = UserManager();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
// Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      
      content: Text("You are good to go! Please Sign in"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignUp"),
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
                    "Sign Up",
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
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  showAlertDialog(context);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    throw Exception(
                                        'The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    throw Exception(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  throw Exception(e.toString());
                                }
                              },
                              child: const Text('Sign Up'),
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
                  const Text("Having an account"),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text("Sign In"),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
