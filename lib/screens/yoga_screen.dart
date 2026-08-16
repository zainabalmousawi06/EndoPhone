import 'package:endophone/services/database_service.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  final List<Map<String, dynamic>> _videos = [];
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final videos = await DatabaseService.instance.getYogaSessions();
    if (!mounted) return;
    setState(() {
      _videos.clear();
      _videos.addAll(videos);
    });
  }

  Future<void> _saveVideo() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) return;

    await DatabaseService.instance.insertYogaSession({
      'title': title,
      'url': url,
      'duration': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    _titleController.clear();
    _urlController.clear();
    await _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Yoga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Video title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(labelText: 'YouTube link'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _saveVideo,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Add video'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_videos.isEmpty)
              const Center(child: Text('No saved yoga videos yet.'))
            else ..._videos.map((video) {
              final title = video['title'] ?? 'Yoga video';
              final url = video['url'] ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill_rounded, color: AppTheme.oceanTeal),
                  title: Text(title),
                  subtitle: Text(url),
                  trailing: const Icon(Icons.open_in_new_rounded),
                  onTap: () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
