import 'package:flutter/material.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class GameConfigScreen extends StatefulWidget {
  final Deck deck;

  const GameConfigScreen({super.key, required this.deck});

  @override
  State<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends State<GameConfigScreen> {
  bool _isTimerEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Timer'),
              value: _isTimerEnabled,
              onChanged: (value) {
                setState(() {
                  _isTimerEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Sound'),
              value: _isSoundEnabled,
              onChanged: (value) {
                setState(() {
                  _isSoundEnabled = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Pass the config to the game loop
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameLoopScreen(deck: widget.deck),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
