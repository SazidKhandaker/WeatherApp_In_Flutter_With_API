import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:async';

import 'package:weatherapp/homepage.dart';

class Splashscreendemo extends StatefulWidget {
  const Splashscreendemo({super.key});

  @override
  State<Splashscreendemo> createState() => _SplashscreendemoState();
}

class _SplashscreendemoState extends State<Splashscreendemo> {
  @override
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 7),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage())));
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1516912481808-3406841bd33c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=444&q=80'),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: Text(
            "Welcome to weather app",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
