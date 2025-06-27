import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:news_api/views/news_details/news_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookMark extends StatefulWidget {
  BookMark({super.key, this.user});
  User? user;

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(SavedNewsFetchEvent());
  }

  List<Article> savedNews = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is SavedNewsFetchedState) {
            savedNews = state.savedNews;
            if (savedNews.isEmpty) {
              return Center(child: Text("No saved News"));
            }
            return newsArea(state);
          } else if (state is NotFetchedState) {
            return Center(child: Text("Not working"));
          }
          if (state is NewsDeletedState) {
            context.read<NewsBloc>().add(SavedNewsFetchEvent());
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(child: Text("state is $state"));
        },
      ),
    );
  }

  newsArea(NewsState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: savedNews.length,
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
                          (context) => NewsDetails(
                            news: savedNews[index],
                            bookmark: true,
                          ),
                    ),
                  );
                },
                child: ListTile(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1),
                  ),
                  title: Text(savedNews[index].title ?? "No title"),
                  subtitle: Text(
                    savedNews[index].description ?? "No description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
