import 'dart:async';
import 'package:dhan_manthan/providers/news_provider.dart';
import 'package:dhan_manthan/providers/stock_provider.dart';
import 'package:dhan_manthan/screens/bottom_navbar_screen.dart';
import 'package:dhan_manthan/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;
import 'package:lottie/lottie.dart';

// Convert to ConsumerStatefulWidget so we can use ref
class AnimatedScreen extends ConsumerStatefulWidget {
  const AnimatedScreen({super.key});

  @override
  ConsumerState<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends ConsumerState<AnimatedScreen> {
  @override
  void initState() {
    super.initState();

    _preloadData();
  }

  Future<void> _preloadData() async {
    try {
      // Preload both providers
      final selectedCompany = "RELIANCE.NS"; // or use your state provider
      await ref.read(candleDataProvider(selectedCompany).future);
      await ref.read(stockQuotesProvider.future);
      await ref.watch(financialNewsProvider);

      // Wait a little for splash effect
      await Future.delayed(const Duration(seconds: 2));

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => const BottomNavbarScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        );
      }
    } catch (e) {
      print("Error preloading data: $e");
      // Even if error, move to login/home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/Animation - 1720009363777.json'),
          const SpinKitCircle(color: Colors.blue, size: 70),
        ],
      ),
    );
  }
}
