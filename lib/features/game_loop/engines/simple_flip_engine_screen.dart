import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_library/widgets/card_engine_header.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class SimpleFlipEngineScreen extends ConsumerStatefulWidget {
  const SimpleFlipEngineScreen({super.key});

  @override
  ConsumerState<SimpleFlipEngineScreen> createState() =>
      _SimpleFlipEngineScreenState();
}

class _SimpleFlipEngineScreenState extends ConsumerState<SimpleFlipEngineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  bool _isBackVisible = false; // Track visual state

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );

    // Listen to animation status to update UI state (for button visibility)
    _flipController.addListener(() {
      final isBack = _flipAnimation.value >= 0.5;
      if (isBack != _isBackVisible) {
        setState(() {
          _isBackVisible = isBack;
        });
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isBackVisible) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  void _nextCard() {
    final gameLoopState = ref.read(gameLoopProvider);
    if (gameLoopState.isLastCard) {
      _finishGame();
    } else {
      // 1. Reset card to front instantly without animation
      // (so the next card starts fresh)
      _flipController.reset();
      setState(() => _isBackVisible = false);

      // 2. Load next data
      ref.read(gameLoopProvider.notifier).nextCard();
    }
  }

  void _finishGame() {
    ref.read(gameLoopProvider.notifier).finishGame();
    final Color backgroundColor =
        engineBackgroundColor[ref
            .read(gameLoopProvider)
            .currentDeck
            .gameEngineId] ??
        const Color(0xFF2E0249);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryScreen(color: backgroundColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    // Check if we have a back side
    final bool hasBackContent =
        currentCard.back != null && currentCard.back!.trim().isNotEmpty;

    // Theme Colors
    final Color baseColor =
        engineBackgroundColor[gameLoopState.currentDeck.gameEngineId] ??
        const Color(0xFF4361EE);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, const Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // REUSABLE HEADER
              CardEngineHeader(),

              // THE CARD AREA
              Expanded(
                child: Center(
                  child: hasBackContent
                      ? GestureDetector(
                          onTap: _toggleFlip,
                          child: _buildFlippableCard(
                            currentCard.content,
                            currentCard.back!,
                          ),
                        )
                      : _buildStaticCard(currentCard.content),
                ),
              ),

              // BOTTOM CONTROLS
              // Logic: Show button if NO back content OR if back content IS visible
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: 24.0,
                ),
                child: SizedBox(
                  height: 60, // Fixed height to prevent layout shifts
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: (!hasBackContent || _isBackVisible) ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: hasBackContent && !_isBackVisible,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: baseColor,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "NEXT CARD",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  // 1. Static Card (For Hot Seat / Single Sided)
  Widget _buildStaticCard(String content) {
    return Container(
      height: 450,
      width: 320,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            height: 1.3,
          ),
        ),
      ),
    );
  }

  // 2. Animated Card (For Deep Dive / Two Sided)
  Widget _buildFlippableCard(String front, String back) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        // Rotation Math
        final angle = _flipAnimation.value * pi;
        final isBackSide = angle >= (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isBackSide
              ? Transform(
                  // Rotate text 180 deg so it's readable when flipped
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _buildCardFace(back, isBack: true),
                )
              : _buildCardFace(front, isBack: false),
        );
      },
    );
  }

  Widget _buildCardFace(String text, {required bool isBack}) {
    return Container(
      height: 450,
      width: 320,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isBack
            ? const Color(0xFF2E0249)
            : Colors.white, // Dark background for back side
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: isBack ? Border.all(color: Colors.white24, width: 2) : null,
      ),
      child: Stack(
        children: [
          // Visual Hint Icon
          if (!isBack)
            Align(
              alignment: Alignment.bottomCenter,
              child: Icon(
                Icons.touch_app,
                color: Colors.grey.withOpacity(0.3),
                size: 30,
              ),
            ),

          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: isBack ? Colors.white : const Color(0xFF1A1A2E),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
