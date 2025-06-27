part of 'news_bloc.dart';

class NewsState {
  User? user;
  NewsState({this.user});
}

final class NewsInitial extends NewsState {}

final class SignUpSuccessState extends NewsState {}

final class SignUpFailedState extends NewsState {
  String? error;
  SignUpFailedState({this.error});
}

final class LoginSuccesState extends NewsState {
  LoginSuccesState({super.user});
}

final class LoginFailedState extends NewsState {
  String? error;
  LoginFailedState({this.error});
}

final class TrendingNewsFetchSuccess extends NewsState {
  List<Article> news;
  TrendingNewsFetchSuccess({required this.news, super.user});
}

final class CategoryNewsFetchSuccess extends NewsState {
  List<Article> news;
  int index;
  CategoryNewsFetchSuccess({
    required this.news,
    super.user,
    required this.index,
  });
}

final class NewsQueryResultState extends NewsState {
  List<Article> news;
  NewsQueryResultState({required this.news, super.user});
}

final class LoadingState extends NewsState {}

final class NotSavedState extends NewsState {
  String error;
  NotSavedState({required this.error});
}

final class NotFetchedState extends NewsState {
  String error;
  NotFetchedState({required this.error});
}

final class NotDeletedState extends NewsState {
  String error;
  NotDeletedState({required this.error});
}

final class NewsSavedState extends NewsState {}

final class SavedNewsFetchedState extends NewsState {
  final savedNews;
  SavedNewsFetchedState({required this.savedNews});
}

final class NewsDeletedState extends NewsState {}

final class NewsNotDeletedState extends NewsState {
  String error;
  NewsNotDeletedState({required this.error});
}

final class NotLoggedInState extends NewsState {}

final class NewsAlreadyExistState extends NewsState {}

final class NoMatchFoundState extends NewsState {}
