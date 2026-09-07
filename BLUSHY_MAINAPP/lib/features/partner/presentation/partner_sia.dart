import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import '../../../core/storage.dart';
import '../../../theme/colors.dart';
import '../../../core/stage_config.dart';
import '../../../services/api_base_url.dart';
import '../../../services/auth_storage.dart';
import '../../../l10n/app_localizations.dart';

class PartnerSiaScreen extends StatefulWidget {
  final String? initialPrompt;
  const PartnerSiaScreen({super.key, this.initialPrompt});

  @override
  State<PartnerSiaScreen> createState() => _PartnerSiaScreenState();
}

class _PartnerSiaScreenState extends State<PartnerSiaScreen> {
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, dynamic>> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendQuery(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _sendQuery(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;
    
    setState(() {
      _chatHistory.add({"sender": "user", "text": cleanQuery});
    });
    
    _queryController.clear();

    String reply = "";
    try {
      final token = AuthStorage.getToken();
      final dio = Dio(BaseOptions(
        baseUrl: resolveApiBaseUrl(),
        connectTimeout: const Duration(seconds: 10),
        // Absorbs a Render cold start (~27s); see api_community_service.dart
        // for why this is the timeout that gives rather than connectTimeout.
        receiveTimeout: const Duration(seconds: 60),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      ));

      final response = await dio.post('/ai/chat', data: {
        'message': cleanQuery,
        'context': 'partner_support',
      });

      if (response.data is Map && response.data['reply'] != null) {
        reply = response.data['reply'].toString();
      }
    } catch (_) {}

    if (reply.isEmpty) {
      final lower = cleanQuery.toLowerCase();
      if (lower.contains("discharge")) {
        reply = "Vaginal discharge is completely normal and healthy! It is your body's natural way of cleaning itself and usually begins 6 to 18 months before your first period arrives.";
      } else if (lower.contains("school") || (lower.contains("first") && lower.contains("period"))) {
        reply = "If your first period starts at school, take a deep breath. Use a pad from your pouch or visit your school nurse. You can also tie a sweater around your waist. You are 100% safe and doing great!";
      } else if (lower.contains("normal") || lower.contains("body") || lower.contains("growing") || lower.contains("breast")) {
        reply = "Everyone's body grows at its own unique, healthy pace! Breast buds, height changes, and new body hair are all natural signs of your body blossoming.";
      } else if (lower.contains("nervous") || lower.contains("overwhelm") || lower.contains("scared")) {
        reply = "Feeling nervous is completely normal when your body is changing. Taking things one day at a time, talking to someone you trust, and taking deep breaths can help you feel centered.";
      } else if (lower.contains("period") || lower.contains("menstrual") || lower.contains("cramp")) {
        reply = "During her menstrual phase, her energy is biologically lowest. Best ways you can support her: offer a warm heat pack, brew soothing tea, and handle dinner or errands so she can rest.";
      } else if (lower.contains("follicular") || lower.contains("after period")) {
        reply = "In her follicular phase, estrogen is rising, which boosts energy, focus, and social enthusiasm. Great time to plan fun dates, try new activities, or tackle shared goals together.";
      } else if (lower.contains("ovulat") || lower.contains("fertile")) {
        reply = "During ovulation, estrogen and testosterone peak. She typically feels confident, sociable, and energetic. Enjoy deep quality time and meaningful conversations.";
      } else if (lower.contains("luteal") || lower.contains("pms") || lower.contains("mood") || lower.contains("irrit")) {
        reply = "During her luteal phase (PMS), progesterone increases, which can cause fatigue, food cravings, or mood fluctuations. Offer extra patience, reassurance, comforting snacks, and gentle support.";
      } else if (lower.contains("tired") || lower.contains("fatigue") || lower.contains("sleep")) {
        reply = "When she feels fatigued, simple practical help makes the biggest difference: ask 'Can I take care of dinner tonight?' and make sure she has quiet space to decompress.";
      } else {
        reply = "Docsy is right here with you! You can ask anything about your body, changes you notice, or how you are feeling today.";
      }
    }

    if (mounted) {
      setState(() {
        _chatHistory.add({"sender": "sia", "text": reply});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String activeStage = "everydayWellness";
    try {
      final profile = BlushyStorage.read('user_profile.json');
      if (profile['profile'] != null) {
        activeStage = profile['profile']['lifeStage'] ?? "everydayWellness";
      }
    } catch (_) {}

    final stageDetails = StageConfig.forStage(activeStage);

    // Dynamic suggested questions based on life stage
    final List<String> suggestions = [
      "How can I support her during ${stageDetails.partnerSubLabel.toLowerCase()}?",
      "Why might she be more tired right now?",
      "What is practical vs emotional support?",
    ];

    return Scaffold(
      backgroundColor: BlushyColors.background,
      appBar: AppBar(
        backgroundColor: BlushyColors.background,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: BlushyColors.text, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          "Ask Docsy",
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: BlushyColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: _chatHistory.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, color: BlushyColors.primary, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            "Ask Docsy about supporting her",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: BlushyColors.text),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Learn about health stages, communication tips, and practical support guides.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(fontSize: 12, color: BlushyColors.secondaryText),
                          ),
                          const SizedBox(height: 24),
                          ...suggestions.map((suggestion) {
                            return GestureDetector(
                              onTap: () => _sendQuery(suggestion),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: BlushyColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.help_outline_rounded, size: 16, color: BlushyColors.primary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        suggestion,
                                        style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: BlushyColors.text),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        final msg = _chatHistory[index];
                        final isUser = msg["sender"] == "user";
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isUser ? BlushyColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: isUser ? null : Border.all(color: BlushyColors.border),
                            ),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            child: Text(
                              msg["text"]!,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: isUser ? Colors.white : BlushyColors.text,
                                height: 1.45,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: BlushyColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      style: GoogleFonts.manrope(fontSize: 13, color: BlushyColors.text),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).psAskAboutHerActive,
                        hintStyle: GoogleFonts.manrope(color: BlushyColors.secondaryText.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendQuery,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: BlushyColors.primary),
                    onPressed: () => _sendQuery(_queryController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
