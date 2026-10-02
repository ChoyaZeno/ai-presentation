import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_presentation/main.dart';

void main() {
  testWidgets('keeps progress cumulative without header navigation controls', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PresentationApp());
    await tester.pumpAndSettle();

    double progressValue() => tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
        .value!;

    const totalSlides = 15;

    expect(find.text('Write skills your AI can actually use.'), findsOneWidget);
    expect(progressValue(), 1 / totalSlides);
    expect(find.byTooltip('Sluiten'), findsNothing);
    expect(find.byTooltip('Terug'), findsNothing);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('What we will cover.'), findsOneWidget);
    expect(progressValue(), 2 / totalSlides);

    for (var slide = 3; slide <= 13; slide++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(progressValue(), slide / totalSlides);
    }

    expect(find.text('Skill Feud.'), findsOneWidget);
    expect(find.text('Score: 0'), findsNWidgets(2));

    await tester.tap(find.text('Answer 1').first);
    await tester.pumpAndSettle();

    expect(find.text('Defines a specialist persona'), findsOneWidget);
    expect(find.text('Score: 32'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(find.text('Ship one skill this week.'), findsOneWidget);
    expect(progressValue(), 1);

    await tester.tap(find.text('Back to start'));
    await tester.pumpAndSettle();

    expect(find.text('Write skills your AI can actually use.'), findsOneWidget);
    expect(progressValue(), 1 / totalSlides);
  });
}
