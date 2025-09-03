import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhan_manthan/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // <-- Syncfusion

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      print("✅ Logout done");
    } catch (e) {
      print("❌ Error during logout: $e");
    }
  }

  final List<String> _companies = [
    "Apple",
    "Microsoft",
    "Amazon",
    "Google",
    "Tesla",
    "Meta",
    "Netflix",
    "Intel",
    "Nvidia",
    "Adobe",
  ];

  final List<MonthlyExpense> data = [
    MonthlyExpense('Jan', 500),
    MonthlyExpense('Feb', 450),
    MonthlyExpense('Mar', 600),
    MonthlyExpense('Apr', 550),
    MonthlyExpense('May', 700),
    MonthlyExpense('Jun', 650),
    MonthlyExpense('Jul', 600),
    MonthlyExpense('Aug', 750),
    MonthlyExpense('Sep', 800),
    MonthlyExpense('Oct', 700),
    MonthlyExpense('Nov', 650),
    MonthlyExpense('Dec', 900),
  ];

  String? selectedCompany = "Apple";

  final List<Map<String, String>> marketTrends = [
    {"company": "Apple", "price": "\$175.20", "change": "+1.5%"},
    {"company": "Tesla", "price": "\$725.40", "change": "-0.8%"},
    {"company": "Amazon", "price": "\$3,210.50", "change": "+0.9%"},
    {"company": "Google", "price": "\$2,940.30", "change": "+1.2%"},
    {"company": "Microsoft", "price": "\$325.10", "change": "-0.5%"},
  ];

  // Candlestick dummy data
  final Map<String, List<CandleData>> stockData = {
    "Apple": [
      CandleData(DateTime(2025, 9, 1), 170, 175, 168, 172),
      CandleData(DateTime(2025, 9, 2), 172, 176, 170, 174),
      CandleData(DateTime(2025, 9, 3), 174, 178, 172, 177),
      CandleData(DateTime(2025, 9, 4), 177, 180, 175, 179),
      CandleData(DateTime(2025, 9, 5), 179, 182, 177, 181),
    ],
    "Tesla": [
      CandleData(DateTime(2025, 9, 1), 710, 720, 705, 715),
      CandleData(DateTime(2025, 9, 2), 715, 725, 710, 720),
      CandleData(DateTime(2025, 9, 3), 720, 730, 715, 728),
    ],
    "Amazon": [
      CandleData(DateTime(2025, 9, 1), 3200, 3230, 3190, 3210),
      CandleData(DateTime(2025, 9, 2), 3210, 3240, 3200, 3230),
      CandleData(DateTime(2025, 9, 3), 3230, 3250, 3210, 3220),
    ],
    "Google": [
      CandleData(DateTime(2025, 9, 1), 2900, 2950, 2890, 2920),
      CandleData(DateTime(2025, 9, 2), 2920, 2960, 2910, 2940),
      CandleData(DateTime(2025, 9, 3), 2940, 2970, 2930, 2950),
    ],
    "Microsoft": [
      CandleData(DateTime(2025, 9, 1), 320, 325, 318, 322),
      CandleData(DateTime(2025, 9, 2), 322, 327, 321, 325),
      CandleData(DateTime(2025, 9, 3), 325, 328, 323, 326),
    ],
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<CandleData> selectedStock =
        stockData[selectedCompany] ?? stockData["Apple"]!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 247, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 247, 250),
        title: Row(
          children: [
            const CircleAvatar(),
            const SizedBox(width: 10),
            const Text(
              'Arsh Kumar Mandal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Today's Market Trends",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.show_chart, color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Dropdown
                    CustomDropdown.search(
                      hintText: "Select a company",
                      items: _companies,
                      excludeSelected: false,
                      onChanged: (value) {
                        setState(() {
                          selectedCompany = value;
                        });
                        print("Selected Company: $value");
                      },
                    ),
                    const SizedBox(height: 10),
                    // Horizontal scrollable market trend cards
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: marketTrends.length,
                        itemBuilder: (context, index) {
                          final trend = marketTrends[index];
                          return Container(
                            width: screenWidth * 0.45,
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  trend["company"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  trend["price"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  trend["change"]!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: trend["change"]!.startsWith('+')
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Candlestick Chart
                    SizedBox(
                      height: 250,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CandleSeries>[
                          CandleSeries<CandleData, DateTime>(
                            dataSource: selectedStock,
                            xValueMapper: (CandleData data, _) => data.date,
                            lowValueMapper: (CandleData data, _) => data.low,
                            highValueMapper: (CandleData data, _) => data.high,
                            openValueMapper: (CandleData data, _) => data.open,
                            closeValueMapper: (CandleData data, _) =>
                                data.close,
                            bullColor: Colors.green,
                            bearColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Track Expense & Debts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Add Expence",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Add Debt",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.blue)),
                      ),
                      child: Center(
                        child: Text(
                          "Track Expences",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.blue)),
                      ),
                      child: Center(
                        child: Text(
                          "Track Debts",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 150, // constrain the height explicitly
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          DoughnutSeries<MonthlyExpense, String>(
                            dataSource: data,
                            xValueMapper: (MonthlyExpense expense, _) =>
                                expense.month,
                            yValueMapper: (MonthlyExpense expense, _) =>
                                expense.amount,
                            dataLabelMapper: (MonthlyExpense expense, _) =>
                                "\$${expense.amount}",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside,
                            ),
                            radius: '80%',
                            innerRadius: '60%',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          DoughnutSeries<MonthlyExpense, String>(
                            dataSource: data,
                            xValueMapper: (MonthlyExpense expense, _) =>
                                expense.month,
                            yValueMapper: (MonthlyExpense expense, _) =>
                                expense.amount,
                            dataLabelMapper: (MonthlyExpense expense, _) =>
                                "\$${expense.amount}",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside,
                            ),
                            radius: '80%',
                            innerRadius: '60%',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Cources You can Try',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  animateToClosest: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(30),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                  child: Image.network(
                                    course["banner"],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.blue,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course["title"],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap:
                                                    true, // <-- allows line breaking
                                                overflow: TextOverflow
                                                    .visible, // <-- don't clip or fade
                                              ),
                                              Text(
                                                "By Arsh Ku. Mandal",
                                                style: TextStyle(fontSize: 11),
                                                softWrap:
                                                    true, // <-- allows line breaking
                                                overflow: TextOverflow
                                                    .visible, // <-- don't clip or fade
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: screenWidth * 0.07),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                239,
                                                248,
                                                255,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // aligns them properly
                                        children: [
                                          Icon(Icons.currency_rupee, size: 15),
                                          Text(
                                            "1500",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.star,
                                            size: 20,
                                            color: const Color.fromARGB(
                                              255,
                                              241,
                                              184,
                                              15,
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            "4.9(1700)",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Candle data model
class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.date, this.open, this.high, this.low, this.close);
}

class MonthlyExpense {
  final String month;
  final double amount;

  MonthlyExpense(this.month, this.amount);
}
