/*Developer Name - Navjyot Singh*/


import 'package:app_flutter_project/data_mapper/news_model.dart';

abstract class NewsListState {}

class NewsListFetchingState extends NewsListState {}

class NewsListFetchedState extends NewsListState {
  List<NewsModel>? newsList;

  NewsListFetchedState(
      { this.newsList});


}

class NewsListErrorState extends NewsListState {
  final int? errorType;
  final String? message;

  NewsListErrorState(
      { this.errorType,  this.message});
}

class NewsListEmptyState extends NewsListState {}