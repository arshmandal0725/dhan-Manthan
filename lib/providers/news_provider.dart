import 'package:dhan_manthan/backend/news_api.dart';
import 'package:dhan_manthan/models/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for NewsService
final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService();
});

// 2. FutureProvider for fetching financial news
final financialNewsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  return service.fetchFinancialNews();
});
