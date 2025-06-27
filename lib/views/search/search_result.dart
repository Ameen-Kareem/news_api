import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:news_api/views/news_details/news_details.dart';
import 'package:scroll_indicator/scroll_indicator.dart';

class SearchResult extends StatefulWidget {
  SearchResult({super.key, required this.query});
  String query;
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void initState() {
    super.initState();
    query = widget.query;
    context.read<NewsBloc>().add(NewsAboutQueryEvent(query: query));
  }

  late String query;
  List<Article> news = [];
  int newsCount = 10;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: resultTitle(),
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 23),
          ),
        ),
        leadingWidth: 30,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsQueryResultState) {
            news = state.news;
            if (news.length < 10) {
              newsCount = news.length;
              if (newsCount == 0) {
                return Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'No news found\n     regarding\n',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: query[0].toUpperCase() + query.substring(1),
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            controller: scrollController,
            children: [
              newsArea(),
              news.length > newsCount
                  ? InkWell(
                    onTap: () {
                      news.length - newsCount > 10
                          ? newsCount += 10
                          : newsCount += (news.length - newsCount);
                      setState(() {});
                    },

                    child: loadMore(),
                  )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  resultTitle() {
    return RichText(
      text: TextSpan(
        text: 'Showing news about ',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: query[0].toUpperCase() + query.substring(1),
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  newsArea() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsCount,
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
                              NewsDetails(news: news[index], bookmark: false),
                    ),
                  );
                },
                child: ListTile(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1),
                  ),
                  title: Text(news[index].title ?? "No title"),
                  subtitle: Text(
                    news[index].description ?? "No description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget loadMore() {
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
}
