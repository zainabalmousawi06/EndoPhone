import 'package:endophone/theme.dart';
import 'package:endophone/widgets/breathing_circle.dart';
import 'package:flutter/material.dart';

class BreathingScreen extends StatelessWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Breathing'),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: BreathingCircle(
              inhaleSeconds: 5,
              holdSeconds: 5,
              exhaleSeconds: 5,
            ),
          ),
        ),
      ),
    );
  }
}
