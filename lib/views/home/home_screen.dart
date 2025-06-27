import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/views/account/account.dart';
import 'package:news_api/views/account/guest.dart';
import 'package:news_api/views/bookmark/bookmark.dart';
import 'package:news_api/views/home/home_page.dart';
import 'package:news_api/views/search/search.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.guest = false});
  bool guest;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool guest = false;
  @override
  void initState() {
    super.initState();
    guest = widget.guest;
    log("guest:$guest");
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _navItems =
        guest
            ? [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]
            : [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ];
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          log("state is $state");
          final List<Widget> _screens =
              guest
                  ? [HomePage(), SearchPage(), Guest()]
                  : [HomePage(), SearchPage(), BookMark(), Profile()];
          return _screens[_currentIndex];
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white70,
        showSelectedLabels: false,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index == 2) {
            context.read<NewsBloc>().add(SavedNewsFetchEvent());
          }
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
