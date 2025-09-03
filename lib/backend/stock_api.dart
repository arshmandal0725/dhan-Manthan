import 'dart:convert';
import 'package:dhan_manthan/models/stock_model.dart';
import 'package:http/http.dart' as http;

class StockApiService {
  final String baseUrl =
      "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v3/get-chart";

  Future<List<StockQuote>> fetchMultipleStocks(List<String> symbols) async {
    final uri = Uri.parse(
      "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?symbols=${symbols.join(',')}&region=IN",
    );

    final response = await http.get(
      uri,
      headers: {
        "X-RapidAPI-Key": "ba8fa1b848msh1f013619c4d439fp1189c7jsn5aa9728527d2",
        "X-RapidAPI-Host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List quotes = data['quoteResponse']['result'];

      return quotes
          .map(
            (q) => StockQuote(
              symbol: q['symbol'],
              price: (q['regularMarketPrice'] as num).toDouble(),
              changePercent: (q['regularMarketChangePercent'] as num)
                  .toDouble(),
            ),
          )
          .toList();
    } else {
      throw Exception("Failed to fetch stock quotes");
    }
  }

  Future<List<CandleData>> fetchCandleData(
    String symbol, {
    String range = "1d",
    String interval = "5m",
  }) async {
    final uri = Uri.parse(
      "$baseUrl?interval=$interval&symbol=$symbol&range=$range",
    );

    final response = await http.get(
      uri,
      headers: {
        "X-RapidAPI-Key": "ba8fa1b848msh1f013619c4d439fp1189c7jsn5aa9728527d2",
        "X-RapidAPI-Host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['chart']['result'] == null) {
        throw Exception(
          jsonData['chart']['error']?['description'] ?? "No data found",
        );
      }

      final chart = jsonData['chart']['result'][0];
      final timestamps = List<int>.from(chart['timestamp']);
      final quote = chart['indicators']['quote'][0];

      List<CandleData> candles = [];

      for (int i = 0; i < timestamps.length; i++) {
        final open = quote['open'][i];
        final high = quote['high'][i];
        final low = quote['low'][i];
        final close = quote['close'][i];

        // Skip null entries
        if (open != null && high != null && low != null && close != null) {
          candles.add(
            CandleData(
              date: DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000),
              open: (open as num).toDouble(),
              high: (high as num).toDouble(),
              low: (low as num).toDouble(),
              close: (close as num).toDouble(),
            ),
          );
        }
      }

      return candles;
    } else {
      throw Exception(
        "Failed to fetch stock chart data. Status code: ${response.statusCode}",
      );
    }
  }
}

class StockQuote {
  final String symbol;
  final double price;
  final double changePercent;

  StockQuote({
    required this.symbol,
    required this.price,
    required this.changePercent,
  });
}
