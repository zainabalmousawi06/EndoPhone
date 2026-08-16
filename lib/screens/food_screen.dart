import 'package:endophone/services/database_service.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final List<Map<String, dynamic>> _foods = [];
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Breakfast');
  final _notesController = TextEditingController();

  final List<String> _recommendedIngredients = [
    'berries',
    'walnuts',
    'sardines',
    'salmon',
    'oatmeal',
    'ricecakes',
    'spinach',
    'pumpkin',
  ];

  final List<String> _avoidIngredients = [
    'red meats',
    'sweets',
    'dairy',
    'caffeine',
  ];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final foods = await DatabaseService.instance.getFoods();
    if (!mounted) return;
    setState(() {
      _foods.clear();
      _foods.addAll(foods);
    });
  }

  Future<void> _saveFood() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await DatabaseService.instance.insertFood({
      'name': name,
      'category': _categoryController.text.trim().isEmpty ? 'Other' : _categoryController.text.trim(),
      'notes': _notesController.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });

    _nameController.clear();
    _notesController.clear();
    _categoryController.text = 'Breakfast';
    await _loadFoods();
  }

  Map<String, List<Map<String, dynamic>>> _groupFoods() {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final food in _foods) {
      final category = (food['category'] ?? 'Other').toString();
      map.putIfAbsent(category, () => []).add(food);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupFoods();

    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Foods & Nutrition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildIngredientSection(
              title: 'Recommended Ingredients',
              items: _recommendedIngredients,
              accentColor: AppTheme.oceanTeal,
            ),
            const SizedBox(height: 16),
            _buildIngredientSection(
              title: 'Ingredients to avoid',
              items: _avoidIngredients,
              accentColor: AppTheme.blushPink,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Meal or item'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _saveFood,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Add food'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (grouped.isEmpty)
              const Center(child: Text('No food entries yet.'))
            else ...grouped.entries.map((entry) {
              final category = entry.key;
              final items = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(category),
                  children: items.map((food) {
                    return ListTile(
                      title: Text(food['name'] ?? ''),
                      subtitle: Text(food['notes'] ?? ''),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSection({
    required String title,
    required List<String> items,
    required Color accentColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
