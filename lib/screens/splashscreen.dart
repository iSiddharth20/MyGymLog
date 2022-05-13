import 'package:flutter/material.dart';
import 'package:mygymlog/constants/color.dart';
import 'package:mygymlog/screens/bottomnavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void showRelevant() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavigation()),
          (route) => false);
  }
   @override
  void initState() {
    super.initState();
    showRelevant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Spacer(),
            Text("Hi There !"),
            SizedBox(height: 50),
            Text("Happy Workout !"),
            Spacer()
          ],
        ),
      ),
    );
  }
}