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

    const totalSlides = 17;

    expect(
      find.text('Multi-agent brainstorming, made rigorous.'),
      findsOneWidget,
    );
    expect(progressValue(), 1 / totalSlides);
    expect(find.byTooltip('Sluiten'), findsNothing);
    expect(find.byTooltip('Terug'), findsNothing);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('From a broad question to evidence.'), findsOneWidget);
    expect(progressValue(), 2 / totalSlides);

    for (var slide = 3; slide <= 14; slide++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(progressValue(), slide / totalSlides);
      if (slide == 7) {
        expect(find.byType(SelectableText), findsOneWidget);
        expect(
          tester.widget<SelectableText>(find.byType(SelectableText)).data,
          contains('name: multi-agent-brainstorm'),
        );
      }
      if (slide == 11) {
        expect(find.text('For app docs, prove coverage.'), findsOneWidget);
        expect(
          tester.widget<SelectableText>(find.byType(SelectableText)).data,
          contains('Then each board shows a score of 100'),
        );
      }
    }

    expect(find.text('Skill Feud.'), findsOneWidget);
    expect(find.text('Score: 0'), findsNWidgets(2));

    await tester.tap(find.text('Answer 1').first);
    await tester.pumpAndSettle();

    expect(
      find.text('Give a reviewer its own role instructions'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Define the reviewer\'s priorities and expected output, rather than a task recipe.',
      ),
      findsOneWidget,
    );
    expect(find.text('Score: 30'), findsOneWidget);

    await tester.tap(find.text('Answer 1').last);
    await tester.pumpAndSettle();

    expect(find.text('Teach a repeatable testing procedure'), findsOneWidget);
    expect(
      find.text(
        'Package the task steps and expected results independently of the agent\'s role.',
      ),
      findsOneWidget,
    );
    expect(find.text('Score: 30'), findsNWidgets(2));

    await tester.tap(find.text('Reveal all').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reveal all').last);
    await tester.pumpAndSettle();

    expect(find.text('Score: 100'), findsNWidgets(2));
    for (final answer in [
      'Limit a planner to read-only tools',
      'Configure a model for a specialist role',
      'Switch from planning to implementation',
      'Delegate research and get a result back',
      'Bundle a setup script and service templates',
      'Make domain guidance discoverable on demand',
      'Share task knowledge across AI products',
      'Keep a deployment recipe manual-only',
    ]) {
      expect(find.text(answer), findsOneWidget);
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Demo: model-selected tool routing.'), findsOneWidget);
    expect(find.text('If the demo is blocked'), findsOneWidget);
    expect(
      find.textContaining(
        '/multi-agent-brainstorm Compare local, hosted, and hybrid',
      ),
      findsOneWidget,
    );
    expect(progressValue(), 15 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Is your skill ready?'), findsOneWidget);
    expect(
      find.text(
        'Run through this list before you share a skill with your team.',
      ),
      findsOneWidget,
    );
    expect(find.text('0 of 7 checked'), findsOneWidget);
    for (final item in [
      'File structure and metadata are valid',
      'Description says what and when',
      'Instructions are concise and actionable',
      'Examples and success checks are concrete',
      'Supporting resources are linked and usable',
      'Safety and permissions are reviewed',
      'Discovery and results are tested',
    ]) {
      expect(find.text(item), findsOneWidget);
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();
    }
    expect(find.text('Ready to share'), findsOneWidget);
    expect(find.text('Model and effort are resolved each run'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.text('Make the next decision evidence-backed.'),
      findsOneWidget,
    );
    expect(progressValue(), 1);

    await tester.tap(find.text('Back to start'));
    await tester.pumpAndSettle();

    expect(
      find.text('Multi-agent brainstorming, made rigorous.'),
      findsOneWidget,
    );
    expect(progressValue(), 1 / totalSlides);
  });
}
