import 'package:dhan_manthan/backend/stock_api.dart';
import 'package:dhan_manthan/models/stock_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockApiProvider = Provider<StockApiService>((ref) => StockApiService());

final candleDataProvider = FutureProvider.family<List<CandleData>, String>((
  ref,
  symbol,
) async {
  final api = ref.read(stockApiProvider);
  return await api.fetchCandleData(symbol);
});

final stockQuotesProvider = FutureProvider<List<StockQuote>>((ref) async {
  final api = ref.watch(stockApiProvider);

  // Add all the companies you want to show
  final symbols = [
    "RELIANCE.NS",
    "TCS.NS",
    "INFY.NS",
    "HDFCBANK.NS",
    "ICICIBANK.NS",
  ];

  return api.fetchMultipleStocks(symbols);
});
