import 'package:flutter/material.dart';
import 'package:news_api/views/home/home_screen.dart';
import 'package:news_api/views/login/login.dart';
import 'package:news_api/views/register/register.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegistrationScreen(),
  };
}
