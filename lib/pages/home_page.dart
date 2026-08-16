import 'package:flutter/material.dart';
import 'package:endophone/pages/breathing_screen.dart';
import 'package:endophone/pages/soundscape_screen.dart';

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
        ),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoundscapeScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 186, 99),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.forest, size: 32),
                ),
              ),
/*
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.videogame_asset, size: 32),
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.restaurant, size: 32),
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YogaScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.self_improvement, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 8),
              Text('Quick dial'),*/
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
}