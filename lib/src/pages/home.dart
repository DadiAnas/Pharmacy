import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;

  const Home({
    Key key,
    @required this.user
  }) : super(key: key);
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${widget.user.email}'),
      ),
    );
  }
}
