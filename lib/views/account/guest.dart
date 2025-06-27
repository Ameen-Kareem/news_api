import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api/main.dart';

class Guest extends StatelessWidget {
  const Guest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          InkWell(
            onTap: () {
              supabase.auth.signOut();
            },
            child: ListTile(title: Text("LogOut"), leading: Icon(Icons.logout)),
          ),
        ],
      ),
    );
  }
}
