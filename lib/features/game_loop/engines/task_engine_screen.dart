import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class TaskEngineScreen extends ConsumerStatefulWidget {
  const TaskEngineScreen({super.key});

  @override
  ConsumerState<TaskEngineScreen> createState() => _TaskEngineScreenState();
}

class _TaskEngineScreenState extends ConsumerState<TaskEngineScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late int _totalTime;
  int _secondsRemaining = 0;
  bool _isTimeUp = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1.0,
      upperBound: 1.1,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCardTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCardTimer() {
    final currentCard = ref.read(gameLoopProvider).currentCard;

    _totalTime = currentCard.meta?['timer'] ?? 60;

    setState(() {
      _secondsRemaining = _totalTime;
      _isTimeUp = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    setState(() {
      _isTimeUp = true;
    });

    _pulseController.repeat(reverse: true);

    HapticFeedback.heavyImpact();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => HapticFeedback.heavyImpact(),
    );
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => HapticFeedback.heavyImpact(),
    );

    SystemSound.play(SystemSoundType.click);
  }

  void _processNextCard(bool success) {
    _pulseController.stop();
    _pulseController.value = 1.0;

    if (success) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    final gameLoopState = ref.read(gameLoopProvider);

    if (gameLoopState.isLastCard) {
      ref.read(gameLoopProvider.notifier).finishGame();
      _timer?.cancel();

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
      ref.read(gameLoopProvider.notifier).nextCard();

      _startCardTimer();
    }
  }

  Color _getTimerColor() {
    if (_isTimeUp) return Colors.redAccent;
    double percentage = _secondsRemaining / _totalTime;
    if (percentage > 0.5) return Colors.greenAccent;
    if (percentage > 0.2) return Colors.amber;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;
    final List<dynamic>? forbiddenWords = currentCard.meta?['forbidden_words'];
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
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ScaleTransition(
                scale: _isTimeUp
                    ? _pulseController
                    : const AlwaysStoppedAnimation(1.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _totalTime > 0
                            ? _secondsRemaining / _totalTime
                            : 0,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTimerColor(),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$_secondsRemaining",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _getTimerColor(),
                          ),
                        ),
                        const Text(
                          "SEC",
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: Column(
                    key: ValueKey(currentCard.content),
                    children: [
                      Text(
                        currentCard.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),

                      if (forbiddenWords != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "DON'T SAY:",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ...forbiddenWords.map(
                                (e) => Text(
                                  e,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () => _processNextCard(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "PASS",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
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
                          onPressed: () => _processNextCard(true),
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
                                "GOT IT!",
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
            ],
          ),
        ),
      ),
    );
  }
}
