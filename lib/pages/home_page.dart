import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 205, 200),
      appBar: AppBar(
        
      ),
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 100,
            collapsedHeight: 80,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Endophone',
                style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              

              centerTitle: true,
            ),
          ),

          
        ],

      )
      
    );
  }
}