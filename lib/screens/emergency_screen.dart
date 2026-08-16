import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _contactController = TextEditingController();
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _enabled = prefs.getBool('emergency_enabled') ?? false;
      _contactController.text = prefs.getString('emergency_contact') ?? '112';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emergency_enabled', _enabled);
    await prefs.setString('emergency_contact', _contactController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Emergency'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety check-in',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _enabled,
                  title: const Text('Enable quick assistance'),
                  onChanged: (value) {
                    setState(() => _enabled = value);
                    _saveSettings();
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency contact number',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _saveSettings(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri(scheme: 'tel', path: _contactController.text.trim());
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('Call now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
