import 'dart:async';
import 'dart:math' as math;

import 'package:endophone/theme.dart';
import 'package:flutter/material.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  static const int cols = 10;
  static const int rows = 20;
  static const double blockSize = 28;

  final List<List<int>> _board = List.generate(
    rows,
    (_) => List.filled(cols, 0),
  );

  late List<List<int>> _currentPiece;
  late int _currentX;
  late int _currentY;
  late Color _currentColor;
  late Timer _timer;

  int _score = 0;
  bool _isGameOver = false;

  final List<List<List<int>>> _pieceShapes = [
    // I
    [
      [1, 1, 1, 1],
    ],
    // O
    [
      [1, 1],
      [1, 1],
    ],
    // T
    [
      [0, 1, 0],
      [1, 1, 1],
    ],
    // L
    [
      [1, 0, 0],
      [1, 1, 1],
    ],
    // J
    [
      [0, 0, 1],
      [1, 1, 1],
    ],
    // S
    [
      [0, 1, 1],
      [1, 1, 0],
    ],
    // Z
    [
      [1, 1, 0],
      [0, 1, 1],
    ],
  ];

  final List<Color> _colors = [
    const Color(0xFFBFD9DE),
    const Color(0xFF5F9EA0),
    const Color(0xFFEBB7CB),
    const Color(0xFFE6BA63),
    const Color(0xFF90CDA8),
    const Color(0xFF749B7D),
    const Color(0xFF8F6A58),
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isGameOver) {
        setState(() {
          _stepDown();
        });
      }
    });
  }

  void _resetGame() {
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        _board[y][x] = 0;
      }
    }

    _score = 0;
    _isGameOver = false;
    _spawnPiece();
  }

  void _spawnPiece() {
    final random = math.Random();
    final pieceIndex = random.nextInt(_pieceShapes.length);
    _currentPiece = _pieceShapes[pieceIndex].map((row) => [...row]).toList();
    _currentX = (cols - _currentPiece[0].length) ~/ 2;
    _currentY = 0;
    _currentColor = _colors[pieceIndex % _colors.length];

    if (_collides(_currentPiece, _currentX, _currentY)) {
      _isGameOver = true;
      _timer.cancel();
    }
  }

  bool _collides(List<List<int>> piece, int x, int y) {
    for (var row = 0; row < piece.length; row++) {
      for (var col = 0; col < piece[row].length; col++) {
        if (piece[row][col] == 0) continue;

        final boardX = x + col;
        final boardY = y + row;

        if (boardX < 0 || boardX >= cols || boardY >= rows) {
          return true;
        }

        if (boardY >= 0 && _board[boardY][boardX] != 0) {
          return true;
        }
      }
    }
    return false;
  }

  void _moveLeft() {
    if (_isGameOver) return;
    if (!_collides(_currentPiece, _currentX - 1, _currentY)) {
      setState(() {
        _currentX--;
      });
    }
  }

  void _moveRight() {
    if (_isGameOver) return;
    if (!_collides(_currentPiece, _currentX + 1, _currentY)) {
      setState(() {
        _currentX++;
      });
    }
  }

  void _rotate() {
    if (_isGameOver) return;

    final rotated = List.generate(
      _currentPiece[0].length,
      (_) => List.filled(_currentPiece.length, 0),
    );

    for (var y = 0; y < _currentPiece.length; y++) {
      for (var x = 0; x < _currentPiece[y].length; x++) {
        rotated[x][ _currentPiece.length - 1 - y] = _currentPiece[y][x];
      }
    }

    final testX = _currentX;
    final testY = _currentY;

    if (!_collides(rotated, testX, testY)) {
      setState(() {
        _currentPiece = rotated;
      });
    }
  }

  void _stepDown() {
    if (_isGameOver) return;

    if (!_collides(_currentPiece, _currentX, _currentY + 1)) {
      _currentY++;
    } else {
      _lockPiece();
    }
  }

  void _lockPiece() {
    for (var y = 0; y < _currentPiece.length; y++) {
      for (var x = 0; x < _currentPiece[y].length; x++) {
        if (_currentPiece[y][x] == 0) continue;

        final boardX = _currentX + x;
        final boardY = _currentY + y;

        if (boardY >= 0) {
          _board[boardY][boardX] = 1;
        }
      }
    }

    _clearLines();
    _spawnPiece();
  }

  void _clearLines() {
    var cleared = 0;

    for (var y = rows - 1; y >= 0; y--) {
      if (_board[y].every((cell) => cell != 0)) {
        _board.removeAt(y);
        _board.insert(0, List.filled(cols, 0));
        cleared++;
        y++;
      }
    }

    if (cleared > 0) {
      _score += cleared * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sageGreen,
      appBar: AppBar(
        title: const Text('Tetris'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: $_score',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _timer.cancel();
                      _resetGame();
                      _startTimer();
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: Container(
                    width: 300,
                    height: 600,
                    decoration: BoxDecoration(
                      color: AppTheme.softCream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.deepBrown.withValues(alpha: 0.3)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cellWidth = blockSize;
                        final cellHeight = blockSize;

                        return Stack(
                          children: [
                            for (var y = 0; y < rows; y++)
                              for (var x = 0; x < cols; x++)
                                Positioned(
                                  left: x * cellWidth,
                                  top: y * cellHeight,
                                  width: cellWidth,
                                  height: cellHeight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        width: 0.5,
                                      ),
                                      color: _board[y][x] == 0
                                          ? Colors.transparent
                                          : AppTheme.oceanTeal,
                                    ),
                                  ),
                                ),
                            if (!_isGameOver)
                              for (var y = 0; y < _currentPiece.length; y++)
                                for (var x = 0; x < _currentPiece[y].length; x++)
                                  if (_currentPiece[y][x] != 0)
                                    Positioned(
                                      left: (_currentX + x) * cellWidth,
                                      top: (_currentY + y) * cellHeight,
                                      width: cellWidth,
                                      height: cellHeight,
                                      child: Container(
                                        color: _currentColor,
                                        margin: const EdgeInsets.all(1),
                                      ),
                                    ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _moveLeft,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    iconSize: 32,
                  ),
                  IconButton(
                    onPressed: _rotate,
                    icon: const Icon(Icons.rotate_right_rounded),
                    iconSize: 32,
                  ),
                  IconButton(
                    onPressed: _moveRight,
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    iconSize: 32,
                  ),
                  IconButton(
                    onPressed: () {
                      if (!_isGameOver) {
                        setState(() {
                          _stepDown();
                        });
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 32,
                  ),
                ],
              ),
              if (_isGameOver)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Game Over',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.deepBrown,
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
