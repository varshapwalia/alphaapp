import 'package:alpha_app/bloc/news_list_bloc/controller/news_list_event.dart';
import 'package:alpha_app/bloc/news_list_bloc/controller/news_list_state.dart';
import 'package:alpha_app/bloc/news_list_bloc/data_mapper/news_list_repo.dart';
import 'package:alpha_app/util/custom_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NewsListBloc
    extends Bloc<NewsListEvent, NewsListState> {
  final NewsListRepo newsListRepo;

  NewsListBloc({required this.newsListRepo})
      : super(NewsListFetchingState());

  @override
  Stream<NewsListState> mapEventToState(
      NewsListEvent event) async* {
    try {
      if (event is FetchNewsListEvent) {
        yield NewsListFetchingState();

        final results = await Future.wait([
          newsListRepo.fetchNewsList(),
        ]);

        yield NewsListFetchedState(
          newsList: results[0],
        );
      }
      if (event is SearchNewsListEvent) {
        yield NewsListFetchingState();

        final results = await Future.wait([
          newsListRepo.searchNewsList(event.searchString),
        ]);

        yield NewsListFetchedState(
          newsList: results[0],
        );
      }


      if (event is RefreshNewsListEvent) {
        yield NewsListFetchingState();

        final results = await Future.wait([
          newsListRepo.fetchNewsList(),
        ]);

        yield NewsListFetchedState(
          newsList: results[0],
        );
      }

    } on CustomException catch (e) {
      yield NewsListErrorState(errorType: e.type, message: e.message);
    } catch (e) {
      yield NewsListErrorState(errorType: 10, message: e.toString());
    }
  }
}