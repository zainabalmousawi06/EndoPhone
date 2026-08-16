import 'package:endophone/services/audio_service.dart';
import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';

class SoundscapeScreen extends StatefulWidget {
  const SoundscapeScreen({super.key});

  @override
  State<SoundscapeScreen> createState() => _SoundscapeScreenState();
}

class _SoundscapeScreenState extends State<SoundscapeScreen> {
  final List<SoundLayer> _layers = [
    SoundLayer('Rain', Icons.water_drop, 'assets/sounds/rain.mp3'),
    SoundLayer('Wind', Icons.air, 'assets/sounds/wind.mp3'),
    SoundLayer('Birds', Icons.flutter_dash, 'assets/sounds/birds.mp3'),
    SoundLayer('Ocean', Icons.waves, 'assets/sounds/ocean.mp3'),
    SoundLayer('Crackling Fire', Icons.local_fire_department, 'assets/sounds/fire.mp3'),
    SoundLayer('White Noise', Icons.blur_on, 'assets/sounds/white_noise.mp3'),
    SoundLayer('Wind Chimes', Icons.notifications_active, 'assets/sounds/chimes.mp3'),
  ];

  bool _isLoading = true;
  final Map<String, double> _volumes = {};

  @override
  void initState() {
    super.initState();
    _initSounds();
  }

  Future<void> _initSounds() async {
    try {
      for (final layer in _layers) {
        await AudioService.instance.loadAsset(layer.name, layer.asset);
        _volumes[layer.name] = 0.5;
      }
    } catch (e, st) {
      debugPrint('Failed to load sounds: $e');
      debugPrint('$st');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleLayer(SoundLayer layer) async {
    await AudioService.instance.toggleSound(layer.name, _volumes[layer.name]!);
    if (mounted) setState(() {});
  }

  Future<void> _updateVolume(SoundLayer layer, double volume) async {
    setState(() => _volumes[layer.name] = volume);
    await AudioService.instance.setVolume(layer.name, volume);
  }

  Future<void> _stopAll() async {
    await AudioService.instance.stopAll();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.sageGreen,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activeCount = AudioService.instance.activeSounds.length;

    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Soundscape Mixer'),
        actions: [
          if (activeCount > 0)
            TextButton.icon(
              onPressed: _stopAll,
              icon: const Icon(Icons.stop, color: Color.fromARGB(255, 98, 74, 74)),
              label: const Text(
                'Stop All',
                style: TextStyle(color: Color.fromARGB(255, 98, 74, 74)),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusBanner(activeCount),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _layers.length,
              itemBuilder: (context, index) => _buildLayerCard(_layers[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(int activeCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: activeCount > 0 ? Colors.blue.shade50 : Colors.grey.shade100,
      child: Row(
        children: [
          Icon(
            activeCount > 0 ? Icons.graphic_eq : Icons.headphones,
            color: activeCount > 0 ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activeCount == 0
                  ? 'Tap sounds below to start your mix'
                  : '$activeCount sound${activeCount == 1 ? "" : "s"} playing • Mix and match!',
              style: TextStyle(
                color: activeCount > 0 ? Colors.blue.shade900 : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerCard(SoundLayer layer) {
    final isActive = AudioService.instance.isActive(layer.name);
    final volume = _volumes[layer.name]!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: isActive ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _toggleLayer(layer),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.blue.shade100 : Colors.grey.shade100,
                    ),
                    child: Icon(
                      layer.icon,
                      size: 28,
                      color: isActive ? Colors.blue : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          layer.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.blue.shade900 : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? 'Tap to remove' : 'Tap to add',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${(volume * 100).round()}%',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: isActive ? 1.0 : 0.5,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.blue,
                    thumbColor: isActive ? Colors.blue : Colors.grey,
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: (value) => _updateVolume(layer, value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoundLayer {
  final String name;
  final IconData icon;
  final String asset;

  SoundLayer(this.name, this.icon, this.asset);
}
