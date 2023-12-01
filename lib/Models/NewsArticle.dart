class NewsArticle {
  final int id;
  final String title;
  final String link;
  final String imageUrl;
  final String source;
  final String category;

  NewsArticle({required this.id, required this.title, required this.link, required this.imageUrl, required this.source, required this.category});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'],
      title: json['title'],
      link: json['link'],
      imageUrl: json['image'],
      source: json['source'],
      category: json['category'],
    );
  }
}
