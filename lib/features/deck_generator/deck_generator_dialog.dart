import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/deck_provider.dart';
import 'package:social_shuffle/core/services/ai_service.dart';
import 'package:social_shuffle/features/deck_generator/widgets/mixing_cards_animation.dart';

class DeckGeneratorDialog extends ConsumerStatefulWidget {
  const DeckGeneratorDialog({super.key});

  @override
  ConsumerState<DeckGeneratorDialog> createState() => _DeckGeneratorDialogState();
}

class _DeckGeneratorDialogState extends ConsumerState<DeckGeneratorDialog> {
  final _topicController = TextEditingController();
  final _vibeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _generateDeck() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final aiService = AIService();
      final generatedDeck = await aiService.generateDeck(
        _topicController.text,
        _vibeController.text,
      );
      await ref.read(deckListProvider.notifier).addDeck(generatedDeck);
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The bartender dropped the cards. Try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate New Deck'),
      content: SingleChildScrollView(
        child: _isLoading
            ? const MixingCardsAnimation()
            : ListBody(
                children: <Widget>[
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      labelText: 'Topic',
                      hintText: 'e.g., "90s Movies"',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _vibeController,
                    decoration: const InputDecoration(
                      labelText: 'Vibe (Optional)',
                      hintText: 'e.g., "Funny and chaotic"',
                    ),
                  ),
                ],
              ),
      ),
      actions: <Widget>[
        if (!_isLoading)
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        if (!_isLoading)
          ElevatedButton(
            onPressed: _generateDeck,
            child: const Text('Generate'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    _vibeController.dispose();
    super.dispose();
  }
}
