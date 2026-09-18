// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:status_card_app/main.dart';

void main() {
  testWidgets('status card switches between light and dark themes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final badge = find.ancestor(
      of: find.text('Status: Online'),
      matching: find.byType(AnimatedContainer),
    );

    expect(find.text('Flutter Theme Lab'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(badge, findsOneWidget);
    expect(
      tester.widget<AnimatedContainer>(badge).duration,
      const Duration(milliseconds: 400),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(find.byIcon(Icons.circle_outlined), findsNothing);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('both themes are Material 3 schemes generated from a seed', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    for (final entry in {
      app.theme!: Brightness.light,
      app.darkTheme!: Brightness.dark,
    }.entries) {
      final theme = entry.key;
      final seed = entry.value == Brightness.light
          ? MyApp.lightSeed
          : MyApp.darkSeed;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, entry.value);
      expect(
        theme.colorScheme,
        ColorScheme.fromSeed(seedColor: seed, brightness: entry.value),
      );
      expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
      expect(
        theme.appBarTheme.backgroundColor,
        theme.colorScheme.primaryContainer,
      );
    }
  });
}
