import 'package:flutter/material.dart';

class QuizEngineScreen extends StatelessWidget {
  const QuizEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Engine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Bar Placeholder
            LinearProgressIndicator(
              value: 0.5, // Placeholder value
              backgroundColor: Colors.grey[700],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
            const SizedBox(height: 32),
            // Question Text
            const Text(
              'What is the capital of France?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Answer Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Berlin')),
                  ElevatedButton(onPressed: () {}, child: const Text('Madrid')),
                  ElevatedButton(onPressed: () {}, child: const Text('Paris')),
                  ElevatedButton(onPressed: () {}, child: const Text('Rome')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
