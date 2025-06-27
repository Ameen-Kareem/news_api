import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatelessWidget {
  Profile({super.key, this.user});
  User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            height: MediaQuery.of(context).size.width * .4,
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.grey,
            ),
            child: Text(""),
          ),

          const SizedBox(height: 20),
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
