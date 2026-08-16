import 'package:flutter/material.dart';
import 'dart:async';

class BreathingScreen extends StatefulWidget {
  final int inhaleSec;
  final int holdSec;
  final int exhaleSec;

  const BreathingScreen({super.key, this.inhaleSec=4, this.holdSec=4, this.exhaleSec=4});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  Timer? _countdownTimer;
  String _phase='Inhale';
  late int _countdown;
  bool _isRunning=false;

  static const double _minScale=0.5;
  static const double _maxScale=1.0;

  @override
  void initState() {
    super.initState();
    _countdown = widget.inhaleSec;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.inhaleSec),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isRunning=true);
      _startPhase('Inhale', widget.inhaleSec, _maxScale);
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggle(){
    setState(()=> _isRunning=!_isRunning);
    if(_isRunning){
      switch(_phase){
        case 'Inhale':
          _startPhase('Inhale', widget.inhaleSec, _maxScale);
          break;
        case 'Hold':
          _startPhase('Hold', widget.holdSec, _maxScale);
          break;
        case 'Exhale':
          _startPhase('Exhale', widget.exhaleSec, _minScale);
          break;
        case 'Hold2':
          _startPhase('Hold2', widget.holdSec, _minScale);
          break;
        default:
          _startPhase('Inhale', widget.inhaleSec, _maxScale);
      }
    }
    else{
      _pause();
    }
  }

  void _pause(){
    _countdownTimer?.cancel();
    _controller.stop();
  }

  void _startPhase(String phase, int seconds, double targetScale){
    setState((){
      _phase=phase;
      _countdown=seconds;
    });

    _controller.duration=Duration(seconds: seconds);
    _controller.animateTo(
      (targetScale - _minScale) / (_maxScale - _minScale),
      curve: Curves.easeInOut,
    );

    _countdownTimer?.cancel();
    int remaining=seconds;
    _countdownTimer=Timer.periodic(const Duration(seconds:1), (timer) {
      remaining--;
      if(remaining <= 0 || !_isRunning){
        timer.cancel();
        if(remaining<=0 && _isRunning && mounted){
          _nextPhase();
        }
      }
      else{
        if(mounted){
          setState(() => _countdown=remaining);
        }
      }
    });
  }

  void _nextPhase(){
    switch(_phase){
      case 'Inhale':
        _startPhase('Hold', widget.holdSec, _maxScale);
        break;
      case 'Hold':
        _startPhase('Exhale', widget.exhaleSec, _minScale);
        break;
      case 'Exhale':
        _startPhase('Hold2', widget.holdSec, _minScale);
        break;
      case 'Hold2':
        _startPhase('Inhale', widget.inhaleSec, _maxScale);
        break;
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 116, 155, 125),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedOpacity(
        opacity: _isRunning ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Text(
            _phase,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'LexendGiga',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, childe){
              final scale=_minScale+(_controller.value*(_maxScale-_minScale));
              return Transform.scale(
                scale:scale,
                child:Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [const Color.fromARGB(255, 215, 228, 229), const Color.fromARGB(255, 126, 210, 210)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 142, 179, 191).withValues(alpha:0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: Icon(_isRunning ? Icons.pause : Icons.play_circle),
            color: Colors.white,
            iconSize: 40,
            onPressed: _toggle,
          ),
        ],

      ),
    ),
    );
  }
}