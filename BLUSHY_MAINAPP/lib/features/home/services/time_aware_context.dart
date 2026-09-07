import 'package:flutter/material.dart';

enum TimeOfDayWindow { morning, afternoon, evening, night }

class TimeAwareContext {
  final DateTime now;
  final TimeOfDayWindow window;

  TimeAwareContext._({required this.now, required this.window});

  factory TimeAwareContext.now([DateTime? customTime]) {
    final t = customTime ?? DateTime.now();
    final hour = t.hour;

    TimeOfDayWindow win;
    if (hour >= 5 && hour < 12) {
      win = TimeOfDayWindow.morning;
    } else if (hour >= 12 && hour < 17) {
      win = TimeOfDayWindow.afternoon;
    } else if (hour >= 17 && hour < 22) {
      win = TimeOfDayWindow.evening;
    } else {
      win = TimeOfDayWindow.night;
    }

    return TimeAwareContext._(now: t, window: win);
  }

  String getGreetingPrefix() {
    switch (window) {
      case TimeOfDayWindow.morning:
        return 'Good morning,';
      case TimeOfDayWindow.afternoon:
        return 'Good afternoon,';
      case TimeOfDayWindow.evening:
        return 'Good evening,';
      case TimeOfDayWindow.night:
        return 'Rest well,';
    }
  }

  String getDefaultSubtitle(String stageKey) {
    if (stageKey == 'firstPeriodNotStarted') {
      switch (window) {
        case TimeOfDayWindow.morning:
          return "Your body is growing. Here's a gentle start for your day.";
        case TimeOfDayWindow.afternoon:
          return "Learn what's happening to your body at your own pace.";
        case TimeOfDayWindow.evening:
          return "Take a deep breath. You're doing just fine.";
        case TimeOfDayWindow.night:
          return "Rest easy tonight. You are safe and supported.";
      }
    }
    switch (window) {
      case TimeOfDayWindow.morning:
        return "Here is your gentle health summary for this morning.";
      case TimeOfDayWindow.afternoon:
        return "Bite-sized guides and check-ins for your afternoon.";
      case TimeOfDayWindow.evening:
        return "Unwind and reflect on how your body felt today.";
      case TimeOfDayWindow.night:
        return "Peaceful evening insights to help you rest well.";
    }
  }

  double getTimeBoostForModule(String moduleId) {
    switch (window) {
      case TimeOfDayWindow.morning:
        if (moduleId == 'daily_letter' ||
            moduleId == 'first_period_kit' ||
            moduleId == 'morning_checkin') {
          return 2.5;
        }
        break;
      case TimeOfDayWindow.afternoon:
        if (moduleId == 'body_changes_hub' ||
            moduleId == 'continue_learning' ||
            moduleId == 'lets_talk_prompts') {
          return 2.0;
        }
        break;
      case TimeOfDayWindow.evening:
        if (moduleId == 'feeling_reflector' ||
            moduleId == 'lets_talk_prompts' ||
            moduleId == 'evening_reflection') {
          return 2.5;
        }
        break;
      case TimeOfDayWindow.night:
        if (moduleId == 'panic_free_guide' || moduleId == 'soothing_quotes') {
          return 2.0;
        }
        break;
    }
    return 1.0;
  }
}
