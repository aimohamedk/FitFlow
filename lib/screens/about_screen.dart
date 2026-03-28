import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 100,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              const Text(
                'FitFlow',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Version: 1.0.0',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 28),
              const Text(
                'Developed by:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Abdullahi Issack Mohamed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sunan Ltd – Nairobi, Kenya',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '+254708001930',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const Text(
                'FitFlow is built to deliver a clean fullscreen guided workout experience with looped exercise videos and automatic timers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.45),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
