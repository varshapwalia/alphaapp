import 'package:alpha_app/bloc/news_list_bloc/news_list_bloc.dart';
import 'package:alpha_app/bloc/news_list_bloc/news_list_event.dart';
import 'package:alpha_app/bloc/news_list_bloc/repository/news_list_repo.dart';
import 'package:alpha_app/pages/details/detail_page.dart';
import 'package:alpha_app/util/debouncer.dart';
import 'package:alpha_app/widgets/shimmer.dart';
import 'package:alpha_app/widgets/status_500_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/news_list_bloc/news_list_state.dart';
import '../../data_mapper/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final _debouncer = Debouncer(milliseconds: 500);

  String getCurrentDate() {
    var now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  Widget outputScreen(List<NewsModel> newsList, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: newsList.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: newsList[index].urlToImage == null
                              ? const NetworkImage(
                                  'https://via.placeholder.com/150')
                              : NetworkImage(newsList[index].urlToImage),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          newsList[index].title,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          children: [
                            newsList[index].description != null
                                ? Text(newsList[index].description,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                    maxLines: 3)
                                : Container(),
                          ],
                        ),
                        //contentPadding: EdgeInsets.all(4),

                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      news: newsList[index],
                                    )),
                          )
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.radio,
                                size: 20,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                newsList[index].source.name,
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                                maxLines: 2,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                newsList[index].publishedAt.split("T")[0],
                                style: GoogleFonts.lato(
                                    fontSize: 12, fontStyle: FontStyle.italic),
                                maxLines: 2,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: BlocProvider<NewsListBloc>(
          create: (BuildContext contest) {
            return NewsListBloc(newsListRepo: NewsListRepo())
              ..add(FetchNewsListEvent());
          },
          child: BlocBuilder<NewsListBloc, NewsListState>(
            builder: (context, state) {
              var showProgressBar = false;
              var isDataPresent = false;
              var isErrorPresent = false;
              String errorMessage = '';

              List<NewsModel>? newsList;
              //--------when fetching----------------
              if (state is NewsListFetchingState) {
                showProgressBar = true;
                isDataPresent = false;
              }
              //------------when empty-------------
              else if (state is NewsListEmptyState) {
                showProgressBar = false;
                isDataPresent = false;
              }
              //-----------when fetched successfully-----------------
              else if (state is NewsListFetchedState) {
                // final stateAsSalesInvoiceServiceLedgerFetchedState = state;
                showProgressBar = false;
                isDataPresent = true;
                newsList = state.newsList;
              }
              //---------nothing happened show error----------
              else if (state is NewsListErrorState) {
                isErrorPresent = true;
                showProgressBar = false;
                isDataPresent = false;
                String errorMessage = state.message.toString();
              } else {
                return const Text("error");
              }
              return ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(onChanged: (str) {
                      _debouncer.run(() {
                        BlocProvider.of<NewsListBloc>(context)
                            .add(SearchNewsListEvent(str));
                      });
                    }),
                    showProgressBar
                        ? Container(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: ShimmerEffectBlockDash(200))
                        : isErrorPresent
                            ? Status500Card(
                                onpressedRetry: () {
                                  BlocProvider.of<NewsListBloc>(context)
                                      .add(FetchNewsListEvent());
                                },
                                hideImage: true)
                            : isDataPresent
                                ? outputScreen(newsList!, context)
                                : const Text("No data present"),
                  ]);
            },
          ),
        ));
  }
}

Widget showError() {
  return const Center(
    child: Text(
      "Not News Found, Hope world is safe",
      style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: 18),
    ),
  );
}