class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory CandleData.fromJson(Map<String, dynamic> json, int index) {
    return CandleData(
      date: DateTime.fromMillisecondsSinceEpoch(
        json['timestamps'][index] * 1000,
      ),
      open: (json['opens'][index] as num).toDouble(),
      high: (json['highs'][index] as num).toDouble(),
      low: (json['lows'][index] as num).toDouble(),
      close: (json['closes'][index] as num).toDouble(),
    );
  }
}
