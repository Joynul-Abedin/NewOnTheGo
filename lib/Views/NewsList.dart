import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Google Ads/BannerAds.dart';
import '../Models/new_article_entity.dart';
import '../Services/NewsApiService.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> with TickerProviderStateMixin {
  late Future<List<NewArticleEntity>> futureNews;
  bool isLoading = false;
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  List<String> categories = [];
  List<String> sources = [];
  late TabController _tabController;
  String? selectedSource;

  BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
        onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        }),
  );

  @override
  void initState() {
    super.initState();
    myBanner.load();
    futureNews = NewsApiService().fetchNews();
    updateCategories();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    myBanner.dispose();
    super.dispose();
  }

  List<Widget> buildTabs() {
    return categories.map((String category) {
      return Tab(text: category);
    }).toList();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      futureNews =
          NewsApiService().fetchNews(); // Fetch new data and update the Future
    });
  }

  Future<void> updateCategories() async {
    var news = await futureNews;
    setState(() {
      categories = extractCategories(news);
      sources = extractSources(news);
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  List<String> extractCategories(List<NewArticleEntity> news) {
    Set<String> categorySet = {};
    for (var article in news) {
      if (article.category != null && article.category!.isNotEmpty) {
        categorySet.add(article.category!);
      }
    }
    return categorySet.toList();
  }

  List<String> extractSources(List<NewArticleEntity> news) {
    Set<String> sourceSet = {};
    for (var article in news) {
      if (article.source != null && article.source!.isNotEmpty) {
        sourceSet.add(article.source!);
      }
    }
    return sourceSet.toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Latest News',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            DropdownButton<String>(
              value: selectedSource,
              icon: const Icon(Icons.filter_list),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSource = newValue;
                });
              },
              items: ['All', ...sources]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _handleRefresh();
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.black,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: buildTabs(),
          ),
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categories.map((String category) {
                    return _buildTabContent(category);
                  }).toList(),
                ),
              ),
              SizedBox(
                height: myBanner.size.height.toDouble(),
                child: BannerAdWidget(myBanner: myBanner),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String category) {
    return FutureBuilder<List<NewArticleEntity>>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset("assets/news_loading.json",
                  width: 100, height: 100));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news articles available'));
        } else {
          List<NewArticleEntity> filteredNews = snapshot.data!.where((element) {
            bool categoryMatch = element.category == category;
            bool sourceMatch = selectedSource == null ||
                selectedSource == 'All' ||
                element.source == selectedSource;
            return categoryMatch && sourceMatch;
          }).toList();

          return LiquidPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: filteredNews.length,
              itemBuilder: (context, index) {
                return _buildNewsItem(filteredNews[index]);
              },
            ),
          );
        }
      },
    );
  }

// Helper method to build each news item widget
  Widget _buildNewsItem(NewArticleEntity newsItem) {
    return GestureDetector(
      onTap: () => _launchUrl(newsItem.link!),
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
                    newsItem.image!.isNotEmpty
                        ? newsItem.image!
                        : 'https://blackhidesteakhouse.com.au/wp-content/uploads/2018/02/placeholder_image1.png',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newsItem.title!,
                      style: const TextStyle(
                        color: Colors.white,
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
                          newsItem.source!,
                          style: const TextStyle(color: Colors.white),
                        ),
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
  }

  Future<void> _launchUrl(String url) async {
    setState(() => isLoading = true);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration:
            const WebViewConfiguration(enableJavaScript: true))) {
      setState(() => isLoading = false);
      throw Exception('Could not launch $url');
    }
    setState(() => isLoading = false);
  }
}
