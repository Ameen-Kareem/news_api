import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:news_api/views/news_details/news_details.dart';
import 'package:news_api/views/search/search_result.dart';
import 'package:news_api/widgets/customWidgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key, this.user});
  User? user;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(TrendingNewsFetchEvent());
  }

  _search(String query) async {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchResult(query: query)),
      );
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<Article> trendingNews = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is TrendingNewsFetchSuccess) {
            trendingNews = state.news;
          }
          return ListView(
            children: [
              searchArea(),
              const SizedBox(height: 10),
              trendingNewsArea(),
              state is LoadingState
                  ? CustomWidgets().LoadingWidget(context)
                  : newsArea(),
            ],
          );
        },
      ),
    );
  }

  newsArea() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trendingNews.length,
      itemBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Material(
              elevation: 10,
              shadowColor: Colors.black,
              child: InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NewsDetails(news: trendingNews[index]),
                      ),
                    ),
                child: ListTile(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1),
                  ),
                  title: Text(trendingNews[index].title ?? "No title"),
                  subtitle: Text(
                    trendingNews[index].description ?? "No description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
    );
  }

  searchArea() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for',
          fillColor: Color(0xffEFEFEF),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          prefixIcon: InkWell(
            onTap: () {
              _search(_searchController.text);
              _searchController.clear();
            },
            child: Icon(Icons.search),
          ), // Search icon at the start
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear), // Clear icon
                    onPressed: () => _searchController.clear(),
                  )
                  : null, // Show clear icon only if there is text
        ),
      ),
    );
  }

  trendingNewsArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          Text("Trending News", style: TextStyle(fontSize: 20)),
          Icon(Icons.trending_up),
        ],
      ),
    );
  }
}
