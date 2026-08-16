import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickDial extends StatefulWidget {
  const QuickDial({super.key});

  @override
  State<QuickDial> createState() => _QuickDialState();
}

class _QuickDialState extends State<QuickDial> {
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _phoneNumber = prefs.getString('quick_dial_number') ?? '';
    });
  }

  Future<void> _savePhoneNumber(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quick_dial_number', value.trim());
    if (!mounted) return;
    setState(() {
      _phoneNumber = value.trim();
    });
  }

  Future<void> _promptForNumber() async {
    final controller = TextEditingController(text: _phoneNumber);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quick dial contact'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              hintText: '+1 555 123 4567',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      await _savePhoneNumber(result);
    }
  }

  Future<void> _launchQuickDial() async {
    final cleanedNumber = _phoneNumber.trim();
    if (cleanedNumber.isEmpty) {
      await _promptForNumber();
      return;
    }

    final uri = Uri(scheme: 'tel', path: cleanedNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await _promptForNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Center(
          child: ElevatedButton.icon(
            onPressed: _launchQuickDial,
            icon: const Icon(Icons.phone_in_talk_rounded, size: 28),
            label: Text(_phoneNumber.isEmpty ? 'Set quick dial' : 'Quick dial'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              minimumSize: const Size(220, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                fontFamily: 'LexendGiga',
              ),
            ),
          ),
        ),
        if (_phoneNumber.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton.icon(
              onPressed: _promptForNumber,
              icon: const Icon(Icons.edit_rounded),
              label: Text(_phoneNumber),
            ),
          ),
      ],
    );
  }
}
