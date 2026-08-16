import 'package:endophone/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'services/audio_service.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'LexendGiga',
            fontSize: 15,
            letterSpacing:1.5,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 145, 113, 86),
          )
        )
      ),  
    );
     
  }
}