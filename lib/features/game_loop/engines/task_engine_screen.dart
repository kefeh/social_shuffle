import 'package:flutter/material.dart';

class TaskEngineScreen extends StatelessWidget {
  const TaskEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Engine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Placeholder
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '00:30',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            // Big Text (Target Word)
            const Text(
              'Elephant',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Subtext (Forbidden words/Rules)
            Text(
              'Forbidden: Trunk, Grey, Large, Africa',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            const SizedBox(height: 32),
            // Placeholder for Gyroscope/Button controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Pass'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Got it!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
