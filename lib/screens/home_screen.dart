import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhan_manthan/models/new_debts_model.dart';
import 'package:dhan_manthan/models/new_expense.dart';
import 'package:dhan_manthan/models/stock_model.dart';
import 'package:dhan_manthan/providers/debts_provider.dart';
import 'package:dhan_manthan/providers/expense_provider.dart';
import 'package:dhan_manthan/providers/stock_provider.dart';
import 'package:dhan_manthan/screens/add_debts/debts_screen.dart';
import 'package:dhan_manthan/screens/add_expense/expense_screen.dart';
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

  String? selectedCompany = "RELIANCE.NS";
  int _isSelected = 0;

  final List<Map<String, String>> courses = [
    {
      "banner": "https://picsum.photos/seed/course1/800/400",
      "title": "Flutter Essentials",
    },
    {
      "banner": "https://picsum.photos/seed/course2/800/400",
      "title": "Dart Deep Dive",
    },
    {
      "banner": "https://picsum.photos/seed/course3/800/400",
      "title": "State Management",
    },
    {
      "banner": "https://picsum.photos/seed/course4/800/400",
      "title": "UI/UX for Mobile",
    },
    {
      "banner": "https://picsum.photos/seed/course5/800/400",
      "title": "Portfolio Projects",
    },
  ];

  final List<Color> monthColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final expenseAsync = ref.watch(expenseProvider);
    final debtAsync = ref.watch(debtsProvider);
    final List<String> _companies = indianStocks.keys.toList();

    final stockAsyncValue = ref.watch(candleDataProvider(selectedCompany!));
    final stockListAsyncValue = ref.watch(stockQuotesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 247, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 247, 250),
        elevation: 0,
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
              // Market Trends Card
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
                      child: stockListAsyncValue.when(
                        data: (stocks) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stocks.length,
                            itemBuilder: (context, index) {
                              final stock = stocks[index];
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.45,
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
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
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
              // Expense & Debts header
              Text(
                'Track Expense & Debts',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Buttons
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ExpenseHomescreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Add Expense",
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (builder) => HomeDebt()),
                        );
                      },
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

              const SizedBox(height: 10),

              // Toggle tabs (Expense / Debts)
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected = 0;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: (_isSelected == 0)
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Track Your Expense",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected = 1;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: (_isSelected == 1)
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Track Your Debts",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Show Expense or Debt chart based on _isSelected
              const SizedBox(height: 20),
              (_isSelected == 0)
                  ? _buildExpenseChart(expenseAsync)
                  : _buildDebtChart(debtAsync),
              const SizedBox(height: 20),

              // Courses carousel
              Text(
                'Courses You can Try',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  animateToClosest: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                ),
                items: courses.map((course) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                  child: Image.network(
                                    course["banner"]!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
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
                                                course["title"]!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                              const Text(
                                                "By Arsh Ku. Mandal",
                                                style: TextStyle(fontSize: 11),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: screenWidth * 0.07),
                                          Container(
                                            padding: const EdgeInsets.all(5),
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
                                            child: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.currency_rupee, size: 15),
                                          Text(
                                            "1500",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.star,
                                            size: 20,
                                            color: Color.fromARGB(
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

  // Expense Chart
  Widget _buildExpenseChart(AsyncValue<List<Expense>> expenseAsync) {
    return expenseAsync.when(
      data: (List<Expense> expenseList) {
        final currentYear = DateTime.now().year;
        final currentYearExpenses = expenseList
            .where((e) => e.date.year == currentYear)
            .toList();

        if (currentYearExpenses.isEmpty) {
          return const Center(child: Text("No expenses for current year"));
        }

        final Map<int, double> monthlyTotals = {};
        for (final e in currentYearExpenses) {
          final m = e.date.month;
          monthlyTotals[m] = (monthlyTotals[m] ?? 0) + e.amount;
        }

        final expenses = monthlyTotals.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
        final List<MonthlyExpense> monthlyExpenseList = expenses
            .map(
              (entry) =>
                  MonthlyExpense(_getMonthShortName(entry.key), entry.value),
            )
            .toList();

        return SizedBox(
          height: 350,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              DoughnutSeries<MonthlyExpense, String>(
                dataSource: monthlyExpenseList,
                xValueMapper: (MonthlyExpense expense, _) => expense.month,
                yValueMapper: (MonthlyExpense expense, _) => expense.amount,
                pointColorMapper: (MonthlyExpense expense, index) =>
                    monthColors[index % 12],
                dataLabelMapper: (MonthlyExpense expense, _) =>
                    "\₹${expense.amount.toStringAsFixed(2)}",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
                radius: '80%',
                innerRadius: '60%',
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading expenses")),
    );
  }

  // Debt Chart
  Widget _buildDebtChart(AsyncValue<List<Debt>> debtAsync) {
    return debtAsync.when(
      data: (List<Debt> debtList) {
        if (debtList.isEmpty) {
          return const Center(child: Text("No debts available"));
        }

        return SizedBox(
          height: 350,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              DoughnutSeries<Debt, String>(
                dataSource: debtList,
                xValueMapper: (Debt debt, _) => debt.title,
                yValueMapper: (Debt debt, _) => debt.amount,
                pointColorMapper: (Debt debt, _) =>
                    debt.category == Catgory.plus ? Colors.green : Colors.red,
                dataLabelMapper: (Debt debt, _) =>
                    "\₹${debt.amount.toStringAsFixed(2)}",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
                radius: '80%',
                innerRadius: '60%',
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading debts")),
    );
  }

  String _getMonthShortName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return monthNames[month - 1];
  }
}

class MonthlyExpense {
  final String month;
  final double amount;

  MonthlyExpense(this.month, this.amount);
}
