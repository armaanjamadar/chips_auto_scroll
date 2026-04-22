import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chips_auto_scroll/chips_auto_scroll.dart';

void main() {
  group('ChipsAutoScroll', () {
    testWidgets('renders all chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipsAutoScroll(
              selectedIndex: 0,
              children: List.generate(
                5,
                (index) => ChoiceChip(
                  label: Text('Chip $index'),
                  selected: index == 0,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Chip 0'), findsOneWidget);
    });

    testWidgets('renders with vertical scroll direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipsAutoScroll(
              selectedIndex: 0,
              scrollDirection: Axis.vertical,
              height: 300,
              children: List.generate(
                5,
                (index) => ChoiceChip(
                  label: Text('Chip $index'),
                  selected: index == 0,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Chip 0'), findsOneWidget);
    });

    testWidgets('updates when selectedIndex changes',
        (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ChipsAutoScroll(
                      selectedIndex: selectedIndex,
                      children: List.generate(
                        10,
                        (index) => ChoiceChip(
                          label: Text('Chip $index'),
                          selected: index == selectedIndex,
                          onSelected: (_) =>
                              setState(() => selectedIndex = index),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => selectedIndex = 9),
                      child: const Text('Jump to last'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Jump to last'));
      await tester.pumpAndSettle();

      expect(find.text('Chip 9'), findsOneWidget);
    });

    testWidgets('accepts custom animation duration and curve',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipsAutoScroll(
              selectedIndex: 0,
              animationDuration: const Duration(milliseconds: 500),
              animationCurve: Curves.bounceOut,
              children: List.generate(
                5,
                (index) => ChoiceChip(
                  label: Text('Chip $index'),
                  selected: index == 0,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Chip 0'), findsOneWidget);
    });
  });
}
