import 'package:endophone/theme.dart';
import 'package:endophone/widgets/breathing_circle.dart';
import 'package:endophone/widgets/feature_card.dart';
import 'package:endophone/widgets/quick_dial.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final featureTiles = [
      FeatureCard(
        icon: Icons.forest_rounded,
        label: 'Soundscape',
        color: const Color.fromARGB(255, 231, 204, 149),
        onTap: () => Navigator.pushNamed(context, '/soundscape'),
      ),
      FeatureCard(
        icon: Icons.videogame_asset_rounded,
        label: 'Games',
        color: const Color.fromARGB(255, 206, 167, 212),
        onTap: () => Navigator.pushNamed(context, '/games'),
      ),
      FeatureCard(
        icon: Icons.restaurant_rounded,
        label: 'Food',
        color: const Color.fromARGB(255, 239, 175, 199),
        onTap: () => Navigator.pushNamed(context, '/food'),
      ),
      FeatureCard(
        icon: Icons.spa_rounded,
        label: 'Yoga',
        color: const Color.fromARGB(255, 185, 196, 221),
        onTap: () => Navigator.pushNamed(context, '/yoga'),
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            stretch: true,
            pinned: true,
            backgroundColor: AppTheme.softCream,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: AppTheme.blushPink,
                  ),
                  Positioned(
                    left: 16,
                    top: 44,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/diary'),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.softCream,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.book_rounded, size: 18),
                            SizedBox(width: 6),
                            Text('Diary'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                'Endophone',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.only(bottom: 12),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: BreathingCircle(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  for (final tile in featureTiles) tile,
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick dial',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.deepBrown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const QuickDial(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
