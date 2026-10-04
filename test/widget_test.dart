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

    const totalSlides = 16;

    expect(
      find.text('Agents voeren taken uit; skills geven ze instructies.'),
      findsOneWidget,
    );
    expect(progressValue(), 1 / totalSlides);
    expect(find.byTooltip('Sluiten'), findsNothing);
    expect(find.byTooltip('Terug'), findsNothing);

    await tester.tap(find.text('Begin'));
    await tester.pumpAndSettle();

    expect(
      find.text('Van voorbereiding naar vergelijking.'),
      findsOneWidget,
    );
    for (final agendaItem in [
      'Start beide agents vóór de inhoudelijke slides.',
      'Levert opsplitsen betere BDD-scenario’s op?',
      'Agents voeren uit; skills beschrijven de aanpak.',
      'Kies het bestand dat bij het werk past.',
      'Gebruik de echte skill-metadata.',
      'De description bepaalt wanneer een skill relevant is.',
      'Eén skillmap, met SKILL.md als startpunt.',
      'Veelgemaakte fouten in SKILL.md.',
      'Test een skill: drie stappen.',
      'Skill Feud.',
      'Terug naar de agentchats.',
      'De hoofdagent bundelt en controleert resultaten.',
      'Is je skill klaar?',
      'Onderbouw je volgende beslissing met bewijs.',
    ]) {
      expect(find.text(agendaItem), findsOneWidget);
    }
    expect(progressValue(), 2 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.text('Start beide agents vóór de inhoudelijke slides.'),
      findsOneWidget,
    );
    expect(find.text('Met skill'), findsOneWidget);
    expect(find.text('Zonder skill'), findsOneWidget);
    final promptWidgets = tester
        .widgetList<SelectableText>(find.byType(SelectableText))
        .toList();
    final promptTexts = promptWidgets
      .map((prompt) => prompt.textSpan?.toPlainText() ?? prompt.data!)
      .toList();
    expect(promptTexts, hasLength(2));
    expect(promptTexts.first, startsWith('/multi-agent-brainstorm\n'));
    expect(promptTexts.last, startsWith('\nRead the entire repository'));
    final skillPrompt = promptTexts.first.replaceFirst(
      '/multi-agent-brainstorm\n',
      '',
    );
    final baselinePrompt = promptTexts.last.substring(1);
    expect(skillPrompt, contains('features/run-01/'));
    expect(baselinePrompt, contains('features/run-02/'));
    expect(
      skillPrompt.replaceFirst('features/run-01/', 'features/<output>/'),
      baselinePrompt.replaceFirst(
        'features/run-02/',
        'features/<output>/',
      ),
    );
    expect(
      find.textContaining('Voor de skill-run kiezen we het subagent-model'),
      findsOneWidget,
    );
    final skillCommand = promptWidgets.first.textSpan!.children!.first as TextSpan;
    expect(skillCommand.text, '/multi-agent-brainstorm\n');
    expect(skillCommand.style?.fontWeight, FontWeight.bold);
    expect(progressValue(), 3 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.text('Levert opsplitsen betere BDD-scenario’s op?'),
      findsOneWidget,
    );
    expect(find.text('Meer relevante scenario’s'), findsOneWidget);
    expect(find.text('Concretere scenario’s'), findsOneWidget);
    expect(find.text('Betere dekking en onderbouwing'), findsOneWidget);
    expect(find.text('Eerst: agents en skills'), findsOneWidget);
    expect(progressValue(), 4 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.text('Agents voeren uit; skills beschrijven de aanpak.'),
      findsOneWidget,
    );
    expect(progressValue(), 5 / totalSlides);

    for (var slide = 6; slide <= 12; slide++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(progressValue(), slide / totalSlides);
      if (slide == 7) {
        expect(find.text('Gebruik de echte skill-metadata.'), findsOneWidget);
        expect(find.byType(SelectableText), findsOneWidget);
        final metadata = tester
            .widget<SelectableText>(find.byType(SelectableText))
            .data!;
        expect(metadata, contains('name: multi-agent-brainstorm'));
        expect(metadata, contains('argument-hint:'));
      }
      if (slide == 8) {
        expect(
          find.text('De description bepaalt wanneer een skill relevant is.'),
          findsOneWidget,
        );
        expect(find.text('Te vaag'), findsOneWidget);
        expect(find.text('Specifiek en activeerbaar'), findsOneWidget);
        expect(find.text('3. Optionele bestanden'), findsOneWidget);
        expect(find.text('Noem concrete taken'), findsOneWidget);
        expect(find.text('Herkenbare termen'), findsOneWidget);
        expect(find.text('Test de skill regelmatig'), findsOneWidget);
      }
      if (slide == 9) {
        expect(
          find.text('Eén skillmap, met SKILL.md als startpunt.'),
          findsOneWidget,
        );
      }
      if (slide == 10) {
        expect(
          find.text('Veelgemaakte fouten in SKILL.md.'),
          findsOneWidget,
        );
        for (final title in [
          'Instructies blijven algemeen',
          'Scope en uitzonderingen ontbreken',
          'Extra bestanden staan los',
          'Risicovolle acties zijn onbegrensd',
        ]) {
          expect(find.text(title), findsOneWidget);
        }
      }
      if (slide == 11) {
        expect(
          find.text('Test een skill: drie stappen.'),
          findsOneWidget,
        );
        expect(find.text('Drie vragen'), findsOneWidget);
        for (final title in [
          'Wordt de skill op het juiste moment geladen?',
          'Levert de skill goed werk?',
          'Voegt de skill iets toe?',
        ]) {
          expect(find.text(title), findsOneWidget);
        }
        expect(
          find.text('Delegatie: aparte invalshoeken, dezelfde feiten'),
          findsNothing,
        );
      }
    }

    expect(find.text('Skill Feud.'), findsOneWidget);
    expect(find.text('Score: 0'), findsNWidgets(2));

    await tester.tap(find.text('Antwoord 1').first);
    await tester.pumpAndSettle();

    expect(find.text('Geef een reviewer eigen rolinstructies'), findsOneWidget);
    expect(
      find.text(
        'Bepaal de prioriteiten en verwachte uitvoer van de reviewer, niet een taakrecept.',
      ),
      findsOneWidget,
    );
    expect(find.text('Score: 30'), findsOneWidget);

    await tester.tap(find.text('Antwoord 1').last);
    await tester.pumpAndSettle();

    expect(find.text('Leer een herhaalbare testprocedure aan'), findsOneWidget);
    expect(
      find.text(
        'Verpak de taakstappen en verwachte resultaten los van de rol van de agent.',
      ),
      findsOneWidget,
    );
    expect(find.text('Score: 30'), findsNWidgets(2));

    await tester.tap(find.text('Alles tonen').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alles tonen').last);
    await tester.pumpAndSettle();

    expect(find.text('Score: 100'), findsNWidgets(2));
    for (final answer in [
      'Beperk een planner tot read-only tools',
      'Configureer een model voor een specialistische rol',
      'Schakel over van plannen naar implementeren',
      'Delegeer research en ontvang het resultaat',
      'Bundel een setup-script en service-templates',
      'Maak domeinkennis op aanvraag vindbaar',
      'Deel taakkennis tussen AI-producten',
      'Maak een deployment-recept alleen handmatig aanroepbaar',
    ]) {
      expect(find.text(answer), findsOneWidget);
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(
      find.text('Terug naar de agentchats.'),
      findsOneWidget,
    );
    expect(find.text('Waar je op let bij de vergelijking'), findsOneWidget);
    expect(find.text('Hoe is het onderzoek uitgevoerd?'), findsOneWidget);
    expect(progressValue(), 13 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(
      find.text('De hoofdagent bundelt en controleert resultaten.'),
      findsOneWidget,
    );
    expect(find.text('Voeg dubbele scenario’s samen'), findsOneWidget);
    expect(progressValue(), 14 / totalSlides);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Is je skill klaar?'), findsOneWidget);
    expect(
      find.text('Loop deze lijst na voordat je de skill met je team deelt.'),
      findsOneWidget,
    );
    expect(find.text('0 van 7 afgevinkt'), findsOneWidget);
    expect(progressValue(), 15 / totalSlides);
    for (final item in [
      'Staan bestand en metadata goed?',
      'Is duidelijk wanneer de skill past?',
      'Kan de agent de stappen volgen?',
      'Is duidelijk wat een goed resultaat is?',
      'Zijn extra bestanden goed gekoppeld?',
      'Zijn risicovolle acties begrensd?',
      'Heb je de skill in de praktijk getest?',
    ]) {
      expect(find.text(item), findsOneWidget);
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();
    }
    expect(find.text('Klaar om te delen'), findsOneWidget);
    expect(
      find.text(
        'De checklist is doorlopen. Deel de skill en verwerk feedback van je team.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Model en effort zijn bij elke run bepaald'),
      findsNothing,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.text('Onderbouw je volgende beslissing met bewijs.'),
      findsOneWidget,
    );
    expect(progressValue(), 1);

    await tester.tap(find.text('Terug naar start'));
    await tester.pumpAndSettle();

    expect(
      find.text('Agents voeren taken uit; skills geven ze instructies.'),
      findsOneWidget,
    );
    expect(progressValue(), 1 / totalSlides);
  });
}
