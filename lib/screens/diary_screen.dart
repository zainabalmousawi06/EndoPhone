import 'package:endophone/services/database_service.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final List<Map<String, dynamic>> _entries = [];
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _moodController = TextEditingController(text: 'Calm');

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await DatabaseService.instance.getDiaryEntries();
    if (!mounted) return;
    setState(() {
      _entries.clear();
      _entries.addAll(entries);
    });
  }

  Future<void> _saveEntry() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final mood = _moodController.text.trim().isEmpty ? 'Calm' : _moodController.text.trim();

    if (title.isEmpty && note.isEmpty) return;

    await DatabaseService.instance.insertDiaryEntry({
      'title': title,
      'note': note,
      'mood': mood,
      'created_at': DateTime.now().toIso8601String(),
    });

    _titleController.clear();
    _noteController.clear();
    _moodController.text = 'Calm';
    await _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Daily Diary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(labelText: 'Your reflections'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _moodController,
                      decoration: const InputDecoration(labelText: 'Mood'),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('No diary entries yet.'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (_, index) {
                        final entry = _entries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(entry['title'] ?? 'Untitled'),
                            subtitle: Text(entry['note'] ?? ''),
                            trailing: Text(entry['mood'] ?? 'Calm'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
