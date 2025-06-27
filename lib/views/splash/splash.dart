import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_api/auth_gate.dart';
import 'package:news_api/utils/img_constants.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset(ImgConstants.SPLASH)));
  }
}
