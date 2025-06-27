import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';

import 'package:news_api/views/register/register.dart';
import 'package:news_api/widgets/customWidgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.guestUser}) : super(key: key);
  bool? guestUser;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool guestUser;
  void initState() {
    guestUser = widget.guestUser ?? false;
    super.initState();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic
      String email = _usernameController.text;
      String password = _passwordController.text;
      log("Username: $email, Password: $password");
      context.read<NewsBloc>().add(
        LoginEvent(password: password, email: email),
      );
      // Implement your auth logic here
    }
  }

  void _goToRegistration() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  "Login to\nyour account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _usernameController,
                labelText: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _passwordController,
                labelText: "Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomWidgets().CustomButton(
                functionality: _login,
                maxWidth: double.infinity,
                minWidth: double.infinity,
                maxHeight: 50,
                minHeight: 50,
                text: "Login",
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _goToRegistration,
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontSize: 16, color: Colors.indigo),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/home',
                        arguments: (guest: true),
                      );
                    },
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              BlocListener<NewsBloc, NewsState>(
                listener: (context, state) {
                  log("state is $state in login");
                  if (state is LoginFailedState) {
                    CustomWidgets().PopUpMsg(
                      msg: "Incorrect email or password",
                      context: context,
                    );
                  } else if (state is LoginSuccesState) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  }
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
