import 'package:dhan_manthan/backend/user_api.dart';
import 'package:dhan_manthan/providers/expense_provider.dart';
import 'package:dhan_manthan/providers/debts_provider.dart';
import 'package:dhan_manthan/screens/ai_chat_screen.dart';
import 'package:dhan_manthan/screens/course_list.dart';
import 'package:dhan_manthan/screens/home_screen.dart';
import 'package:dhan_manthan/screens/news_screens/news_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbarScreen extends ConsumerStatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  ConsumerState<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends ConsumerState<BottomNavbarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CoursesScreen(),
    ChatScreen(),
    NewsListScreen(),
    Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24))),
  ];

  @override
  void initState() {
    super.initState();
    _checkUserAndFetch();
  }

  Future<void> _checkUserAndFetch() async {
    final isExist = await UserAPI.checkIfExist();
    if (!isExist) {
      await UserAPI.addUser();
    }

    // 👇 Preload expenses & debts
    ref.read(expenseProvider.notifier);
    ref.read(debtsProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
