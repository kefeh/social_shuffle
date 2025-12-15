import 'package:flutter/material.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class FlipEngineScreen extends StatefulWidget {
  const FlipEngineScreen({super.key});

  @override
  State<FlipEngineScreen> createState() => _FlipEngineScreenState();
}

class _FlipEngineScreenState extends State<FlipEngineScreen> {
  bool _showFront = true;

  void _toggleCard() {
    setState(() {
      _showFront = !_showFront;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card flipped!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.blueGrey,
            child: SizedBox(
              width: 300,
              height: 400,
              child: Center(
                child: Text(
                  _showFront ? 'Front of Card' : 'Back of Card',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
