import 'package:flutter/material.dart';

class GameLoopScreen extends StatelessWidget {
  final Widget engine;

  const GameLoopScreen({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    return engine;
  }
}