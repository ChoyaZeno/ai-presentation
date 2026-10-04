import 'package:ds_theme_cz/ds_theme_data_cz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:shared_components/extensions/build_context_extensions.dart';
import 'package:shared_components/l10n/shared_components_localizations.dart';
import 'package:shared_components/styling/app_theme.dart';
import 'package:shared_components/styling/base/ds_icon_assets.dart';
import 'package:shared_components/widgets/design_system/design_system.dart';
import 'package:widgetbook_app/cz_style/export_cz.dart';

final _czTheme = CzThemeData(designSystem: DsThemeDatacz());

const _promptTask =
    'Read the entire repository and identify every user-facing feature. '
    'For each feature, write clear BDD scenarios in Given / When / Then. '
    'Support each scenario with evidence from code, tests or documentation. '
    'Do not invent behavior; report gaps in coverage. Create the output '
    'directory if needed and write all .feature files only in';
const _promptWithSkill =
    '$_promptTask features/run-01/. Do not modify other files.';
const _promptWithoutSkill =
    '$_promptTask features/run-02/. Do not modify other files.';

const _agendaItems = [
  (
    'Start beide agents vóór de inhoudelijke slides.',
    DSIconAssets.arrowRight,
  ),
  (
    'Levert opsplitsen betere BDD-scenario’s op?',
    DSIconAssets.filesContract,
  ),
  (
    'Agents voeren uit; skills beschrijven de aanpak.',
    DSIconAssets.notificationCirclequestion,
  ),
  ('Kies het bestand dat bij het werk past.', DSIconAssets.layergroup),
  ('Gebruik de echte skill-metadata.', DSIconAssets.filesFile),
  (
    'De description bepaalt wanneer een skill relevant is.',
    DSIconAssets.pencil,
  ),
  ('Eén skillmap, met SKILL.md als startpunt.', DSIconAssets.layergroup),
  ('Veelgemaakte fouten in SKILL.md.', DSIconAssets.lock),
  ('Test een skill: drie stappen.', DSIconAssets.checkcircle),
  ('Skill Feud.', DSIconAssets.group),
  ('Terug naar de agentchats.', DSIconAssets.arrowRight),
  (
    'De hoofdagent bundelt en controleert resultaten.',
    DSIconAssets.filesContract,
  ),
  ('Is je skill klaar?', DSIconAssets.checkcircle),
  (
    'Onderbouw je volgende beslissing met bewijs.',
    DSIconAssets.arrowRight,
  ),
];

void main() => runApp(const PresentationApp());

class PresentationApp extends StatelessWidget {
  const PresentationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      appThemeData: _czTheme,
      child: FlutterDeckApp(
        configuration: FlutterDeckConfiguration(
          background: FlutterDeckBackgroundConfiguration(
            light: FlutterDeckBackground.solid(
              _czTheme.ds.color.backgroundSubtle,
            ),
            dark: FlutterDeckBackground.solid(_czTheme.colors.ant),
          ),
          footer: const FlutterDeckFooterConfiguration(showFooter: false),
          showProgress: false,
          slideSize: FlutterDeckSlideSize.fromAspectRatio(
            aspectRatio: const FlutterDeckAspectRatio.ratio16x9(),
            resolution: const FlutterDeckResolution.fhd(),
          ),
          transition: const FlutterDeckTransition.fade(),
        ),
        localizationsDelegates:
            SharedComponentsLocalizations.localizationsDelegates,
        supportedLocales: SharedComponentsLocalizations.supportedLocales,
        lightTheme: FlutterDeckThemeData.fromTheme(_czTheme.materialTheme),
        themeMode: ThemeMode.light,
        slides: [
          _slide(
            route: '/cover',
            title: 'Skills voor AI-agents',
            buttonLabel: 'Begin',
            content: (context) => _page(
              context,
              heading: 'Agents voeren taken uit; skills geven ze instructies.',
              subText:
                  'Ontdek het verschil tussen custom agents, subagents en skills, en zie hoe een skill onderzoek kan verdelen over subagents.',
              children: [
                Wrap(
                  spacing: context.theme.spacings.xs,
                  runSpacing: context.theme.spacings.xs,
                  children: const [
                    DSTag(
                      type: DSTagType.informative,
                      variant: DSTagVariant.border,
                      text: 'VS Code',
                    ),
                    DSTag(
                      type: DSTagType.informative,
                      variant: DSTagVariant.border,
                      text: 'GitHub Copilot',
                    ),
                    DSTag(
                      type: DSTagType.informative,
                      variant: DSTagVariant.border,
                      text: 'Agent Skills',
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.informative,
                  titleText: 'Dit neem je mee',
                  bodyText:
                      'Het verschil tussen agentrollen, subagents en skills; hoe de hoofdagent met een skill parallel onderzoek delegeert; en hoe je resultaten controleert. In de demo zet de hoofdagent gebruikersfeatures uit de repository om in BDD-featurebestanden.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/agenda',
            title: 'Agenda',
            content: (context) => _page(
              context,
              heading: 'Van voorbereiding naar vergelijking.',
              subText:
                  'We starten twee runs, bespreken de aanpak, vergelijken de resultaten en eindigen met een concrete volgende stap.',
              children: [
                _columns(context, [
                  DSList(
                    children: [
                      for (final (index, item) in _agendaItems.take(7).indexed)
                        DSListItem(
                          subjectIcon: item.$2,
                          label: item.$1,
                          content: (index + 1).toString().padLeft(2, '0'),
                        ),
                    ],
                  ),
                  DSList(
                    children: [
                      for (final (index, item) in _agendaItems.skip(7).indexed)
                        DSListItem(
                          subjectIcon: item.$2,
                          label: item.$1,
                          content: (index + 8).toString().padLeft(2, '0'),
                        ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/experiment-setup',
            title: 'Vergelijk met en zonder skill',
            content: (context) => _page(
              context,
              heading: 'Start beide agents vóór de inhoudelijke slides.',
              subText:
                  'We keren later terug om de resultaten te vergelijken.',
              children: [
                _columns(context, [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DSHeadings(
                        heading: 'Met skill',
                        type: DSHeadingsType.sectionHeading,
                        size: DSHeadingsSize.small,
                      ),
                      SizedBox(height: context.theme.spacings.s),
                      _promptBlock(context, withSkill: true),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DSHeadings(
                        heading: 'Zonder skill',
                        type: DSHeadingsType.sectionHeading,
                        size: DSHeadingsSize.small,
                      ),
                      SizedBox(height: context.theme.spacings.s),
                      _promptBlock(context, withSkill: false),
                    ],
                  ),
                ]),
                const DSNotification(
                  type: DSNotificationType.informative,
                  titleText:
                    'De opdrachten zijn gelijk; alleen de eerste begint met /multi-agent-brainstorm. Beide schrijven naar een eigen map.',
                  bodyText:
                    'Voor de skill-run kiezen we het subagent-model en de gewenste effort.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/body',
            title: 'Opdracht achter de vergelijking',
            content: (context) => _page(
              context,
              heading: 'Levert opsplitsen betere BDD-scenario’s op?',
              subText:
                  'We toetsen of meerdere afgebakende onderzoeken meer en concretere scenario’s opleveren dan één brede analyse.',
              children: [
                DsBulletList(
                  title: 'Wat vergelijken we?',
                  bulletItems: [
                    BulletListItem(
                      title: 'Meer relevante scenario’s',
                      text:
                          'Vinden we in aparte repositorydelen meer gebruikersfeatures en betekenisvolle varianten?',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Concretere scenario’s',
                      text:
                          'Zijn voorwaarden, acties en observeerbare uitkomsten specifieker in Given / When / Then?',
                      iconData: DSIconAssets.filesContract,
                    ),
                    BulletListItem(
                      title: 'Betere dekking en onderbouwing',
                      text:
                          'Zijn de scenario’s samen vollediger en aantoonbaar gebaseerd op code, tests of documentatie?',
                      iconData: DSIconAssets.checkcircle,
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.informative,
                  titleText: 'Eerst: agents en skills',
                  bodyText:
                      'We bekijken hoe een skill subagents kan inzetten om deze opdracht uit te voeren.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/why',
            title: 'Agents en skills',
            content: (context) => _page(
              context,
              heading: 'Agents voeren uit; skills beschrijven de aanpak.',
              subText:
                  'Een skill is geen agent: de hoofdagent volgt de instructies en kan daarin worden gevraagd subagents in te zetten.',
              children: [
                _columns(context, [
                  DsBulletList(
                    title: 'Agents en subagents',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'Een custom agent krijgt een eigen rol, instructies en beschikbare tools.',
                        iconData: DSIconAssets.group,
                      ),
                      BulletListItem(
                        text:
                            'Een subagent voert een afgebakende taak uit in een eigen contextvenster.',
                        iconData: DSIconAssets.filesFile,
                      ),
                      BulletListItem(
                        text:
                            'De subagent stuurt resultaten terug; de hoofdagent controleert en combineert die.',
                        iconData: DSIconAssets.checkcircle,
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'Skills',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'SKILL.md beschrijft taakgerichte kennis en een herhaalbare workflow.',
                        iconData: DSIconAssets.filesFile,
                      ),
                      BulletListItem(
                        text:
                            'Copilot kan de skill laden als je verzoek bij de description past; je kunt hem ook zelf aanroepen.',
                        iconData: DSIconAssets.search,
                      ),
                      BulletListItem(
                        text:
                            'De skill kan de hoofdagent instrueren om deelonderzoek aan subagents te delegeren.',
                        iconData: DSIconAssets.checkcircle,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/agent-files',
            title: 'Kies het juiste bestand',
            content: (context) => _page(
              context,
              heading: 'Kies het bestand dat bij het werk past.',
              subText:
                  'Leg teamafspraken, bestandsregels, rollen en herbruikbare taken vast op de juiste plek.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'copilot-instructions.md / AGENTS.md',
                      'Algemene afspraken voor het werken in deze repository. Bijvoorbeeld: gebruik onze codeconventies en voer tests uit na een wijziging.',
                      'Teamafspraken',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      '.github/instructions/*.instructions.md',
                      'Aanvullende regels voor bepaalde bestanden. Met applyTo geef je aan waar ze gelden, bijvoorbeeld testregels voor **/*_test.dart.',
                      'Bestandsregels',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      '.github/agents/*.agent.md',
                      'Een eigen rol voor Copilot, met instructies en een selectie van tools. Bijvoorbeeld: een reviewer die code beoordeelt, maar geen bestanden mag wijzigen.',
                      'Rol',
                      DSTagType.warning,
                    ),
                    _fileRow(
                      '.github/prompts/*.prompt.md',
                      'Een opgeslagen opdracht die je zelf aanroept. Bijvoorbeeld: vat een PR samen volgens een vast format. Alleen vragen om een PR-samenvatting activeert dit promptbestand niet; je moet het zelf kiezen.',
                      'Zelf aanroepen',
                      DSTagType.neutral,
                    ),
                    _fileRow(
                      '.github/skills/<skill-name>/SKILL.md',
                      'Een pakket met taakinstructies en eventueel scripts of voorbeelden. Ook voor PR-samenvattingen: de description vertelt wanneer de skill relevant is, zodat Copilot de aanpak zelf kan laden. Je kunt een skill ook zelf aanroepen.',
                      'Op aanvraag laden',
                      DSTagType.positive,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/frontmatter',
            title: 'Frontmatter',
            content: (context) => _page(
              context,
              heading: 'Gebruik de echte skill-metadata.',
              subText:
                  'Frontmatter is de YAML-header tussen twee regels met drie streepjes. Deze identificeert de skill en bepaalt wanneer die wordt geladen.',
              children: [
                _codeBlock(
                  context,
                  '---\n'
                  'name: multi-agent-brainstorm\n'
                  'description: >-\n'
                  '  Use when the user invokes this skill with a task for multi-agent\n'
                  '  coordination, or explicitly asks for parallel agent research, analysis,\n'
                  '  brainstorming, comparison, documentation, or implementation. The prompt\n'
                  '  after the slash defines the task and deliverable; BDD feature documentation\n'
                  '  is one example, not the skill\'s sole purpose.\n'
                  'argument-hint: \'Describe the task, desired outcome, scope and constraints, output location, and optional agent count or model.\'\n'
                  'user-invocable: true\n'
                  '---',
                ),
                DSList(
                  children: [
                    _fileRow(
                      'Map en naam moeten overeenkomen',
                      '.github/skills/multi-agent-brainstorm/SKILL.md',
                      'Verplicht',
                      DSTagType.neutral,
                    ),
                    _fileRow(
                      'argument-hint',
                      'De hint vraagt om taak, gewenst resultaat, scope, beperkingen en uitvoerlocatie; agentenaantal en model zijn optioneel.',
                      'Optioneel',
                      DSTagType.neutral,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/description',
            title: 'De description schrijven',
            content: (context) => _page(
              context,
              heading: 'De description bepaalt wanneer een skill relevant is.',
              subText:
                  'Te breed matcht verkeerd, te smal mist relevante verzoeken.',
              children: [
                _columns(context, [
                  const DSNotification(
                    type: DSNotificationType.error,
                    titleText: 'Te vaag',
                    bodyText: '"Helpt bij AI-taken."',
                  ),
                  const DSNotification(
                    type: DSNotificationType.success,
                    titleText: 'Specifiek en activeerbaar',
                    bodyText:
                      '"Gebruik bij verzoeken die baat hebben bij parallel onderzoek, vergelijking of documentatie met agents."',
                  ),
                ]),
                _columns(context, [
                  DSList(
                    children: [
                      _fileRow(
                        '1. Metadata: name + description',
                        'Maakt de skill vindbaar.',
                        'Vindbaarheid',
                        DSTagType.positive,
                      ),
                      _fileRow(
                        '2. Body van SKILL.md',
                        'Beschrijft de stappen en waarborgen die de agent volgt.',
                        'Bij een match',
                        DSTagType.informative,
                      ),
                      _fileRow(
                        '3. Optionele bestanden',
                        'Scripts, checklists of referenties alleen als ze helpen; verwijs ernaar vanuit SKILL.md.',
                        'Optioneel',
                        DSTagType.neutral,
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'Wat maakt een description duidelijk?',
                    bulletItems: [
                      BulletListItem(
                        title: 'Benoem wanneer de skill past',
                        text:
                            'Koppel de skill aan een passend verzoek, niet aan elke technische vraag. '
                            '“Helpt bij AI-taken” is te algemeen; “Gebruik bij het testen van API-endpoints” is duidelijker.',
                        iconData: DSIconAssets.pencil,
                      ),
                      BulletListItem(
                        title: 'Noem concrete taken',
                        text:
                            'Bijvoorbeeld: onderzoek, analyse, brainstormen, vergelijken, documenteren of implementeren met agents.',
                        iconData: DSIconAssets.comment,
                      ),
                      BulletListItem(
                        title: 'Herkenbare termen',
                        text:
                          'Gebruik woorden die jij en je team zelf voor deze taak gebruiken.',
                        iconData: DSIconAssets.search,
                      ),
                      BulletListItem(
                        title: 'Test de skill regelmatig',
                        text:
                            'Controleer of de skill nog op het juiste moment wordt geladen en goed presteert.',
                        iconData: DSIconAssets.filter,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/anatomy',
            title: 'Opbouw van een skill',
            content: (context) => _page(
              context,
              heading: 'Eén skillmap, met SKILL.md als startpunt.',
              subText:
                  'In deze map staat alleen SKILL.md: daarin staan de metadata, grenzen en een taakgestuurde coördinatiewerkwijze. Extra bestanden zijn optioneel.',
              children: [
                _columns(context, [
                  DSList(
                    children: const [
                      DSListItem(
                        subjectIcon: DSIconAssets.layergroup,
                        label: '.github/skills/multi-agent-brainstorm/',
                        content: 'Skillmap',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesFile,
                        label: 'SKILL.md',
                        content: 'Verplicht startpunt',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.pencil,
                        label: 'Frontmatter',
                        content: 'Naam + description',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.lock,
                        label: 'Body',
                        content: 'Grenzen + werkwijze',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesContract,
                        label: 'Scripts / referenties / assets',
                        content: 'Optioneel; geen aanwezig',
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'Wat deze SKILL.md aanstuurt',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'De opdracht na /multi-agent-brainstorm bepaalt de taak; de skill geeft een generieke coördinatiewerkwijze.',
                        iconData: DSIconAssets.filesFile,
                      ),
                      BulletListItem(
                        text:
                            'De hoofdagent verdeelt onafhankelijk werk over subagents met taakgerichte opdrachten.',
                        iconData: DSIconAssets.group,
                      ),
                      BulletListItem(
                        text:
                            'De hoofdagent combineert en controleert hun resultaten en levert de gevraagde output; BDD .feature-bestanden zijn één voorbeeld.',
                        iconData: DSIconAssets.filesContract,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/mistakes',
            title: 'Veelvoorkomende fouten',
            content: (context) => _page(
              context,
              heading: 'Veelgemaakte fouten in SKILL.md.',
              subText:
                  'Een bruikbare SKILL.md maakt de werkwijze concreet, begrensd en veilig.',
              children: [
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Instructies blijven algemeen',
                    bodyText:
                        'Vervang algemene achtergrond door concrete stappen, beslismomenten en verwachte uitvoer.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Scope en uitzonderingen ontbreken',
                    bodyText:
                        'Leg vast wat de skill wel en niet doet, en wanneer de agent moet doorvragen of stoppen.',
                  ),
                ]),
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Extra bestanden staan los',
                    bodyText:
                        'Verwijs vanuit SKILL.md naar scripts en referenties. Beschrijf wanneer de agent ze gebruikt.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Risicovolle acties zijn onbegrensd',
                    bodyText:
                        'Benoem risicovolle acties en vereiste toestemming; SKILL.md-instructies vervangen geen toolbeperkingen.',
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/testing',
            title: 'Test de skill',
            content: (context) => _page(
              context,
              heading: 'Test een skill: drie stappen.',
              subText: 'Check of de skill start, goed werkt en iets toevoegt.',
              children: [
                DsBulletList(
                  title: 'Drie vragen',
                  bulletItems: [
                    BulletListItem(
                      title: 'Wordt de skill op het juiste moment geladen?',
                      text:
                          'Test een passend en een niet-passend verzoek. Controleer beide uitkomsten.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Levert de skill goed werk?',
                      text:
                          'Gebruik een echte taak en criteria die je vooraf vastlegt.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                    BulletListItem(
                      title: 'Voegt de skill iets toe?',
                      text:
                          'Test dezelfde taak in nieuwe sessies, met en zonder skill. Vergelijk kwaliteit, tijd en tokens.',
                      iconData: DSIconAssets.arrowRotateright,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/skill-feud',
            title: 'Game: Skill Feud',
            content: (context) => const _SkillFeud(),
          ),
          _slide(
            route: '/demo',
            title: 'Demo: resultaten vergelijken',
            content: (context) => _page(
              context,
              heading: 'Terug naar de agentchats.',
              subText:
                  'We leggen de voorstellen uit beide runs naast elkaar. Wat valt ons op aan de aanpak, volledigheid en kwaliteit van de BDD-scenario’s?',
              children: [
                DsBulletList(
                  title: 'Waar je op let bij de vergelijking',
                  bulletItems: [
                    BulletListItem(
                      title: 'Hoe is het onderzoek uitgevoerd?',
                      text:
                          'Controleer welke skills en subagents elke run heeft gebruikt. Zonder expliciete skill-aanroep kan Copilot een skill alsnog automatisch laden. Subagents onderzoeken in aparte contextvensters en sturen hun bevindingen terug naar de hoofdagent.',
                      iconData: DSIconAssets.group,
                    ),
                    BulletListItem(
                      title: 'Is elke gebruikersfeature geïnventariseerd?',
                      text:
                          'Controleer de volledige scope per appgebied, rol, platform en betekenisvolle variant.',
                      iconData: DSIconAssets.group,
                    ),
                    BulletListItem(
                      title: 'Is ieder scenario onderbouwd?',
                      text:
                          'Verifieer gedrag met code, tests of documentatie. Noteer hiaten in plaats van gedrag te verzinnen.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Zijn de voorgestelde bestanden bruikbaar?',
                      text:
                          'Controleer de Given / When / Then-structuur, samengevoegde overlap en expliciete scopehiaten.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/synthesize',
            title: 'Van onderzoek naar featurebestanden',
            content: (context) => _page(
              context,
              heading: 'De hoofdagent bundelt en controleert resultaten.',
              subText:
                  'Subagents onderzoeken aparte delen van de app. De hoofdagent maakt van hun bevindingen een samenhangende set BDD-featurebestanden.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'Voeg dubbele scenario’s samen',
                      'Beschrijven meerdere subagents hetzelfde gedrag? Maak er één scenario van. Behoud verschillen per rol, platform of situatie.',
                      'Bundelen',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      'Controleer elk scenario',
                      'Vergelijk de stappen met code, tests of documentatie. Neem gedrag niet op als je er geen bewijs voor vindt.',
                      'Bewijs',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      'Loop de featurelijst na',
                      'Elke feature binnen scope krijgt een scenario. Noteer welke features niet genoeg bewijs hebben.',
                      'Compleet',
                      DSTagType.warning,
                    ),
                    _fileRow(
                      'Laat de hoofdagent de bestanden schrijven',
                      'Subagents leveren alleen onderzoek aan. De hoofdagent schrijft de .feature-bestanden en vermeldt wat nog niet is gecontroleerd.',
                      'Uitvoer',
                      DSTagType.neutral,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/checklist',
            title: 'Checklist',
            content: (context) => const _Checklist(),
          ),
          _slide(
            route: '/closing',
            title: 'Begin klein',
            buttonLabel: 'Terug naar start',
            onPrimaryPressed: (context) => context.flutterDeck.goToSlide(1),
            content: (context) => _page(
              context,
              heading: 'Onderbouw je volgende beslissing met bewijs.',
              subText:
                  'Deze week: beschrijf in SKILL.md een werkwijze die je agent kan herhalen. Test de skill in een nieuw gesprek en deel de skill zodra de checklist is doorlopen.',
              children: [
                DsBulletList(
                  title: 'Zo begin je met je eigen skill',
                  bulletItems: [
                    BulletListItem(
                      title: 'Kies één terugkerende taak',
                      text:
                          'Begin met iets uit je eigen werk, zoals code review, testen of documentatie schrijven.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Leg de aanpak vast',
                      text:
                          'Beschrijf in SKILL.md wanneer de skill past, welke stappen de agent volgt en wat het resultaat moet zijn.',
                      iconData: DSIconAssets.pencil,
                    ),
                    BulletListItem(
                      title: 'Probeer uit en verbeter',
                      text:
                          'Test met een echte opdracht in een nieuw gesprek. Pas de instructies aan als het resultaat niet voldoet.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                    BulletListItem(
                      title: 'Deel met je team',
                      text:
                          'Loop de checklist na, laat een collega de skill proberen en verwerk de feedback.',
                      iconData: DSIconAssets.group,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

FlutterDeckSlide _slide({
  required String route,
  required String title,
  required Widget Function(BuildContext context) content,
  String buttonLabel = 'Volgende',
  void Function(BuildContext context)? onPrimaryPressed,
}) {
  return FlutterDeckSlide.template(
    configuration: FlutterDeckSlideConfiguration(route: route, title: title),
    contentBuilder: (context) => _declarationStyledSlide(
      context: context,
      content: content(context),
      buttonLabel: buttonLabel,
      onPrimaryPressed: () => onPrimaryPressed != null
          ? onPrimaryPressed(context)
          : context.flutterDeck.next(),
    ),
  );
}

Widget _page(
  BuildContext context, {
  required String heading,
  required String subText,
  required List<Widget> children,
}) {
  final spacing = context.theme.spacings;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DSHeadings(
        heading: heading,
        subText: subText,
        type: DSHeadingsType.pageHeading,
        size: DSHeadingsSize.large,
      ),
      for (final child in children) ...[SizedBox(height: spacing.l), child],
    ],
  );
}

Widget _codeBlock(BuildContext context, String code) {
  final theme = context.theme;
  return DSCard(
    child: Padding(
      padding: EdgeInsets.all(theme.spacings.m),
      child: SelectableText(
        code,
        style: theme.textStyles.bodyM.copyWith(fontFamily: 'monospace'),
      ),
    ),
  );
}

Widget _promptBlock(BuildContext context, {required bool withSkill}) {
  final theme = context.theme;
  final textStyle = theme.textStyles.bodyM.copyWith(fontFamily: 'monospace');

  return DSCard(
    child: Padding(
      padding: EdgeInsets.all(theme.spacings.m),
      child: SelectableText.rich(
        TextSpan(
          style: textStyle,
          children: [
            if (withSkill)
              TextSpan(
                text: '/multi-agent-brainstorm\n',
                style: textStyle.copyWith(fontWeight: FontWeight.bold),
              )
            else
              const TextSpan(text: '\n'),
            TextSpan(text: withSkill ? _promptWithSkill : _promptWithoutSkill),
          ],
        ),
      ),
    ),
  );
}

Widget _columns(BuildContext context, List<Widget> children) {
  final spacing = context.theme.spacings;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final (index, child) in children.indexed) ...[
        if (index > 0) SizedBox(width: spacing.l),
        Expanded(child: child),
      ],
    ],
  );
}

DSListItem _fileRow(String label, String content, String tag, DSTagType type) {
  return DSListItem.twoLiner(
    label: label,
    content: content,
    trailing: DSTag(type: type, variant: DSTagVariant.standard, text: tag),
  );
}

typedef _FeudAnswer = ({String answer, String detail, int points});

const List<_FeudAnswer> _agentAnswers = [
  (
    answer: 'Geef een reviewer eigen rolinstructies',
    detail:
        'Bepaal de prioriteiten en verwachte uitvoer van de reviewer, niet een taakrecept.',
    points: 30,
  ),
  (
    answer: 'Beperk een planner tot read-only tools',
    detail:
        'Configureer welke tools de rol mag gebruiken; dat is toolselectie, geen workflowbegeleiding.',
    points: 25,
  ),
  (
    answer: 'Configureer een model voor een specialistische rol',
    detail:
        'Stel het model van de custom agent in als de gekozen VS Code-harness dit ondersteunt.',
    points: 20,
  ),
  (
    answer: 'Schakel over van plannen naar implementeren',
    detail:
        'Een handoff wisselt de actieve agent met behoud van de conversation context en een vooraf ingevulde prompt voor de volgende stap.',
    points: 15,
  ),
  (
    answer: 'Delegeer research en ontvang het resultaat',
    detail:
        'Een custom subagent voert het gedelegeerde werk uit; de parent-agent gaat verder met het resultaat in plaats van van rol te wisselen.',
    points: 10,
  ),
];

const List<_FeudAnswer> _skillAnswers = [
  (
    answer: 'Leer een herhaalbare testprocedure aan',
    detail:
        'Verpak de taakstappen en verwachte resultaten los van de rol van de agent.',
    points: 30,
  ),
  (
    answer: 'Bundel een setup-script en service-templates',
    detail:
        'Verspreid de workflow met ondersteunende bestanden waarnaar SKILL.md verwijst.',
    points: 25,
  ),
  (
    answer: 'Maak domeinkennis op aanvraag vindbaar',
    detail:
        'Metadata helpt een taak te matchen; instructies worden geladen wanneer de skill wordt aangeroepen. Relevantie garandeert geen activatie.',
    points: 20,
  ),
  (
    answer: 'Deel taakkennis tussen AI-producten',
    detail:
        'Gebruik de Agent Skills-standaard in compatibele producten; controleer locaties, dependencies en optionele features.',
    points: 15,
  ),
  (
    answer: 'Maak een deployment-recept alleen handmatig aanroepbaar',
    detail:
        'Stel disable-model-invocation: true in en roep /skill-name zelf aan; dit regelt activatie, niet permissions.',
    points: 10,
  ),
];

class _SkillFeud extends StatelessWidget {
  const _SkillFeud();

  @override
  Widget build(BuildContext context) {
    return _page(
      context,
      heading: 'Skill Feud.',
      subText:
          'Een custom agent krijgt een eigen rol; een skill beschrijft hoe je een taak uitvoert.\nBron: VS Code-documentatie.',
      children: [
        const Text(
          'Twee teams proberen om de beurt de verborgen antwoorden te raden. De presentator onthult goed geraden antwoorden en houdt missers bij.',
        ),
        _columns(context, const [
          _FeudBoard(title: 'Custom agent (.agent.md)', answers: _agentAnswers),
          _FeudBoard(title: 'Agent skill (SKILL.md)', answers: _skillAnswers),
        ]),
      ],
    );
  }
}

class _FeudBoard extends StatefulWidget {
  const _FeudBoard({required this.title, required this.answers});

  final String title;
  final List<_FeudAnswer> answers;

  @override
  State<_FeudBoard> createState() => _FeudBoardState();
}

class _FeudBoardState extends State<_FeudBoard> {
  static const _maxStrikes = 3;

  final Set<int> _revealed = {};
  int _strikes = 0;

  int get _score =>
      _revealed.fold(0, (total, index) => total + widget.answers[index].points);

  @override
  Widget build(BuildContext context) {
    final spacing = context.theme.spacings;
    final allRevealed = _revealed.length == widget.answers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSHeadings(
          heading: widget.title,
          type: DSHeadingsType.sectionHeading,
          size: DSHeadingsSize.small,
          slot: DSTag(
            type: DSTagType.positive,
            variant: DSTagVariant.standard,
            text: 'Score: $_score',
          ),
        ),
        SizedBox(height: spacing.s),
        DSList(
          children: [
            for (final (index, item) in widget.answers.indexed)
              _revealed.contains(index)
                  ? DSListItem(
                      subjectIcon: DSIconAssets.checkcircle,
                      label: item.answer,
                      content: '${item.points}',
                      description: item.detail,
                    )
                  : DSListItem(
                      subjectIcon: DSIconAssets.notificationCirclequestion,
                      label: 'Antwoord ${index + 1}',
                      content: '?',
                      semanticHint: 'Toon antwoord ${index + 1}',
                      onTap: () => setState(() => _revealed.add(index)),
                    ),
          ],
        ),
        SizedBox(height: spacing.s),
        Row(
          children: [
            DSButton.secondary(
              text: 'Fout antwoord',
              size: DSButtonSize.small,
              width: DSButtonWidth.hug,
              leadingIcon: DSIconAssets.times,
              onPressed: _strikes < _maxStrikes && !allRevealed
                  ? () => setState(() => _strikes++)
                  : null,
            ),
            SizedBox(width: spacing.s),
            DSButton.tertiary(
              text: 'Alles tonen',
              size: DSButtonSize.small,
              width: DSButtonWidth.hug,
              onPressed: allRevealed
                  ? null
                  : () => setState(
                      () => _revealed.addAll(
                        List.generate(widget.answers.length, (i) => i),
                      ),
                    ),
            ),
            SizedBox(width: spacing.s),
            for (var i = 0; i < _strikes; i++) ...[
              const DSTag(
                type: DSTagType.negative,
                variant: DSTagVariant.standard,
                text: 'Fout',
                leadingIcon: DSIconAssets.times,
              ),
              SizedBox(width: spacing.xxs),
            ],
          ],
        ),
        if (_strikes == _maxStrikes && !allRevealed) ...[
          SizedBox(height: spacing.s),
          const DSNotification(
            type: DSNotificationType.error,
            titleText: 'Drie missers!',
            bodyText: 'Het andere team krijgt één kans om de punten te stelen.',
          ),
        ],
      ],
    );
  }
}

class _Checklist extends StatefulWidget {
  const _Checklist();

  @override
  State<_Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<_Checklist> {
  static const _items = [
    (
      'Staan bestand en metadata goed?',
      'Gebruik <naam>/SKILL.md met geldige YAML. In VS Code moeten mapnaam en naam in YAML overeenkomen.',
    ),
    (
      'Is duidelijk wanneer de skill past?',
      'Benoem de taak en wanneer de agent de skill moet laden.',
    ),
    (
      'Kan de agent de stappen volgen?',
      'Geef concrete stappen, grenzen en beslismomenten.',
    ),
    (
      'Is duidelijk wat een goed resultaat is?',
      'Geef een voorbeeld en leg uit hoe je het resultaat controleert.',
    ),
    (
      'Zijn extra bestanden goed gekoppeld?',
      'Verwijs naar scripts of voorbeelden en leg uit wanneer de agent ze gebruikt.',
    ),
    (
      'Zijn risicovolle acties begrensd?',
      'Leg vast wanneer de agent toestemming vraagt of moet stoppen.',
    ),
    (
      'Heb je de skill in de praktijk getest?',
      'Test passende en niet-passende verzoeken. Vergelijk in aparte gesprekken dezelfde taak met en zonder skill.',
    ),
  ];

  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    final spacing = context.theme.spacings;
    final done = _checked.length == _items.length;

    return _page(
      context,
      heading: 'Is je skill klaar?',
      subText: 'Loop deze lijst na voordat je de skill met je team deelt.',
      children: [
        _columns(context, [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, item) in _items.indexed) ...[
                if (index > 0) SizedBox(height: spacing.xs),
                DSCheckbox(
                  label: item.$1,
                  subtitle: item.$2,
                  value: _checked.contains(index),
                  onChanged: (value) => setState(
                    () => value == true
                        ? _checked.add(index)
                        : _checked.remove(index),
                  ),
                ),
              ],
            ],
          ),
          done
              ? const DSNotification(
                  type: DSNotificationType.success,
                  titleText: 'Klaar om te delen',
                  bodyText:
                      'De checklist is doorlopen. Deel de skill en verwerk feedback van je team.',
                )
              : DSNotification(
                  type: DSNotificationType.informative,
                  titleText:
                      '${_checked.length} van ${_items.length} afgevinkt',
                  bodyText:
                      'Controleer de skill zelf voordat je deze deelt, niet alleen het resultaat van één run.',
                ),
        ]),
      ],
    );
  }
}

Widget _declarationStyledSlide({
  required BuildContext context,
  required Widget content,
  required String buttonLabel,
  required VoidCallback onPrimaryPressed,
}) {
  final deck = context.flutterDeck;
  final slides = deck.router.slides;
  final totalSteps = slides.fold<int>(
    0,
    (total, slide) => total + slide.configuration.steps,
  );
  final completedSteps = slides
      .take(deck.slideNumber - 1)
      .fold<int>(0, (total, slide) => total + slide.configuration.steps);
  final progress = (completedSteps + deck.stepNumber) / totalSteps;
  final theme = AppTheme.of(context)!;

  return DSFocusOverlay(
    header: const DSFocusOverlayHeader(title: 'Skills voor AI-agents'),
    // Mirrors DSLinearProgressBar without its restart-from-zero animation.
    progressBar: LinearProgressIndicator(
      value: progress,
      semanticsLabel: 'Voortgang van de presentatie',
      semanticsValue: '${(progress * 100).round()}%',
      minHeight: theme.spacings.s,
      backgroundColor: theme.colors.mule,
    ),
    content: content,
    buttonDock: DSButtonDock(
      primaryButton: DSButton.primary(
        text: buttonLabel,
        onPressed: onPrimaryPressed,
      ),
    ),
  );
}
