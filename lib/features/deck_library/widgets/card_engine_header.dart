import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_library/widgets/game_instructions_sheet.dart';
import 'package:social_shuffle/shared/constants.dart';

class CardEngineHeader extends ConsumerWidget {
  final VoidCallback? onBack;
  final bool showProgress;
  final String? titleOverride;

  const CardEngineHeader({
    super.key,
    this.onBack,
    this.showProgress = true,
    this.titleOverride,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final int current = gameLoopState.currentCardIndex + 1;
    final int total = gameLoopState.currentDeck.cards.length;
    final String title = titleOverride ?? gameLoopState.currentDeck.title;

    final double progress = total > 0 ? current / total : 0.0;

    final helpDescription =
        gameLoopState.currentDeck.howToPlay?.description ?? '';
    final helpSteps = (gameLoopState.currentDeck.howToPlay?.steps ?? [])
        .map(
          (instruction) => GameInstructionStep(
            title: instruction.title,
            description: instruction.description,
            icon: getIconFromName(instruction.iconName),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  tooltip: 'Exit Game',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.question_mark_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => GameInstructionsSheet.show(
                    context,
                    gameTitle: title,
                    description: helpDescription,
                    steps: helpSteps,
                  ),
                  tooltip: 'How to Play',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ],
          ),

          if (showProgress) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black26,
                      color: Colors.amberAccent,
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "$current/$total",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
