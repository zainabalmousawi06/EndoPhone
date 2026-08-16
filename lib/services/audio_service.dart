// services/audio_service.dart
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class AudioService{
  AudioService._();
  static final AudioService instance = AudioService._();

  bool _initialized = false;
  final Map<String, AudioSource> _loadedSounds={};
  final Map<String, SoundHandle> _activeSounds={};

  Future<void> init() async{
    if (_initialized) return;
    await SoLoud.instance.init();
    _initialized = true;
  }

  Future<AudioSource> loadAsset(String name, String assetPath) async{
    await init();
    if (_loadedSounds.containsKey(name)) return _loadedSounds[name]!;

    final tempDir= await getTemporaryDirectory();
    final file= File(
        '${tempDir.path}/${name.toLowerCase().replaceAll(' ', '_')}.mp3');
    final byteData= await rootBundle.load(assetPath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    final source= await SoLoud.instance.loadFile(file.path);
    _loadedSounds[name]= source;
    return source;
  }

  Future<void> addSound(String name, {double volume = 0.5}) async {
    final source= _loadedSounds[name];
    if (source==null) return;

    if (_activeSounds.containsKey(name)){
      SoLoud.instance.setVolume(_activeSounds[name]!, volume);
      return;
    }

    final handle = SoLoud.instance.play(
      source,
      looping: true,
      volume: volume,
    );
    _activeSounds[name] = handle;
  }

  Future<void> removeSound(String name) async{
    final handle= _activeSounds[name];
    if (handle!=null) {
      await SoLoud.instance.stop(handle);
      _activeSounds.remove(name);
    }
  }

  Future<void> setVolume(String name, double volume) async{
    final handle= _activeSounds[name];
    if (handle!= null) {
      SoLoud.instance.setVolume(handle, volume);
    }
  }

  Future<bool> toggleSound(String name, double volume) async{
    if (_activeSounds.containsKey(name)) {
      await removeSound(name);
      return false;
    } 
    else{
      await addSound(name, volume: volume);
      return true;
    }
  }

  Future<void> stopAll() async {
    for (final handle in _activeSounds.values) {
      await SoLoud.instance.stop(handle);
    }
    _activeSounds.clear();
  }


  bool isActive(String name) => _activeSounds.containsKey(name);
  Set<String> get activeSounds => Set.unmodifiable(_activeSounds.keys);
  bool get hasAnySound => _activeSounds.isNotEmpty;
}
