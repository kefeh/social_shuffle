import 'package:flutter/material.dart';

class GameModeCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isGridView;

  const GameModeCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: Card(
          color: isGridView ? color.withOpacity(0.8) : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
