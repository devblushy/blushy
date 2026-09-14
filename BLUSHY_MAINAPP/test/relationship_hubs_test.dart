import 'package:blushy_life_app/features/partner/presentation/relationship_hubs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Eight tabs, grouped into four places.
///
/// Overview, Bouquet, Messenger, Activities, Letters, Memory Book,
/// Relationship AI and Gifts competed across the top of the portal, so finding
/// the letters meant reading eight words and guessing which one held them.
///
/// Nothing was deleted. Each hub opens the tab it always opened, and the two
/// that are moments rather than places -- Messenger and Gifts -- sit below as
/// contextual actions. These pin that every one of them is still reachable,
/// because a grid that quietly dropped a destination would be the easy mistake
/// to make here.

Widget _host(Widget child, {Size size = const Size(390, 900)}) => MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: size.width, child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('the four places are offered, each with what it is for',
      (tester) async {
    await tester.pumpWidget(_host(RelationshipHubGrid(
      onBloom: () {},
      onCapsules: () {},
      onMemories: () {},
      onDocsy: () {},
    )));
    await tester.pumpAndSettle();

    expect(find.text('TOGETHER'), findsOneWidget);
    expect(find.text('Empathy Bloom'), findsOneWidget);
    expect(find.text('Time Capsules'), findsOneWidget);
    expect(find.text('Memory Sanctuary'), findsOneWidget);
    expect(find.text('Docsy'), findsOneWidget);

    expect(find.text('Sealed letters & milestones'), findsOneWidget);
    expect(find.text('Shared photos & moments'), findsOneWidget);
  });

  testWidgets('each hub opens its own destination, and only its own',
      (tester) async {
    final opened = <String>[];
    await tester.pumpWidget(_host(RelationshipHubGrid(
      onBloom: () => opened.add('bloom'),
      onCapsules: () => opened.add('capsules'),
      onMemories: () => opened.add('memories'),
      onDocsy: () => opened.add('docsy'),
    )));
    await tester.pumpAndSettle();

    for (final entry in {
      'Empathy Bloom': 'bloom',
      'Time Capsules': 'capsules',
      'Memory Sanctuary': 'memories',
      'Docsy': 'docsy',
    }.entries) {
      opened.clear();
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(opened, [entry.value], reason: entry.key);
    }
  });

  testWidgets('Messenger and Gifts stay reachable as actions', (tester) async {
    // They are moments rather than places, so they are not hubs -- but losing
    // them would be losing two of the eight.
    var messaged = 0;
    var gifted = 0;
    await tester.pumpWidget(_host(RelationshipHubGrid(
      onBloom: () {},
      onCapsules: () {},
      onMemories: () {},
      onDocsy: () {},
      onMessage: () => messaged++,
      onGift: () => gifted++,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Message'));
    await tester.tap(find.text('Send a gift'));
    await tester.pumpAndSettle();

    expect(messaged, 1);
    expect(gifted, 1);
  });

  testWidgets('Docsy is absent where it is not offered', (tester) async {
    // Relationship AI is the supporting partner's. The tab guards it too, and
    // a hub that opened it only to fall back to Overview would be a dead end.
    await tester.pumpWidget(_host(RelationshipHubGrid(
      onBloom: () {},
      onCapsules: () {},
      onMemories: () {},
      onDocsy: () {},
      docsyAvailable: false,
    )));
    await tester.pumpAndSettle();

    expect(find.text('Docsy'), findsNothing);
    expect(find.text('Empathy Bloom'), findsOneWidget);
  });

  testWidgets('it holds up on a narrow phone', (tester) async {
    // Two tiles on a 320pt screen leave the subtitles two words wide, so it
    // drops to one column rather than clipping them.
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(
      RelationshipHubGrid(
        onBloom: () {},
        onCapsules: () {},
        onMemories: () {},
        onDocsy: () {},
        onMessage: () {},
        onGift: () {},
      ),
      size: const Size(320, 800),
    ));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull, reason: 'nothing overflows at 320');
    expect(find.text('Memory Sanctuary'), findsOneWidget);
  });

  testWidgets('a hub reads as one thing to a screen reader', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(RelationshipHubGrid(
      onBloom: () {},
      onCapsules: () {},
      onMemories: () {},
      onDocsy: () {},
    )));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Time Capsules. Sealed letters & milestones'),
      findsOneWidget,
    );
    handle.dispose();
  });
}
