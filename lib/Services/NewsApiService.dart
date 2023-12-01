import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/new_article_entity.dart';


class NewsApiService {
  final String baseUrl = 'https://news-on-the-go.onrender.com/'; // Replace with your API URL

  Future<List<NewArticleEntity>> fetchNews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => NewArticleEntity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
