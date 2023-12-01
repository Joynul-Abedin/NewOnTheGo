import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/NewsArticle.dart';
import '../Services/NewsApiService.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  late Future<List<NewsArticle>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsApiService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsArticle>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<NewsArticle>? news = snapshot.data;
          return ListView.builder(
            itemCount: news?.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(news![index].imageUrl, width: 100, fit: BoxFit.cover),
                title: Text(news[index].title),
                subtitle: Text(news[index].source),
                onTap: () => _launchURL(news[index].link),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
