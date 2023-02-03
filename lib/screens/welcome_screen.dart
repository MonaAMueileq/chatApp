import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_class/screens/login_screen.dart';
import 'package:chat_app_class/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../components/main_btn.dart';
import 'chat_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (r) => false);
      }
    });
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    animation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    // animation =
    //     CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    // animation.addStatusListener((status) {
    //   if (animation.status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (animation.status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Chat App',
                      speed: const Duration(milliseconds: 200),
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MainBtn(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            MainBtn(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
