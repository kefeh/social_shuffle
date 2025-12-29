import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/main_provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum Compare { equal, greaterThan, lessThan }

Compare compareVersions(String main, String other) {
  List<String> splitMain = main.split('.');
  List<String> splitOther = other.split('.');

  int mainMajor = int.parse(splitMain[0]);
  int mainMinor = int.parse(splitMain[1]);
  int mainPatch = int.parse(splitMain[2]);

  int otherMajor = int.parse(splitOther[0]);
  int otherMinor = int.parse(splitOther[1]);
  int otherPatch = int.parse(splitOther[2]);

  if (mainMajor > otherMajor) {
    return Compare.greaterThan;
  } else if (mainMajor < otherMajor) {
    return Compare.lessThan;
  }

  if (mainMinor > otherMinor) {
    return Compare.greaterThan;
  } else if (mainMinor < otherMinor) {
    return Compare.lessThan;
  }

  if (mainPatch > otherPatch) {
    return Compare.greaterThan;
  } else if (mainPatch < otherPatch) {
    return Compare.lessThan;
  }

  return Compare.equal;
}

class AppUpdate extends ConsumerWidget {
  const AppUpdate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryGradient = Color(0xFF6A11CB);
    const Color secondaryGradient = Color(0xFF2575FC);
    const Color textColor = Colors.white;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryGradient, secondaryGradient],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryGradient.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    left: -40,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 140,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'Time for an Upgrade!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: textColor,
            ),
          ),

          const SizedBox(height: 12),

          Opacity(
            opacity: 0.7,
            child: const Text(
              "We've added new games, smoother animations, and squashed some bugs. Update now for the best experience.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: textColor),
            ),
          ),

          const SizedBox(height: 24),

          _buildUpdateFeature(
            Icons.bolt_rounded,
            "Faster Performance",
            primaryGradient,
          ),
          const SizedBox(height: 12),
          _buildUpdateFeature(
            Icons.auto_awesome_rounded,
            "New Features",
            primaryGradient,
          ),

          const SizedBox(height: 32),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                final Uri uri = Uri.parse(
                  Platform.isAndroid
                      ? 'https://play.google.com/store/apps/details?id=com.kefeh.social_shuffle'
                      : 'https://apps.apple.com/us/app/socialShuffle/id6757119872',
                );
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                ref.invalidate(appStartupProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGradient,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'UPDATE NOW',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateFeature(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

Future<void> showAppUpdate(BuildContext context) async {
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;

  await showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1A1A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) => PopScope(canPop: false, child: const AppUpdate()),
  );
}
