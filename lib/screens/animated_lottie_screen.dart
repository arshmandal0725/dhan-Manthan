import 'dart:async';
import 'package:dhan_manthan/screens/bottom_navbar_screen.dart';
import 'package:dhan_manthan/screens/home_screen.dart';
import 'package:dhan_manthan/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;
import 'package:lottie/lottie.dart';

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (FirebaseAuth.instance.currentUser != null) {
        User? user = FirebaseAuth.instance.currentUser;
        print('Current user: $user');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => BottomNavbarScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => LoginScreen()),
        );
      }
    });
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
