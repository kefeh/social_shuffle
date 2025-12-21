import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class FlipEngineScreen extends ConsumerStatefulWidget {
  const FlipEngineScreen({super.key});

  @override
  ConsumerState<FlipEngineScreen> createState() => _FlipEngineScreenState();
}

class _FlipEngineScreenState extends ConsumerState<FlipEngineScreen>
    with TickerProviderStateMixin {
  bool _hasChosen = false;
  bool _isTruth = false;
  Color _cardColor = Colors.white;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _hasChosen = ref.read(gameLoopProvider).currentCard.back?.isEmpty ?? true;
    _isTruth = ref.read(gameLoopProvider).currentCard.back?.isEmpty ?? true;
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
    Future.microtask(() {
      if (ref.read(gameLoopProvider).currentCard.back?.isEmpty ?? true) {
        _flipController.forward();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _makeChoice(bool isTruth) {
    setState(() {
      _hasChosen = true;
      _isTruth = isTruth;
      if (isTruth) {
        _cardColor = Colors.lightBlue.shade100;
      } else {
        _cardColor = Colors.red.shade100;
      }
    });
    _flipController.forward();
  }

  void _nextCard() {
    if (ref.watch(gameLoopProvider).isLastCard) {
      final Color backgroundColor =
          engineBackgroundColor[ref
              .read(gameLoopProvider)
              .currentDeck
              .gameEngineId] ??
          Color(0xFFA91079);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SummaryScreen(color: backgroundColor),
        ),
      );
    } else {
      ref.watch(gameLoopProvider.notifier).nextCard();
      if (ref.read(gameLoopProvider).currentCard.back?.isEmpty ?? true) {
        setState(() {
          _hasChosen = true;
          _flipController.reset();
          _flipController.forward();
        });
      } else {
        setState(() {
          _hasChosen = false;
          _flipController.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              engineBackgroundColor[gameLoopState.currentDeck.gameEngineId] ??
                  Color(0xFFA91079),
              Color(0xFF2E0249),
              Color(0xFF570A57),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: BackButton()),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        gameLoopState.currentDeck.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Expanded(
                child: Center(
                  child: _hasChosen
                      ? _buildRevealedCard() // State C: The Card
                      : _buildChoiceButtons(), // State A: The Buttons
                ),
              ),

              if (_hasChosen)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () => _nextCard(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Forfeit (Drink!)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () => _nextCard(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              shadowColor: Colors.greenAccent.withOpacity(0.4),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "DONE",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.check_circle, color: Colors.black87),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _makeChoice(true),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility, size: 80, color: Colors.white),
                  Text(
                    "TRUTH",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Honesty is key",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        // DARE BUTTON
        Expanded(
          child: GestureDetector(
            onTap: () => _makeChoice(false),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 80,
                    color: Colors.white,
                  ),
                  Text(
                    "DARE",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text("Risk it all", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedCard() {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;

        final isBackVisible = angle >= (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isBackVisible
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _cardContent(true),
                )
              : _cardContent(false),
        );
      },
    );
  }

  Widget _cardContent(bool isRevealed) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;
    return Container(
      height: 400,
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isRevealed ? _cardColor : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
      ),
      alignment: Alignment.center,
      child: isRevealed
          ? Text(
              _isTruth ? currentCard.content : currentCard.back ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          : const Icon(Icons.help_outline, size: 80, color: Colors.white24),
    );
  }
}
