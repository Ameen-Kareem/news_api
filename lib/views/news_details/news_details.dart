import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/bloc/news_bloc.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:news_api/widgets/customWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({required this.news, super.key, this.bookmark = false});
  Article news;
  bool bookmark;
  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  void initState() {
    super.initState();
    news = widget.news;
    bookmark = widget.bookmark;
    context.read<NewsBloc>().add(MatchEvent(newsToCheck: news));
    savedIcon = saved ? Icons.bookmark : Icons.bookmark_border;
  }

  late bool bookmark;
  late Article news;
  bool saved = false;
  IconData savedIcon = Icons.bookmark_border;
  List<Article> savedNews = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (bookmark) {
              context.read<NewsBloc>().add(SavedNewsFetchEvent());
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              saved = !saved;
              if (saved) {
                context.read<NewsBloc>().add(NewsSaveEvent(news: news));
                savedIcon = Icons.bookmark;
              } else {
                context.read<NewsBloc>().add(DeleteNewsEvent(news: news));
                savedIcon = Icons.bookmark_border;
              }
              setState(() {});
            },
            icon: Icon(
              savedIcon,
              color: savedIcon == Icons.bookmark ? Colors.red : Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            log("sate is $state");
            if (state is NewsSavedState) {
              CustomWidgets().PopUpMsg(
                msg: "News Article Saved",
                context: context,
              );
            } else if (state is NewsDeletedState) {
              CustomWidgets().PopUpMsg(
                msg: "News Article Deleted",
                context: context,
              );
            } else if (state is NewsNotDeletedState) {
              CustomWidgets().PopUpMsg(
                msg: "Unable to bookmark article",
                context: context,
              );
            } else if (state is NotSavedState) {
              CustomWidgets().PopUpMsg(
                msg: "News Article not saved",
                context: context,
              );
            } else if (state is NewsAlreadyExistState) {
              saved = true;
              savedIcon = Icons.bookmark;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is SavedNewsFetchedState) {
              savedNews = state.savedNews;
              for (int i = 0; i < savedNews.length; i++) {}
              return CircularProgressIndicator();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  child:
                      news.urlToImage == null
                          ? Text("No Image")
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              news.urlToImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                ),
                const SizedBox(height: 50),
                Text(
                  "                     ${news.title}" ?? "No title",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 30),
                Text(
                  "                       ${news.content}" ?? "No content",
                  style: TextStyle(fontSize: 17),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),

                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    news.url != null
                        ? _launchUrl(news.url!)
                        : CustomWidgets().PopUpMsg(
                          msg: "Unable to launch URL",
                          context: context,
                        );
                  },
                  child: Opacity(
                    opacity: .5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: .5,
                        child: Text(
                          "Read the full Article",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          throw 'Could not launch $url';
        }
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      log("Exception:$e");
    }
  }
}
