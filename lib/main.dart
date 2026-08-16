import 'package:endophone/screens/breathing_screen.dart';
import 'package:endophone/screens/diary_screen.dart';
import 'package:endophone/screens/food_screen.dart';
import 'package:endophone/screens/games_screen.dart';
import 'package:endophone/screens/home_screen.dart';
import 'package:endophone/screens/soundscape_screen.dart';
import 'package:endophone/screens/tetris_screen.dart';
import 'package:endophone/screens/yoga_screen.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App bootstraps before the first render.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Endophone',
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/diary': (_) => const DiaryScreen(),
        '/breathing': (_) => const BreathingScreen(),
        '/soundscape': (_) => const SoundscapeScreen(),
        '/games': (_) => const GamesScreen(),
        '/tetris': (_) => const TetrisScreen(),
        '/food': (_) => const FoodScreen(),
        '/yoga': (_) => const YogaScreen(),
      },
    );
  }
}