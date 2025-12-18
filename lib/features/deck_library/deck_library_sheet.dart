import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/providers/deck_provider.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_generator/deck_generator_dialog.dart';
import 'package:social_shuffle/features/deck_library/deck_details_sheet.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_card.dart';
import 'package:social_shuffle/features/game_config/game_config_screen.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class DeckLibrarySheet extends ConsumerWidget {
  final String gameModeTitle;
  final String gameEngineId;
  final Color backgroundColor;

  const DeckLibrarySheet({
    super.key,
    required this.gameModeTitle,
    required this.gameEngineId,
    required this.backgroundColor,
  });

  // void _showGeneratorDialog(BuildContext context, String initialGameEngineId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => DeckGeneratorDialog(
  //       initialGameEngineId: initialGameEngineId,
  //     ),
  //   );
  // }

  void _showDeckDetailsSheet(BuildContext context, Deck deck) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the modal to take full height
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8, // Take 80% of the screen height
        child: DeckDetailsSheet(deck: deck),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String deckId,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck?'),
        content: const Text('Are you sure you want to delete this deck?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(allDecksProvider.notifier).deleteDeck(deckId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsyncValue = ref.watch(decksProvider(gameEngineId));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3 * 2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [backgroundColor, Theme.of(context).scaffoldBackgroundColor],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '$gameModeTitle Decks',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            decksAsyncValue.when(
              data: (decks) => Flexible(
                child: ListView.builder(
                  itemCount: decks.length,
                  itemBuilder: (context, index) {
                    final deck = decks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DeckCard(
                        deck: deck,
                        onTap: () => _showDeckDetailsSheet(context, deck),
                        onDelete: deck.isSystem
                            ? null
                            : () => _confirmDelete(context, ref, deck.id),
                        onRemix: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Remix - Not implemented yet'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              loading: () => const Flexible(
                // Changed Expanded to Flexible
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Flexible(
                child: Center(child: Text('Error: $err')),
              ), // Changed Expanded to Flexible
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                // onPressed: () => _showGeneratorDialog(context, gameEngineId),
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Create New'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  foregroundColor: Colors.white,
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
