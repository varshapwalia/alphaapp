abstract class NewsListEvent {}

class FetchNewsListEvent extends NewsListEvent {}
class SearchNewsListEvent extends NewsListEvent {
  String searchString;
  SearchNewsListEvent(this.searchString);
}
class RefreshNewsListEvent extends NewsListEvent {}