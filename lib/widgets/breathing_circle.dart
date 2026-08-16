import 'dart:async';

import 'package:flutter/material.dart';

class BreathingCircle extends StatefulWidget {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;

  const BreathingCircle({
    super.key,
    this.inhaleSeconds = 4,
    this.holdSeconds = 4,
    this.exhaleSeconds = 4,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _countdownTimer;
  String _phase = 'Inhale';
  int _remaining = 4;
  bool _isRunning = true;

  static const double minScale = 0.55;
  static const double maxScale = 1.0;

  @override
  void initState() {
    super.initState();
    _remaining = widget.inhaleSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.inhaleSeconds),
    )..addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    _startPhase('Inhale', widget.inhaleSeconds, maxScale);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      switch (_phase) {
        case 'Inhale':
          _startPhase('Inhale', widget.inhaleSeconds, maxScale);
          break;
        case 'Hold':
          _startPhase('Hold', widget.holdSeconds, maxScale);
          break;
        case 'Exhale':
          _startPhase('Exhale', widget.exhaleSeconds, minScale);
          break;
        case 'Hold2':
          _startPhase('Hold2', widget.holdSeconds, minScale);
          break;
        default:
          _startPhase('Inhale', widget.inhaleSeconds, maxScale);
      }
    } else {
      _pause();
    }
  }

  void _pause() {
    _countdownTimer?.cancel();
    _controller.stop();
  }

  void _startPhase(String phase, int seconds, double targetScale) {
    setState(() {
      _phase = phase;
      _remaining = seconds;
    });

    _controller.duration = Duration(seconds: seconds);
    final endValue = (targetScale - minScale) / (maxScale - minScale);
    _controller.animateTo(
      endValue,
      curve: Curves.easeInOut,
    );

    _countdownTimer?.cancel();
    var remaining = seconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      if (remaining <= 0 || !_isRunning) {
        timer.cancel();
        if (remaining <= 0 && _isRunning && mounted) {
          _nextPhase();
        }
      } else if (mounted) {
        setState(() {
          _remaining = remaining;
        });
      }
    });
  }

  void _nextPhase() {
    switch (_phase) {
      case 'Inhale':
        _startPhase('Hold', widget.holdSeconds, maxScale);
        break;
      case 'Hold':
        _startPhase('Exhale', widget.exhaleSeconds, minScale);
        break;
      case 'Exhale':
        _startPhase('Hold2', widget.holdSeconds, minScale);
        break;
      case 'Hold2':
        _startPhase('Inhale', widget.inhaleSeconds, maxScale);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = minScale + (_controller.value * (maxScale - minScale));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _phase,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 18),
          Transform.scale(
            scale: scale,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD7E4E5),
                    theme.colorScheme.primary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$_remaining',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          IconButton(
            onPressed: _toggle,
            icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle_fill),
            color: theme.colorScheme.onPrimary,
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
