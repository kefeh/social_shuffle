import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    Future.delayed(const Duration(seconds: 4), () {
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
          Positioned(
            top: -50,
            left: -50,
            child: SvgPicture.asset('assets/images/blob1.svg', width: 200),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: SvgPicture.asset('assets/images/blob2.svg', width: 200),
          ),

          CustomPaint(painter: _BackgroundPainter(), child: Container()),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Social Shuffle',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The Ultimate Party Game',
                  style: GoogleFonts.lora(
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
    path.moveTo(size.width * 0.3, size.height * 0.1);
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.25,
      size.width * 0.2,
      size.height * 0.35,
      size.width * 0.9,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);

    final shapePaint = Paint()
      ..color = const Color(0xFFC3A4F4).withOpacity(0.5);
    final shapePath = Path();
    shapePath.moveTo(size.width, size.height * 0.85);
    shapePath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width * 0.75,
      size.height * 0.9,
    );
    shapePath.arcToPoint(
      Offset(size.width * 0.9, size.height),
      radius: const Radius.circular(50),
      clockwise: false,
    );
    shapePath.lineTo(size.width, size.height);
    shapePath.close();
    canvas.drawPath(shapePath, shapePaint);

    final heartPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final heartPath = Path();
    heartPath.moveTo(size.width * 0.82, size.height * 0.93);
    heartPath.cubicTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width * 0.75,
      size.height * 0.9,
      size.width * 0.78,
      size.height * 0.95,
    );
    heartPath.cubicTo(
      size.width * 0.81,
      size.height * 1,
      size.width * 0.88,
      size.height * 1,
      size.width * 0.85,
      size.height * 0.95,
    );
    canvas.drawPath(heartPath, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
