import 'package:flutter/material.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class VotingEngineScreen extends StatefulWidget {
  const VotingEngineScreen({super.key});

  @override
  State<VotingEngineScreen> createState() => _VotingEngineScreenState();
}

class _VotingEngineScreenState extends State<VotingEngineScreen> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SummaryScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SummaryScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Statement Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Most likely to accidentally join a cult?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 64),
            // Countdown Display
            Text(
              '$_countdown',
              style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
