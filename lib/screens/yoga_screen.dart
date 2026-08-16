import 'package:endophone/services/database_service.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaPose {
  final String title;
  final String description;
  final String imagePath;

  const YogaPose({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  final List<Map<String, dynamic>> _videos = [];
  final List<YogaPose> _poses = const [
    YogaPose(
      title: 'Supta Baddha Konasana',
      description: 'Calms breathing and opens the pelvis, chest, and lower back.',
      imagePath: 'assets/images/supta_baddha_konasana.jpg',
    ),
    YogaPose(
      title: 'Balasana',
      description: 'Helps ease discomfort and cramping by stretching your hips, glutes, and spine.',
      imagePath: 'assets/images/balasana.jpg',
    ),
    YogaPose(
      title: 'Supine Spinal Twist',
      description: 'Opens up your chest and relieves tight hips.',
      imagePath: 'assets/images/supine_spinal_twist.jpg',
    ),
    YogaPose(
      title: 'Supta Virasana',
      description: 'Helps in reducing pain and bloating by stretching your pelvis and abdomen.',
      imagePath: 'assets/images/supta_virasana.jpg',
    ),
    YogaPose(
      title: 'Viparita Karani',
      description: 'Helps you relax and relieves cramping pain by reducing blood pooling.',
      imagePath: 'assets/images/viparita_karani.jpg',
    ),
  ];
  final List<YogaPose> _hiddenPoses = [];
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

  void _dismissPose(YogaPose pose) {
    if (_hiddenPoses.contains(pose)) return;

    setState(() {
      _hiddenPoses.add(pose);
    });
  }

  void _restorePose(YogaPose pose) {
    if (!_hiddenPoses.contains(pose)) return;

    setState(() {
      _hiddenPoses.remove(pose);
    });
  }

  Widget _buildPoseCard(
    YogaPose pose, {
    required bool isHidden,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Image.asset(
                    pose.imagePath,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              pose.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pose.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (isHidden) {
                      _restorePose(pose);
                    }
                  },
                  icon: const Icon(Icons.thumb_up_alt_rounded),
                  color: Colors.green,
                  tooltip: isHidden ? 'Restore pose' : 'Good fit',
                ),
                IconButton(
                  onPressed: () {
                    if (!isHidden) {
                      _dismissPose(pose);
                    }
                  },
                  icon: const Icon(Icons.thumb_down_alt_rounded),
                  color: Colors.red,
                  tooltip: isHidden ? 'Already hidden' : 'Move to later',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiblePoses = _poses.where((pose) => !_hiddenPoses.contains(pose)).toList();
    final hiddenPoses = _poses.where((pose) => _hiddenPoses.contains(pose)).toList();

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
              color: AppTheme.blushPink.withValues(alpha: 0.18),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Stop the stretch or exercise if it increases the pain.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Suggested stretches',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...visiblePoses.map((pose) => _buildPoseCard(pose, isHidden: false)),
            const SizedBox(height: 20),
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
            if (hiddenPoses.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Saved for later',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...hiddenPoses.map((pose) => _buildPoseCard(pose, isHidden: true)),
            ],
          ],
        ),
      ),
    );
  }
}
