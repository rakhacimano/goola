import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goola/pages/home_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
        backgroundColor: const Color(0xFF0F1511),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 64),
              child: Column(
                children: [
                  title(),
                  const Spacer(),
                  image(),
                  const Spacer(),
                  ctaButton(context),
                ],
              ),
            ),
          ),
        ));
  }

  ElevatedButton ctaButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFFFEED55),
        foregroundColor: const Color(0xFF0F1511),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
        child: Text(
          'Get Started',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Image image() {
    return Image.asset(
      'assets/images/img_onboarding.png',
    );
  }

  Text title() {
    return const Text(
      'Complete \nSetup and start \ntracking ur Glucose...',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
