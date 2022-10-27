import 'package:alpha_app/data_mapper/news_model.dart';
import 'package:flutter/material.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({Key? key, required this.news}) : super(key: key);

  final News news;

  @override
  _MyNewsDetailsState createState() => _MyNewsDetailsState();
}

class _MyNewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
