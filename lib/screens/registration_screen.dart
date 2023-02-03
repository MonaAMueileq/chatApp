import 'package:chat_app_class/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/main_btn.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registerScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? email ;
  String? password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void getLoginStates(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
  @override
  void initState() {
    getLoginStates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Image.asset('images/logo.png'),
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
              decoration:
                  kInputDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            MainBtn(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () async{
                if(email!= null && password!= null) {
                 final newUser = await _auth.createUserWithEmailAndPassword(email: email!.trim(), password: password!);
                 try{
                   if(newUser.user != null && mounted){
                     Navigator.pushNamed(context, ChatScreen.id);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text('You are Logged in ${newUser.user!.email}'),
                       duration: const Duration(seconds: 1),
                       action: SnackBarAction(
                         label: 'ACTION',
                         onPressed: () { },
                       ),
                     ));
                   }else{
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text('error you are not Logged in '),
                       duration: const Duration(seconds: 1),
                       action: SnackBarAction(
                         label: 'ACTION',
                         onPressed: () { },
                       ),
                     ));
                   }
                 }catch(e){
                   print(e);
                 }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
