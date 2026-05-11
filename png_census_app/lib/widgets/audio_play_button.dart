import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayButton extends StatefulWidget {
  const AudioPlayButton({super.key, required this.assetPath, this.label});

  /// Path relative to the assets/ folder, e.g. "audio/q001.mp3"
  final String assetPath;
  final String? label;

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  final _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else if (_playerState == PlayerState.paused) {
      await _player.resume();
    } else {
      await _player.play(AssetSource(widget.assetPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;
    return OutlinedButton.icon(
      onPressed: widget.assetPath.isEmpty ? null : _toggle,
      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 20),
      label: Text(
        widget.label ?? (isPlaying ? 'Pause' : 'Play Audio'),
        style: const TextStyle(fontSize: 13),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.indigo,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
