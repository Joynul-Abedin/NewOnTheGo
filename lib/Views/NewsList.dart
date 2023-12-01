import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/new_article_entity.dart';
import '../Services/NewsApiService.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  late Future<List<NewArticleEntity>> futureNews;
  bool isLoading = false; // Add this line


  @override
  void initState() {
    super.initState();
    futureNews = NewsApiService().fetchNews();
  }

  Widget _loadingIndicator() {
    return isLoading
        ? Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    )
        : const SizedBox.shrink(); // Return an empty widget when not loading
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewArticleEntity>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if something went wrong
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle the case where there is no data
          return const Center(child: Text('No news articles available'));
        } else {
          // Data is loaded, display the list of articles
          List<NewArticleEntity> news = snapshot.data!;
          return Stack(
            children: [
              ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _launchUrl(news[index].link!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                  news[index].image!.isNotEmpty
                                      ? news[index].image!
                                      : 'https://blackhidesteakhouse.com.au/wp-content/uploads/2018/02/placeholder_image1.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    news[index].title!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        news[index].source!,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      // IconButton(onPressed: (){}, icon: const Icon(Icons.share, size: 14.0,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              _loadingIndicator(), // Overlay loading indicator
            ],
          );
        }
      },
    );
  }


  Future<void> _launchUrl(String url) async {
    setState(() => isLoading = true); // Start loading
    if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(enableJavaScript: true))) {
      setState(() => isLoading = false); // Stop loading on error
      throw Exception('Could not launch $url');
    }
    setState(() => isLoading = false); // Stop loading once the page starts loading
  }
}
