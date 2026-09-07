import 'package:flutter/foundation.dart';
import '../../../core/state.dart';

/// Centralized Safety & Eligibility Registry for Blushy Home Modules.
/// Guarantees that modules never appear in inappropriate life stages.
class StageEligibilityRegistry {
  const StageEligibilityRegistry._();

  /// Modules that are strictly disallowed in specific life stages.
  static final Map<String, Set<String>> _disallowedModulesByStage = {
    'firstPeriodNotStarted': {
      'cycle_ring',
      'cycle_day_countdown',
      'ovulation_prediction',
      'fertile_window',
      'flow_logger',
      'cramp_tracker',
      'cervical_mucus',
      'pregnancy_test_logger',
      'trimester_tracker',
      'fetal_development',
      'postpartum_healing',
      'hot_flash_logger',
    },
    'firstPeriodStarted': {
      'fertile_window',
      'ovulation_prediction',
      'pregnancy_test_logger',
      'trimester_tracker',
      'fetal_development',
      'postpartum_healing',
      'hot_flash_logger',
    },
    'livingWithMyCycle': {
      'first_period_kit',
      'puberty_basics_hub',
      'trimester_tracker',
      'fetal_development',
      'postpartum_healing',
      'hot_flash_logger',
    },
    'pregnancy': {
      'cycle_ring',
      'ovulation_prediction',
      'fertile_window',
      'flow_logger',
      'first_period_kit',
      'hot_flash_logger',
    },
    'postpartum': {
      'cycle_ring',
      'ovulation_prediction',
      'fertile_window',
      'first_period_kit',
      'trimester_tracker',
      'fetal_development',
    },
    'perimenopause': {
      'first_period_kit',
      'puberty_basics_hub',
      'trimester_tracker',
      'fetal_development',
    },
    'menopause': {
      'cycle_ring',
      'ovulation_prediction',
      'fertile_window',
      'flow_logger',
      'first_period_kit',
      'puberty_basics_hub',
      'trimester_tracker',
      'fetal_development',
    },
  };

  /// Validates whether a module is safe and eligible to appear for a given life stage.
  static bool isModuleEligible({
    required String moduleId,
    required String stageKey,
    required PersonalContext context,
  }) {
    final normalizedStage = stageKey.trim();
    
    // Safety check against disallowed set
    final disallowed = _disallowedModulesByStage[normalizedStage];
    if (disallowed != null && disallowed.contains(moduleId)) {
      return false;
    }

    // Special safety check for pre-menarche
    final bool isPreMenarche = normalizedStage == 'firstPeriodNotStarted' ||
        context.lifeStage == 'firstPeriodNotStarted' ||
        context.activeLifeStages.contains('firstPeriodNotStarted');

    if (isPreMenarche) {
      if (moduleId == 'cycle_ring' ||
          moduleId == 'ovulation_prediction' ||
          moduleId == 'fertile_window' ||
          moduleId == 'flow_logger') {
        return false;
      }
    }

    return true;
  }
}
