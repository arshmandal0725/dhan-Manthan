import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhan_manthan/constant.dart';
import 'package:dhan_manthan/models/stock_model.dart';
import 'package:dhan_manthan/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, String> indianStocks = {
    'Reliance Industries': 'RELIANCE.NS',
    'Tata Consultancy Services': 'TCS.NS',
    'Infosys': 'INFY.NS',
    'HDFC Bank': 'HDFCBANK.NS',
    'ICICI Bank': 'ICICIBANK.NS',
    'Hindustan Unilever': 'HINDUNILVR.NS',
    'State Bank of India': 'SBIN.NS',
    'Bharti Airtel': 'BHARTIARTL.NS',
    'Larsen & Toubro': 'LT.NS',
    'Maruti Suzuki': 'MARUTI.NS',
    'Asian Paints': 'ASIANPAINT.NS',
    'Wipro': 'WIPRO.NS',
    'Axis Bank': 'AXISBANK.NS',
    'Kotak Mahindra Bank': 'KOTAKBANK.NS',
    'Bajaj Finance': 'BAJFINANCE.NS',
    'Nestle India': 'NESTLEIND.NS',
    'Mahindra & Mahindra': 'M&M.NS',
    'Power Grid Corporation': 'POWERGRID.NS',
    'Titan Company': 'TITAN.NS',
    'UltraTech Cement': 'ULTRACEMCO.NS',
  };

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

  String? selectedCompany = "RELIANCE.NS";

  final List<Map<String, String>> marketTrends = [
    {"company": "Apple", "price": "\$175.20", "change": "+1.5%"},
    {"company": "Tesla", "price": "\$725.40", "change": "-0.8%"},
    {"company": "Amazon", "price": "\$3,210.50", "change": "+0.9%"},
    {"company": "Google", "price": "\$2,940.30", "change": "+1.2%"},
    {"company": "Microsoft", "price": "\$325.10", "change": "-0.5%"},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<String> _companies = indianStocks.keys.toList();

    final stockAsyncValue = ref.watch(candleDataProvider(selectedCompany!));
    final stocListkAsyncValue = ref.watch(stockQuotesProvider);

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
                    CustomDropdown.search(
                      hintText: "Select a company",
                      items: _companies,
                      excludeSelected: false,
                      initialItem: _companies[0],
                      onChanged: (value) {
                        setState(() {
                          selectedCompany = indianStocks[value];
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: SizedBox(
                        height: 120,
                        child: stocListkAsyncValue.when(
                          data: (stocks) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stocks.length,
                              itemBuilder: (context, index) {
                                final stock = stocks[index];
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  margin: const EdgeInsets.only(right: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        stock.symbol,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "\₹${stock.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${stock.changePercent.toStringAsFixed(2)}%",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: stock.changePercent >= 0
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          loading: () {
                            // Placeholder while loading
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .grey[300], // light grey placeholder
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                );
                              },
                            );
                          },
                          error: (err, stack) =>
                              Center(child: Text("Error loading stocks: $err")),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: stockAsyncValue.when(
                        data: (candles) {
                          if (candles.isEmpty) {
                            return const Center(
                              child: Text("No data available"),
                            );
                          }
                          return SfCartesianChart(
                            primaryXAxis: DateTimeAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <CandleSeries>[
                              CandleSeries<CandleData, DateTime>(
                                dataSource: candles,
                                xValueMapper: (CandleData data, _) => data.date,
                                lowValueMapper: (CandleData data, _) =>
                                    data.low,
                                highValueMapper: (CandleData data, _) =>
                                    data.high,
                                openValueMapper: (CandleData data, _) =>
                                    data.open,
                                closeValueMapper: (CandleData data, _) =>
                                    data.close,
                                bullColor: Colors.green,
                                bearColor: Colors.red,
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text("Error: $err")),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Track Expense & Debts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Add Expence",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
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
              const SizedBox(height: 20),
              Row(
                children: [
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
              const SizedBox(height: 20),
              Text(
                'Cources You can Try',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(30),
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
                                  borderRadius: BorderRadius.only(
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
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                              Text(
                                                "By Arsh Ku. Mandal",
                                                style: TextStyle(fontSize: 11),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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

class MonthlyExpense {
  final String month;
  final double amount;

  MonthlyExpense(this.month, this.amount);
}
