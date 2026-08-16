import 'package:flutter/material.dart';
import 'package:endophone/pages/breathing_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 205, 172),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
//
          SliverAppBar(
            expandedHeight: 150,
            stretch: true,
            pinned: true,
            backgroundColor:  Color.fromARGB(255, 243, 245, 239),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color:  Color.fromARGB(255, 235, 160, 195),
              ),
              title: Text(
                'Endophone',
                style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              centerTitle: true,
              
            ),
          ),
//
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child:BreathingScreen(),
          ),
        )
        ],

      )
      
    );
  }
}