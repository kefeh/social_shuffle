import 'package:flutter/material.dart';

class MixingCardsAnimation extends StatefulWidget {
  const MixingCardsAnimation({super.key});

  @override
  State<MixingCardsAnimation> createState() => _MixingCardsAnimationState();
}

class _MixingCardsAnimationState extends State<MixingCardsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation1;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: const Offset(0.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation2 = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: const Offset(-0.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SlideTransition(
              position: _animation1,
              child: _buildCard(),
            ),
            SlideTransition(
              position: _animation2,
              child: _buildCard(isSlightlyRotated: true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text("Mixing Cards..."),
      ],
    );
  }

  Widget _buildCard({bool isSlightlyRotated = false}) {
    return Transform.rotate(
      angle: isSlightlyRotated ? 0.15 : 0,
      child: Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
