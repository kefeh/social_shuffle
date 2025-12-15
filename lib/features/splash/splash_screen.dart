import 'package:flutter/material.dart';
import 'package:social_shuffle/features/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background painter
          CustomPaint(
            painter: _BackgroundPainter(),
            child: Container(),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shuffle,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Social Shuffle',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The Ultimate Party Game',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.cubicTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.8,
      size.height * 0.5,
    );
    canvas.drawPath(path, paint);

    final shapePaint = Paint()..color = Colors.deepPurple.withOpacity(0.5);
    final shapePath = Path();
    shapePath.moveTo(size.width, size.height * 0.8);
    shapePath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.75,
      size.width * 0.7,
      size.height * 0.85,
    );
    shapePath.arcToPoint(
      Offset(size.width, size.height),
      radius: const Radius.circular(50),
      clockwise: false,
    );

    shapePath.close();
    canvas.drawPath(shapePath, shapePaint);

    final heartPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.88), 10, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}