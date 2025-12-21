import 'package:flutter/material.dart';

final engineBackgroundColor = {
  'trivia': Colors.redAccent,
  'charades': Colors.lightBlue,
  'truth_or_dare': Colors.pink,
  'debate': Colors.green,
  'nhie': Colors.orange,
  'most_likely': Colors.purple,
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
