import 'package:dhan_manthan/constants.dart';
import 'package:dhan_manthan/screens/bottom_navbar_screen.dart';
import 'package:dhan_manthan/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();

    // Attempt to sign in silently to keep the user logged in
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null && mounted) {
        // Sign in to Firebase
        final googleAuth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavbarScreen()),
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final constants = Constants(context: context);
    double screenHeight = constants.height;
    double screenWidth = constants.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.0,
            colors: [Colors.lightBlue, Colors.white],
            stops: [0.05, 1.0],
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & App Name
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/dhan_manthan-removebg-preview (1).png',
                      scale: 2.5,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'DhanManthan',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Welcome back! Select method to login',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: screenWidth * 0.1),

                // Email Field
                TextField(
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Enter your Email',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 206, 232, 244),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Password Field
                TextField(
                  obscureText: true,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 206, 232, 244),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Remember me & Forgot Password
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('Remember me'),
                    const Spacer(),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),

                // Login Button (email login placeholder)
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement email login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Divider
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 186, 183, 183),
                        thickness: 1,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Or Continue with',
                      style: TextStyle(
                        color: Color.fromARGB(255, 133, 127, 127),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 186, 183, 183),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // Google & Apple Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              204,
                              224,
                              240,
                            ),
                          ),
                          onPressed: _handleSignIn, // Google sign-in
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/google.png', scale: 5),
                              const SizedBox(width: 10),
                              const Text(
                                'Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              204,
                              224,
                              240,
                            ),
                          ),
                          onPressed: () {
                            // TODO: implement Apple sign-in
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/apple.png', scale: 5),
                              const SizedBox(width: 10),
                              const Text(
                                'Apple',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Don't have an account? "),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
