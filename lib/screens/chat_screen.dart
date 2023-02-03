import 'package:chat_app_class/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User user;
  // dynamic messages;
  TextEditingController controller = TextEditingController();
  void getCurrentUser() {
    user = _auth.currentUser!;
  }

  // void getMessages() async {
  //   messages = await _firestore.collection('messages').get();
  //   setState(() {});
  //   for (var item in messages.docs) {
  //     print(item['text']);
  //   }
  // }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.id, (route) => false);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
                stream: _firestore.collection('messages').orderBy('time').snapshots(),
                builder: (context, snapshot) {
                  List<messageBubble> messagewidgets = [];
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    for (var message in messages) {
                      final text = message.get('text');
                      final sender = message.get('sender');
                      final currentuser = user.email;

                      final messagewidget = messageBubble(
                        messages: text,
                        sender: sender,
                        isMe: currentuser == sender,
                      );

                      messagewidgets.add(messagewidget);
                    }
                    return Expanded(
                      child: ListView(
                        children: messagewidgets,
                      ),
                    );
                  }
                  return Text('loading data ...');
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {},
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(controller.text);
                      if (controller.text.isNotEmpty) {
                        _firestore.collection('messages').add({
                          'text': controller.text,
                          'sender': user.email,
                          'time': DateTime.now(),
                        });
                      }
                      controller.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget {
  const messageBubble({
    Key? key,
    required this.messages,
    required this.isMe,
    required this.sender,
  }) : super(key: key);

  final String messages;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text('$sender',
              style: TextStyle(fontSize: 12, color: Colors.black45)),
          SizedBox(
            height: 8,
          ),
          Material(
            color: isMe ? Colors.blueAccent : Colors.white,
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '$messages',
                style: TextStyle(
                    fontSize: 17, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
