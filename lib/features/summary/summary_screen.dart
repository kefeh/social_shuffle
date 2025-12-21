import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics

class SummaryScreen extends StatefulWidget {
  // Score is optional. 0.0 to 1.0
  final double? score;
  final Color color;

  const SummaryScreen({super.key, required this.color, this.score});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Simple "Pop" animation for the main card
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    // Play a success haptic on load
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper to determine the text based on score
  String _getScoreTitle(double score) {
    if (score >= 0.9) return "LEGENDARY!";
    if (score >= 0.7) return "AWESOME!";
    if (score >= 0.5) return "GOOD JOB!";
    return "NICE TRY!";
  }

  Color _getScoreColor(double score) {
    if (score >= 0.7) return Colors.greenAccent;
    if (score >= 0.5) return Colors.amberAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    // Background Gradient
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E0249), // Dark Purple
              Color(0xFF570A57), // Purple
              widget.color,
            ],
          ),
        ),
        child: SafeArea(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),

                  // --- MAIN CARD ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Glassmorphism
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                        // LOGIC: Show Score or Appreciation
                        if (widget.score != null)
                          _buildScoreView(widget.score!)
                        else
                          _buildCompletionView(),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // --- ACTION BUTTONS ---
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.replay,
                          label: "Replay",
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Replay button pressed!'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.shuffle,
                          label: "Remix",
                          color: const Color(0xFFFF0080), // Vibrant Pink
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Remix button pressed!'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      "Back to Dashboard",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET: Logic for when Score exists
  Widget _buildScoreView(double score) {
    return Column(
      children: [
        // Circular Progress with Animation
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 15,
                color: Colors.white.withOpacity(0.1),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: score),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOutQuart,
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 15,
                    strokeCap: StrokeCap.round,
                    color: _getScoreColor(value),
                  );
                },
              ),
              Center(
                child: TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: (score * 100).toInt()),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutQuart,
                  builder: (context, value, _) {
                    return Text(
                      "$value%",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _getScoreTitle(score),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You crushed it!", // This could be dynamic based on score too
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  // WIDGET: Logic for when it's just a completion (no score)
  Widget _buildCompletionView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.celebration,
            size: 60,
            color: Colors.amberAccent,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "VIBE CHECK PASSED",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Thanks for playing! The energy is immaculate.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}

// Helper Widget for beautiful Buttons
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        shadowColor: color.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
