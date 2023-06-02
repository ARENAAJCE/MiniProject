
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:devu/loginandsignup/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  // ignore: non_constant_identifier_names
  Color TextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                child: const Image(
                    image: AssetImage("assets/Arena 'IN (2).png")))));
  }
}