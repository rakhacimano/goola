import 'package:flutter/material.dart';
import 'package:goola/pages/onboarding_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
        (route) => false);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_app.png',
              height: 48,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Your Insulin Tracker',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
          ],
        ),
      ),
    );
  }
}
