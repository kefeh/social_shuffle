import 'package:flutter/material.dart';

final engineBackgroundColor = {
  'trivia': Color(0xFFE94560),
  'charades': Color(0xFF4ECCA3),
  'truth_or_dare': Color(0xFFFF2E63),
  'debate': Colors.green,
  'nhie': Color(0xFFFF9A3C),
  'most_likely': Color(0xFF9D4EDD),
  'hot_takes': Color(0xFFF9C80E),
  'deep_dive': Color(0xFF4361EE),
};

IconData getIconFromName(String iconName) {
  switch (iconName) {
    case 'record_voice_over_rounded':
      return Icons.record_voice_over_rounded;
    case 'timer_outlined':
      return Icons.timer_outlined;
    case 'fingerprint':
      return Icons.fingerprint;
    case 'local_bar_rounded':
      return Icons.local_bar_rounded;
    case 'touch_app_rounded':
      return Icons.touch_app_rounded;
    case 'visibility_rounded':
      return Icons.visibility_rounded;
    case 'local_fire_department_rounded':
      return Icons.local_fire_department_rounded;
    case 'local_drink_rounded':
      return Icons.local_drink_rounded;
    case 'forum_rounded':
      return Icons.forum_rounded;
    case 'quiz_rounded':
      return Icons.quiz_rounded;
    case 'timer_rounded':
      return Icons.timer_rounded;
    case 'emoji_events_rounded':
      return Icons.emoji_events_rounded;
    case 'phone_android_rounded':
      return Icons.phone_android_rounded;
    case 'theater_comedy_rounded':
      return Icons.theater_comedy_rounded;
    case 'screen_rotation_rounded':
      return Icons.screen_rotation_rounded;
    default:
      return Icons.arrow_forward;
  }
}
