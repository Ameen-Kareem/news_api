import 'package:flutter/material.dart';
import 'package:news_api/bloc/news_bloc.dart';

class CustomWidgets {
  PopUpMsg({required String msg, required BuildContext context}) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }

  CustomTextField({
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool? obscure,
    required String labelText,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 14, color: Colors.black),
        fillColor: Colors.grey.shade200,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),

          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),

          borderRadius: BorderRadius.circular(15),
        ),
      ),
      obscureText: obscure ?? false,
      validator: validator,
    );
  }

  CustomButton({
    Function()? functionality,
    required double maxWidth,
    required double minWidth,
    required double maxHeight,
    required double minHeight,
    required String text,
  }) {
    return OutlinedButton(
      onPressed: functionality,
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(10),
        shadowColor: WidgetStatePropertyAll(Colors.red),
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        maximumSize: WidgetStatePropertyAll(Size(maxWidth, maxHeight)),
        minimumSize: WidgetStatePropertyAll(Size(minWidth, minHeight)),
      ),
      child: Text(text, style: TextStyle(fontSize: 17)),
    );
  }

  LoginPopUp(BuildContext context, String msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.close_sharp),
          title: Text(msg),
          actions: [
            CustomButton(
              functionality:
                  () => Navigator.pushNamed(
                    context,
                    '/login',
                    arguments: (guestUser: true),
                  ),
              text: "Login",
              maxHeight: 50,
              minHeight: 50,
              maxWidth: 100,
              minWidth: 100,
            ),
            CustomButton(
              functionality:
                  () => Navigator.pushNamed(
                    context,
                    '/register',
                    arguments: (guestUser: true),
                  ),
              text: "Register",
              maxHeight: 50,
              minHeight: 50,
              maxWidth: 120,
              minWidth: 120,
            ),
          ],
        );
      },
    );
  }

  LoadingWidget(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          kToolbarHeight -
          kBottomNavigationBarHeight, // height of AppBar
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
