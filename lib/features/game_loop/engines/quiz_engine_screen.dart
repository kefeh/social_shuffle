import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_library/widgets/card_engine_header.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class QuizEngineScreen extends ConsumerStatefulWidget {
  const QuizEngineScreen({super.key});

  @override
  ConsumerState<QuizEngineScreen> createState() => _QuizEngineScreenState();
}

class _QuizEngineScreenState extends ConsumerState<QuizEngineScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  int numCorrectAnswers = 0;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleAnswerSelection(int index, int correctIndex) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _selectedAnswerIndex = index;
    });

    if (index == correctIndex) {
      _animController.forward(from: 0.0);
      numCorrectAnswers += 1;
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.vibrate();
    }
  }

  void _handleNext() {
    final gameLoopState = ref.read(gameLoopProvider);

    setState(() {
      _hasAnswered = false;
      _selectedAnswerIndex = null;
      _animController.reset();
    });

    if (gameLoopState.isLastCard) {
      final score =
          numCorrectAnswers /
          ref.read(gameLoopProvider).currentDeck.cards.length;
      ref.read(gameLoopProvider.notifier).finishGame();
      final Color backgroundColor =
          engineBackgroundColor[ref
              .read(gameLoopProvider)
              .currentDeck
              .gameEngineId] ??
          Color(0xFFA91079);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              SummaryScreen(score: score, color: backgroundColor),
        ),
      );
    } else {
      ref.read(gameLoopProvider.notifier).nextCard();
    }
  }

  Color _getButtonColor(int index, int correctIndex) {
    if (!_hasAnswered) return Colors.white;

    if (index == correctIndex) {
      return Colors.greenAccent.shade400;
    }

    if (index == _selectedAnswerIndex && index != correctIndex) {
      return Colors.redAccent;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: DecoratedBox(
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
            children: [
              CardEngineHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double totalWidth = constraints.maxWidth;
                    final int totalCards =
                        gameLoopState.currentDeck.cards.length;
                    final int currentIndex = gameLoopState.currentCardIndex;
                    final double progress = (currentIndex + 1) / totalCards;

                    double iconLeftPos = (totalWidth * progress) - 24;
                    if (iconLeftPos < 0) iconLeftPos = 0;
                    if (iconLeftPos > totalWidth - 30) {
                      iconLeftPos = totalWidth - 30;
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 10,
                          width: totalWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          height: 10,
                          width: totalWidth * progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.greenAccent, Colors.cyan],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          left: iconLeftPos,
                          top: -12,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  currentCard.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              if (currentCard.options != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: currentCard.options!.length,
                    itemBuilder: (context, index) {
                      final optionText = currentCard.options![index];
                      final isCorrect = index == currentCard.correctIndex;

                      final bool shouldAnimate = _hasAnswered && isCorrect;

                      return ScaleTransition(
                        scale: shouldAnimate
                            ? _scaleAnimation
                            : const AlwaysStoppedAnimation(1.0),
                        child: GestureDetector(
                          onTap: () => _handleAnswerSelection(
                            index,
                            currentCard.correctIndex!,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: _getButtonColor(
                                index,
                                currentCard.correctIndex!,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border:
                                  _hasAnswered && index == _selectedAnswerIndex
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              optionText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _hasAnswered
                                    ? (index == currentCard.correctIndex
                                          ? Colors.black
                                          : Colors.black87)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(
                height: 80,
                child: _hasAnswered
                    ? Center(
                        child: ElevatedButton.icon(
                          onPressed: _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            gameLoopState.isLastCard
                                ? "Finish Quiz"
                                : "Next Question",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
