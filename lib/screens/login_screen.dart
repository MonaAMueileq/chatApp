import 'package:chat_app_class/components/main_btn.dart';
import 'package:chat_app_class/constants.dart';
import 'package:chat_app_class/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showspinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showspinner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kInputDecoration.copyWith(hintText: 'Enter your email'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  MainBtn(
                    color: Colors.lightBlueAccent,
                    text: 'Log In',
                    onPressed: () async {
                      if (email != null && password != null) {
                        setState(() {
                          showspinner = true;
                        });
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email!, password: password!);
                        try {
                          if (newUser.user != null && mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, ChatScreen.id, (r) => false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'You are Logged in ${newUser.user!.email}'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('error you are not Logged in '),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                      setState(() {
                        showspinner = false;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
