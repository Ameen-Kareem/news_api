import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/appConfig.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:news_api/views/news_details/news_details.dart';
import 'package:news_api/widgets/customWidgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.user});
  User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(
      CategoryNewsFetchEvent(index: 0, category: Appconfig.newsCategories[0]),
    );
  }

  final ScrollController _scrollController = ScrollController();
  List<Article> newsAboutCategory = [];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Insta brief",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is CategoryNewsFetchSuccess) {
            newsAboutCategory = state.news;
            selectedIndex = state.index;
          }
          return ListView(
            scrollDirection: Axis.vertical,
            children: [
              categoryArea(),
              state is LoadingState
                  ? CustomWidgets().LoadingWidget(context)
                  : newsArea(state),
            ],
          );
        },
      ),
    );
  }

  categoryArea() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder:
            (context, index) => InkWell(
              onTap: () {
                context.read<NewsBloc>().add(
                  CategoryNewsFetchEvent(
                    category: Appconfig.newsCategories[index],
                    index: index,
                  ),
                );
                _scrollToSelectedIndex(index);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: EdgeInsets.only(
                  bottom: 5,
                  left: index == 0 ? 20 : 10,
                  right: 10,
                  top: 5,
                ),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.black : Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  Appconfig.newsCategories[index].toString()[0].toUpperCase() +
                      Appconfig.newsCategories[index].toString().substring(1),
                  style: TextStyle(
                    color: index == selectedIndex ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        itemCount: Appconfig.newsCategories.length,
      ),
    );
  }

  newsArea(NewsState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsAboutCategory.length,
      itemBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Material(
              elevation: 10,
              shadowColor: Colors.black,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              NewsDetails(news: newsAboutCategory[index]),
                    ),
                  );
                },
                child: ListTile(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1),
                  ),
                  title: Text(newsAboutCategory[index].title ?? "No title"),
                  subtitle: Text(
                    newsAboutCategory[index].description ?? "No description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
    );
  }

  loadMore() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.blue,
      ),
      margin: EdgeInsets.symmetric(horizontal: 125),
      width: 50,
      height: 45,
      alignment: Alignment.center,
      child: Text(
        "Load More",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _scrollToSelectedIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final categoryWidth =
        screenWidth /
        3; // Adjust this width based on the item width (container + padding)
    final targetOffset =
        (index * categoryWidth) - (screenWidth / 2) + (categoryWidth / 2);

    _scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
