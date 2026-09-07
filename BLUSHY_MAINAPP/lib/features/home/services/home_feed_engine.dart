import 'package:flutter/foundation.dart';
import '../../../core/state.dart';

import 'stage_eligibility_registry.dart';
import 'time_aware_context.dart';
import '../../../services/sia_dashboard_service.dart';

class CandidateHomeModule {
  final String id;
  final String title;
  final int basePriority;
  final String category;

  CandidateHomeModule({
    required this.id,
    required this.title,
    required this.basePriority,
    required this.category,
  });
}

class HomeFeedEngine {
  static final HomeFeedEngine _instance = HomeFeedEngine._internal();
  factory HomeFeedEngine() => _instance;
  HomeFeedEngine._internal();

  /// Registered candidate modules for the home feed
  static final List<CandidateHomeModule> _allCandidateModules = [
    CandidateHomeModule(id: 'hero_banner', title: 'Greeting Banner', basePriority: 100, category: 'hero'),
    CandidateHomeModule(id: 'daily_letter', title: "Sia's Daily Letter", basePriority: 90, category: 'ai_thought'),
    CandidateHomeModule(id: 'first_period_kit', title: 'First Period Kit', basePriority: 80, category: 'checklist'),
    CandidateHomeModule(id: 'body_changes_hub', title: "What's Happening To My Body", basePriority: 75, category: 'education'),
    CandidateHomeModule(id: 'feeling_reflector', title: 'Feeling Reflector', basePriority: 70, category: 'checkin'),
    CandidateHomeModule(id: 'panic_free_guide', title: 'Panic Free Guide', basePriority: 65, category: 'action'),
    CandidateHomeModule(id: 'lets_talk_prompts', title: "Let's Talk Prompts", basePriority: 60, category: 'parent_share'),
    CandidateHomeModule(id: 'continue_learning', title: 'Continue Learning Hub', basePriority: 55, category: 'education'),
    
    // Cycle and adult stage modules
    CandidateHomeModule(id: 'cycle_ring', title: "Today's Cycle Ring", basePriority: 85, category: 'tracking'),
    CandidateHomeModule(id: 'symptom_logger', title: 'Symptom Logger', basePriority: 75, category: 'checkin'),
    CandidateHomeModule(id: 'partner_decoder', title: 'Partner Decoder Insights', basePriority: 50, category: 'partner'),
  ];

  /// Computes the dynamic ranked list of eligible module IDs for the current user & context
  List<String> generateRankedFeed({
    required String stageKey,
    required PersonalContext context,
    TimeAwareContext? timeContext,
    Map<String, dynamic>? recentInteractions,
  }) {
    final tContext = timeContext ?? TimeAwareContext.now();
    final siaService = SiaDashboardService();

    final List<MapEntry<CandidateHomeModule, double>> scoredList = [];

    for (final mod in _allCandidateModules) {
      // 1. Safety & Eligibility check
      final bool eligible = StageEligibilityRegistry.isModuleEligible(
        moduleId: mod.id,
        stageKey: stageKey,
        context: context,
      );

      if (!eligible) continue;

      // 2. Base priority
      double score = mod.basePriority.toDouble();

      // 3. Time of day boost
      score += (tContext.getTimeBoostForModule(mod.id) * 10.0);

      // 4. AI & Interaction boost
      if (recentInteractions != null) {
        // If kit is 100% packed, lower kit card priority so educational guides move up
        if (mod.id == 'first_period_kit' && recentInteractions['isKitAllPacked'] == true) {
          score -= 35.0;
        }
        // If user logged mood today, lower feeling reflector priority
        if (mod.id == 'feeling_reflector' && recentInteractions['moodLoggedToday'] == true) {
          score -= 20.0;
        }
      }

      // If backend has fresh AI observations, boost Sia Daily Letter
      if (mod.id == 'daily_letter' && siaService.hasUnsyncedChanges) {
        score += 15.0;
      }

      scoredList.add(MapEntry(mod, score));
    }

    // Sort by descending score
    scoredList.sort((a, b) => b.value.compareTo(a.value));

    return scoredList.map((e) => e.key.id).toList();
  }
}
