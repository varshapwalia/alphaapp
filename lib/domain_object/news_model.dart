class NewsModel {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  NewsModel(this.source,this.author, this.title, this.description, this.url, this.urlToImage,
      this.publishedAt, this.content);

  NewsModel.fromJson(Map<String, dynamic> json)
      :source = Source.fromJson(json['source']),
        author = json['author']??'',
        title = json['title']??'',
        description = json['description']??'',
        url = json['url']??'',
        urlToImage = json['urlToImage']??'',
        publishedAt = json['publishedAt']??'',
        content = json['content']??'';

  Map<String, dynamic> toJson() => {
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt,
    'content': content,
    'source': source,
  };
}


class Source {
  final String id;
  final String name;

  Source(this.id,this.name);

  Source.fromJson(Map<String, dynamic> json)
      :id = json['id']??'',
        name= json['name']??'';

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };
}