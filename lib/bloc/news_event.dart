part of 'news_bloc.dart';

class NewsEvent {}

class LoginEvent extends NewsEvent {
  String email;
  String password;
  LoginEvent({required this.password, required this.email});
}

class RegisterEvent extends NewsEvent {
  String username;
  String password;
  String email;
  RegisterEvent({
    required this.password,
    required this.username,
    required this.email,
  });
}

class SearchEvent extends NewsEvent {}

class BookmarkEvent extends NewsEvent {}

class ForgotPassword extends NewsEvent {}

class TrendingNewsFetchEvent extends NewsEvent {}

class NewsAboutQueryEvent extends NewsEvent {
  String query;
  NewsAboutQueryEvent({required this.query});
}

class NewsSaveEvent extends NewsEvent {
  Article news;
  NewsSaveEvent({required this.news});
}

class SavedNewsFetchEvent extends NewsEvent {}

class DeleteNewsEvent extends NewsEvent {
  Article news;
  DeleteNewsEvent({required this.news});
}

class MatchEvent extends NewsEvent {
  Article newsToCheck;
  MatchEvent({required this.newsToCheck});
}

class CategoryNewsFetchEvent extends NewsEvent {
  String category;
  int index;

  CategoryNewsFetchEvent({required this.category, required this.index});
}
