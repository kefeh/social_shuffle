import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_library/widgets/card_engine_header.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class VotingEngineScreen extends ConsumerStatefulWidget {
  const VotingEngineScreen({super.key});

  @override
  ConsumerState<VotingEngineScreen> createState() => _VotingEngineScreenState();
}

class _VotingEngineScreenState extends ConsumerState<VotingEngineScreen>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  bool _isRoundActive = true;

  final int _secondsPerRound = 5;

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  void _setupTimer() {
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _secondsPerRound),
    );

    _timerController.reverse(from: 1.0);

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isRoundActive = false;
        });
      }
    });
  }

  void _nextCard() {
    final gameLoopState = ref.read(gameLoopProvider);

    if (gameLoopState.isLastCard) {
      _finishGame();
    } else {
      ref.read(gameLoopProvider.notifier).nextCard();
      setState(() {
        _isRoundActive = true;
      });
      _timerController.reverse(from: 1.0);
    }
  }

  void _finishGame() {
    ref.read(gameLoopProvider.notifier).finishGame();
    final Color backgroundColor =
        engineBackgroundColor[ref
            .read(gameLoopProvider)
            .currentDeck
            .gameEngineId] ??
        const Color(0xFFA91079);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryScreen(color: backgroundColor),
      ),
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    final Color baseColor =
        engineBackgroundColor[gameLoopState.currentDeck.gameEngineId] ??
        const Color(0xFFA91079);
    final Color accentColor = Colors.amberAccent;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, const Color(0xFF2E0249)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CardEngineHeader(showProgress: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuestionCard(content: currentCard.content),

                      const SizedBox(height: 50),

                      SizedBox(
                        height: 160,
                        child: _isRoundActive
                            ? VotingTimer(
                                controller: _timerController,
                                secondsTotal: _secondsPerRound,
                                color: accentColor,
                              )
                            : VotingControls(
                                onNext: _nextCard,
                                onFinish: _finishGame,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String content;

  const QuestionCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "WHO IS MOST LIKELY TO...",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E0249),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class VotingTimer extends StatelessWidget {
  final AnimationController controller;
  final int secondsTotal;
  final Color color;

  const VotingTimer({
    super.key,
    required this.controller,
    required this.secondsTotal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        int secondsRemaining = (controller.value * secondsTotal).ceil();

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: controller.value,
                strokeWidth: 8,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$secondsRemaining",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "THINK...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class VotingControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const VotingControls({
    super.key,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "3... 2... 1... POINT!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.amberAccent,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.flag_outlined),
            ),
            const SizedBox(width: 20),

            ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text("NEXT CARD"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2E0249),
                elevation: 5,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
