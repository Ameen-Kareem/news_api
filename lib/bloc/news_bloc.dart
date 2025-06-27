import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:news_api/apiHelper.dart';
import 'package:news_api/main.dart';
import 'package:news_api/model/all_news_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<RegisterEvent>((event, emit) async {
      final Session? session;
      final User? user;
      try {
        final AuthResponse res = await supabase.auth.signUp(
          email: event.email,
          password: event.password,
          data: {'username': event.username},
        );
        session = res.session;
        user = res.user;
        if (session != null && user != null) {
          log("SignUP success");
          emit(SignUpSuccessState());
        } else {
          log("SignUp failed");
          emit(SignUpFailedState());
        }
      } catch (e) {
        log("Couldn't sign up:$e");
        emit(SignUpFailedState(error: "Unable to sign up due to $e"));
      }
    });
    on<LoginEvent>((event, emit) async {
      try {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: event.email,
          password: event.password,
        );
        final Session? session = res.session;
        final User? user = res.user;

        if (session != null && user != null) {
          log("Login success");
          emit(LoginSuccesState(user: user));
        } else {
          log("Login failed");
          emit(LoginFailedState(error: "Email or Password incorrect"));
        }
      } catch (e) {
        log("Unable to login due to $e error");
        emit(LoginFailedState(error: "Unable to login due to $e"));
      }
    });
    on<TrendingNewsFetchEvent>((event, emit) async {
      emit(LoadingState());
      List<Article> trendingNews;
      try {
        final response = await Apihelper.fetchGetApiHelper(
          endpoint:
              "top-headlines?country=us&apiKey=17805df1c36c4c94bb8f56613af2d365",
        );
        if (response.statusCode == 200) {
          log("result:${response.body}");
          trendingNews = filterNews(response);

          emit(TrendingNewsFetchSuccess(news: trendingNews));
        } else {
          log("failed");
        }
      } catch (e) {
        log("error:$e");
      }
    });
    on<CategoryNewsFetchEvent>((event, emit) async {
      emit(LoadingState());
      List<Article> categoryNews;

      String category = event.category;
      int index = event.index;
      log("inside the category event:$category");
      try {
        final response = await Apihelper.fetchGetApiHelper(
          endpoint:
              "top-headlines?country=us&category=$category&apiKey=17805df1c36c4c94bb8f56613af2d365",
        );
        if (response.statusCode == 200) {
          log("result:${response.body}");
          categoryNews = filterNews(response);

          emit(CategoryNewsFetchSuccess(news: categoryNews, index: index));
        } else {
          log("failed");
        }
      } catch (e) {
        log("error:$e");
      }
    });
    on<NewsAboutQueryEvent>((event, emit) async {
      emit(LoadingState());
      List<Article> resultNews;
      String query = event.query;
      log("inside the query event:$query");
      try {
        final response = await Apihelper.fetchGetApiHelper(
          endpoint:
              "everything?q=$query&apiKey=17805df1c36c4c94bb8f56613af2d365",
        );
        if (response.statusCode == 200) {
          log("result:${response.body}");
          resultNews = filterNews(response);
          emit(NewsQueryResultState(news: resultNews));
        } else {
          log("failed");
        }
      } catch (e) {
        log("error:$e");
      }
    });
    on<NewsSaveEvent>((event, emit) async {
      final user = Supabase.instance.client.auth.currentUser;
      final jsonNews = jsonEncode(event.news.toJson());
      if (user == null) {
        emit(NotLoggedInState());
      }
      try {
        await Supabase.instance.client.from('saved_news').insert({
          'user_id': user!.id,
          'news_id': jsonNews,
        });
        emit(NewsSavedState());
      } catch (e) {
        emit(NotSavedState(error: e.toString()));
      }
    });

    on<SavedNewsFetchEvent>((event, emit) async {
      emit(LoadingState());
      final user = Supabase.instance.client.auth.currentUser;
      List<Article> savedNews = [];
      try {
        if (user == null) {
          emit(NotLoggedInState());
        }
        final data = await Supabase.instance.client
            .from('saved_news')
            .select()
            .eq('user_id', user!.id);
        final rawSavedNews = (data as List).cast<Map<String, dynamic>>();

        for (var news in rawSavedNews) {
          final decodedNews = jsonDecode(news['news_id']);
          savedNews.add(Article.fromJson(decodedNews));
        }
        emit(SavedNewsFetchedState(savedNews: savedNews));
      } catch (e) {
        emit(NotFetchedState(error: e.toString()));
      }
    });
    on<MatchEvent>((event, emit) async {
      emit(LoadingState());
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        emit(NotLoggedInState());
        return;
      }

      final newsJson = jsonEncode(event.newsToCheck.toJson());

      try {
        final response = await Supabase.instance.client
            .from('saved_news')
            .select('*') // Basic select
            .eq('user_id', user.id) // Filter by user ID
            .eq('news_id', newsJson) // Filter by news JSON
            .count(CountOption.exact); // Get exact count

        final int count = response.count ?? 0; // Handle null case

        if (count > 0) {
          emit(NewsAlreadyExistState());
        } else {
          emit(NoMatchFoundState());
        }
        if (count > 0) {
          emit(NewsAlreadyExistState());
        } else {
          emit(NoMatchFoundState());
        }
      } catch (e) {
        emit(NotFetchedState(error: e.toString()));
      }
    });

    on<DeleteNewsEvent>((event, emit) async {
      final user = Supabase.instance.client.auth.currentUser;
      final jsonNews = jsonEncode(event.news.toJson());
      if (user == null) {
        emit(NotLoggedInState());
      }
      try {
        await Supabase.instance.client
            .from('saved_news')
            .delete()
            .eq('news_id', jsonNews)
            .eq('user_id', user!.id);
        emit(NewsDeletedState());
      } catch (e) {
        emit(NewsNotDeletedState(error: e.toString()));
      }
    });
  }
  filterNews(Response response) {
    List<Article> filteredArticles;
    List<Article> news =
        NewsModel.fromJson(jsonDecode(response.body)).articles ?? [];
    filteredArticles =
        news.where((article) {
          return article.title != null &&
              article.title!.isNotEmpty &&
              article.urlToImage != null &&
              article.urlToImage!.isNotEmpty &&
              article.source!.id != "NOT_FOUND" &&
              article.source!.name != "[Removed]";
        }).toList();
    return filteredArticles;
  }
}
