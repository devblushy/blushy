import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'partner_home_sections.dart'
    show kPmCrimson, kPmCardBorder, kPmCharcoal, kPmMuted;

/// The four places a relationship actually lives, as one grid.
///
/// Eight tabs competed across the top of the portal -- Overview, Bouquet,
/// Messenger, Activities, Letters, Memory Book, Relationship AI, Gifts -- so
/// finding the letters meant reading eight words and guessing which one held
/// them. None of those experiences is gone. They are grouped here by what they
/// are for, and each hub opens the tab it always opened.
///
/// Messenger and Gifts are deliberately not hubs. They are things you do in a
/// moment rather than places you go, so they sit below as contextual actions.
class RelationshipHubGrid extends StatelessWidget {
  const RelationshipHubGrid({
    super.key,
    required this.onBloom,
    required this.onCapsules,
    required this.onMemories,
    required this.onDocsy,
    this.onMessage,
    this.onGift,
    this.docsyAvailable = true,
  });

  final VoidCallback onBloom;
  final VoidCallback onCapsules;
  final VoidCallback onMemories;
  final VoidCallback onDocsy;
  final VoidCallback? onMessage;
  final VoidCallback? onGift;

  /// Relationship AI is only offered to the supporting partner, and the hub
  /// follows that rather than opening a tab that falls back to Overview.
  final bool docsyAvailable;

  @override
  Widget build(BuildContext context) {
    final hubs = <Widget>[
      _Hub(
        icon: Icons.local_florist_rounded,
        accent: const Color(0xFFF72585),
        tint: const Color(0xFFFFE5F0),
        title: 'Empathy Bloom',
        subtitle: 'Send a cycle-attuned bloom',
        onTap: onBloom,
      ),
      _Hub(
        icon: Icons.mail_outline_rounded,
        accent: const Color(0xFFD97706),
        tint: const Color(0xFFFEF3C7),
        title: 'Time Capsules',
        subtitle: 'Sealed letters & milestones',
        onTap: onCapsules,
      ),
      _Hub(
        icon: Icons.photo_library_rounded,
        accent: const Color(0xFF0D9488),
        tint: const Color(0xFFCCFBF1),
        title: 'Memory Sanctuary',
        subtitle: 'Shared photos & moments',
        onTap: onMemories,
      ),
      if (docsyAvailable)
        _Hub(
          icon: Icons.auto_awesome_rounded,
          accent: const Color(0xFF7209B7),
          tint: const Color(0xFFF3E8FF),
          title: 'Docsy',
          subtitle: 'Guidance for the two of you',
          onTap: onDocsy,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            'TOGETHER',
            style: GoogleFonts.manrope(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: kPmCrimson,
              letterSpacing: 1.1,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // One column on a narrow phone, where two tiles would leave the
            // subtitles two words wide.
            final columns = constraints.maxWidth < 330 ? 1 : 2;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // A single wide tile still has to fit a badge, a name and a
              // two-line subtitle: at 3.2 the content was 27px taller than
              // the row it was given.
              childAspectRatio: columns == 1 ? 2.3 : 1.12,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: hubs,
            );
          },
        ),
        if (onMessage != null || onGift != null) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (onMessage != null)
                _ContextualAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Message',
                  onTap: onMessage!,
                ),
              if (onGift != null)
                _ContextualAction(
                  icon: Icons.card_giftcard_rounded,
                  label: 'Send a gift',
                  onTap: onGift!,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Hub extends StatelessWidget {
  const _Hub({
    required this.icon,
    required this.accent,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kPmCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // The one place the accent belongs, per the design rules.
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                  child: Icon(icon, size: 21, color: accent),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: kPmCharcoal,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: kPmMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Something you do in a moment, rather than a place you go.
class _ContextualAction extends StatelessWidget {
  const _ContextualAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPmCardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: kPmCrimson),
              const SizedBox(width: 7),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: kPmCharcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
