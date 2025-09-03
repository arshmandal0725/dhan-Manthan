import 'dart:convert';
import 'package:dhan_manthan/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = "e39a1b24c0d04489b1e1f6512f8f1488";
  final String baseUrl = "https://newsapi.org/v2";

  Future<List<NewsArticle>> fetchFinancialNews() async {
    final url = Uri.parse(
      "$baseUrl/top-headlines?category=business&language=en&apiKey=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<NewsArticle> allNews = [];
      for (var news in data["articles"]) {
        allNews.add(NewsArticle.fromJson(news));
      }
      return allNews; // returns list of articles
    } else {
      throw Exception("Failed to load news: ${response.reasonPhrase}");
    }
  }
}
