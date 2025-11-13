import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_bang_gia/helper/utils.dart';
import 'package:ui_bang_gia/widgets/market/top_indices.dart';

class AnimatedTopIndices extends StatefulWidget {
  const AnimatedTopIndices({super.key});

  @override
  State<AnimatedTopIndices> createState() => _AnimatedTopIndicesState();
}

class _AnimatedTopIndicesState extends State<AnimatedTopIndices> {
  Timer? _flashTimer;
  final Map<String, IndexFlashState> _flashStates = {};
  final Random _random = Random();

  final indices = [
    {'label': 'VNI', 'value': '1,718.21', 'change': '-12.98', 'percent': '-0.75', 'KL': '109.47', 'GT': '3,224'},
    {'label': 'VN30', 'value': '1,961.73', 'change': '-15.41', 'percent': '-0.78', 'KL': '37.91', 'GT': '1,640'},
    {'label': 'HNX', 'value': '275.96', 'change': '-0.15', 'percent': '-0.05', 'KL': '8.84', 'GT': '235'},
    {'label': 'HNX30', 'value': '608.42', 'change': '+0.28', 'percent': '+0.05', 'KL': '6.42', 'GT': '189'},
    {'label': 'UPCOM', 'value': '112.3', 'change': '-0.37', 'percent': '-0.33', 'KL': '3.12', 'GT': '61'},
    {'label': 'VN100', 'value': '1,898.37', 'change': '-10.03', 'percent': '-0.53', 'KL': '63.98', 'GT': '2,399'},
  ];

  @override
  void initState() {
    super.initState();
    _startFlashAnimation();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _startFlashAnimation() {
    _flashTimer = Timer.periodic(Duration(milliseconds: 500 + _random.nextInt(500)), (timer) {
      if (!mounted) return;

      final numToFlash = 1 + _random.nextInt(2);
      final availableIndices = List<int>.generate(indices.length, (i) => i);

      setState(() {
        _flashStates.removeWhere((key, value) => DateTime.now().difference(value.timestamp).inMilliseconds > 200);

        for (int i = 0; i < numToFlash && availableIndices.isNotEmpty; i++) {
          final indexIndex = availableIndices[_random.nextInt(availableIndices.length)];
          availableIndices.remove(indexIndex);

          final label = indices[indexIndex]['label']!;
          final percent = indices[indexIndex]['percent']!;
          final color = getChangeColor(percent);

          final fields = ['value', 'change', 'percent'];
          final fieldToFlash = fields[_random.nextInt(fields.length)];

          final key = '$label-$fieldToFlash';
          _flashStates[key] = IndexFlashState(
            label: label,
            field: fieldToFlash,
            color: color,
            timestamp: DateTime.now(),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildTopIndices(indices,_flashStates);
  }
}

class IndexFlashState {
  final String label;
  final String field;
  final Color color;
  final DateTime timestamp;

  IndexFlashState({
    required this.label,
    required this.field,
    required this.color,
    required this.timestamp,
  });
}
