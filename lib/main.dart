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
            title: 'Skills for AI agents',
            buttonLabel: 'Start',
            content: (context) => _page(
              context,
              heading: 'Multi-agent brainstorming, made rigorous.',
              subText:
                  'For developers already using Copilot: build a reusable brainstorm workflow, then verify what it returns.',
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
                  titleText: 'What you will leave with',
                  bodyText:
                      'A skill header, a repeatable research workflow, and an authoring checklist. Gherkin documentation is a short second use case.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/agenda',
            title: 'Agenda',
            content: (context) => _page(
              context,
              heading: 'From a broad question to evidence.',
              subText: 'The workflow inside multi-agent-brainstorm.',
              children: [
                DSList(
                  children: [
                    for (final (index, item) in const [
                      (
                        'When this skill fits',
                        DSIconAssets.notificationCirclequestion,
                      ),
                      ('Pick the right file', DSIconAssets.layergroup),
                      ('Trigger and anatomy', DSIconAssets.filesFile),
                      ('Frame and delegate', DSIconAssets.group),
                      ('Research guardrails', DSIconAssets.lock),
                      ('Synthesize and verify', DSIconAssets.checkcircle),
                      ('Second use case: Gherkin docs', DSIconAssets.book),
                      ('Game: Skill Feud', DSIconAssets.group),
                      ('Live demo', DSIconAssets.arrowRight),
                    ].indexed)
                      DSListItem(
                        subjectIcon: item.$2,
                        label: item.$1,
                        content: (index + 1).toString().padLeft(2, '0'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/why',
            title: 'Why skills?',
            content: (context) => _page(
              context,
              heading: 'One skill, two high-value jobs.',
              subText:
                  'Today\'s main thread is independent brainstorming. The same skill also supports a separate app-documentation workflow.',
              children: [
                _columns(context, [
                  DsBulletList(
                    title: 'Broad brainstorm',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'Explore a broad question with meaningfully different options.',
                        iconData: DSIconAssets.search,
                      ),
                      BulletListItem(
                        text: 'Use independent, read-only research agents.',
                        iconData: DSIconAssets.group,
                      ),
                      BulletListItem(
                        text: 'Finish with a small set of testable choices.',
                        iconData: DSIconAssets.checkcircle,
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'Second use case: app documentation',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'Inventory the app\'s observable user-facing behavior.',
                        iconData: DSIconAssets.eye,
                      ),
                      BulletListItem(
                        text: 'Write evidence-backed Gherkin .feature files.',
                        iconData: DSIconAssets.filesFile,
                      ),
                      BulletListItem(
                        text:
                            'Track coverage and report evidence gaps honestly.',
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
            title: 'Pick the right file',
            content: (context) => _page(
              context,
              heading: 'Use the file that matches the work.',
              subText:
                  'This example is a user-invocable skill, not an autonomous agent persona.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'copilot-instructions.md / AGENTS.md',
                      'Repo-wide conventions that apply regardless of the current task.',
                      'Always on',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      '.github/instructions/*.instructions.md',
                      'Rules for matching paths, scoped with a narrow applyTo glob.',
                      'By file path',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      '.github/agents/*.agent.md',
                      'A specialist role with its own tools, model, and boundaries.',
                      'A role',
                      DSTagType.warning,
                    ),
                    _fileRow(
                      '.github/prompts/*.prompt.md',
                      'One reusable task that you start yourself.',
                      'A command',
                      DSTagType.neutral,
                    ),
                    _fileRow(
                      '.github/skills/multi-agent-brainstorm/SKILL.md',
                      'A discoverable workflow with explicit triggers, guardrails, and two procedures.',
                      'A capability',
                      DSTagType.positive,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/loading',
            title: 'How skills get loaded',
            content: (context) => _page(
              context,
              heading: 'The description is the gatekeeper.',
              subText:
                  'The agent sees the trigger first; the workflow is relevant only after the request matches.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      '1. Metadata: name + description',
                      'Always available for discovery. Name both brainstorm/comparison requests and full-app Gherkin documentation.',
                      'Always loaded',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      '2. Body of SKILL.md',
                      'Holds the guardrails, brainstorm workflow, and app feature documentation workflow.',
                      'On match',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      '3. Optional resources',
                      'Add scripts/, references/, or assets/ only when this skill needs reusable supporting material.',
                      'On demand',
                      DSTagType.neutral,
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.warning,
                  titleText: 'The description is the gatekeeper',
                  bodyText:
                      'If the description does not match the request, nothing else in your skill is ever read.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/anatomy',
            title: 'Anatomy of a skill',
            content: (context) => _page(
              context,
              heading: 'One folder packages a focused workflow.',
              subText:
                  'The current multi-agent-brainstorm skill keeps its process and reusable prompt patterns in SKILL.md.',
              children: [
                _columns(context, [
                  DSList(
                    children: const [
                      DSListItem(
                        subjectIcon: DSIconAssets.layergroup,
                        label: '.github/skills/multi-agent-brainstorm/',
                        content: 'Folder',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesFile,
                        label: 'SKILL.md',
                        content: 'Required',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.lock,
                        label: 'Guardrails + workflow',
                        content: 'Core',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.group,
                        label: 'Prompt patterns',
                        content: 'Reusable',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesContract,
                        label: 'App feature docs',
                        content: 'Second path',
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'What makes this skill work',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'The name matches the folder and the description states exact trigger conditions.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text:
                            'The user-invocable skill asks before each run for reasoning effort.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text:
                            'Each agent gets a distinct, non-overlapping lens.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text:
                            'Claims are verified; no result is accepted by vote alone.',
                        iconData: DSIconAssets.check,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/frontmatter',
            title: 'Frontmatter',
            content: (context) => _page(
              context,
              heading: 'Use the real skill metadata.',
              subText:
                  'Frontmatter is the YAML header between --- markers. It identifies the skill and says when to load it.',
              children: [
                _codeBlock(
                  context,
                  '---\n'
                  'name: multi-agent-brainstorm\n'
                  'description: >-\n'
                  '  Use when the user explicitly asks to brainstorm with multiple agents,\n'
                  '  compare independent technical approaches, or document an application\'s\n'
                  '  full user-facing functionality in Gherkin .feature files.\n'
                  'user-invocable: true\n'
                  '---',
                ),
                DSList(
                  children: [
                    _fileRow(
                      'Folder and name must match',
                      '.github/skills/multi-agent-brainstorm/SKILL.md',
                      'Required',
                      DSTagType.neutral,
                    ),
                    _fileRow(
                      'argument-hint',
                      'The full skill also includes a hint for question, scope, model, and output location.',
                      'Optional',
                      DSTagType.neutral,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/description',
            title: 'Writing the description',
            content: (context) => _page(
              context,
              heading: 'The description must name both paths.',
              subText:
                  'A vague trigger either misses the workflow or activates it for unrelated work.',
              children: [
                _columns(context, [
                  const DSNotification(
                    type: DSNotificationType.error,
                    titleText: 'Too vague',
                    bodyText: '"Helps with AI tasks."',
                  ),
                  const DSNotification(
                    type: DSNotificationType.success,
                    titleText: 'Specific and triggerable',
                    bodyText:
                        '"Use when the user explicitly asks to brainstorm with multiple agents, compare independent technical approaches, '
                        'or document an application\'s full user-facing functionality in Gherkin .feature files."',
                  ),
                ]),
                DsBulletList(
                  title: 'Why this trigger is discoverable',
                  bulletItems: [
                    BulletListItem(
                      title: 'State the invocation condition',
                      text:
                          'It is for an explicit request, not every technical question.',
                      iconData: DSIconAssets.pencil,
                    ),
                    BulletListItem(
                      title: 'Name each supported workflow',
                      text:
                          'Independent brainstorming and full-app Gherkin documentation.',
                      iconData: DSIconAssets.comment,
                    ),
                    BulletListItem(
                      title: 'Use concrete language',
                      text:
                          'Multiple agents, technical approaches, user-facing behavior, Gherkin.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Keep the scope honest',
                      text:
                          'The skill does not claim to solve every AI or documentation task.',
                      iconData: DSIconAssets.arrowUp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/body',
            title: 'Writing the body',
            content: (context) => _page(
              context,
              heading: 'Brainstorm workflow: frame, then divide.',
              subText:
                  'Example decision: should a tool-routing app use a local model, a hosted model, or a hybrid?',
              children: [
                DsBulletList(
                  title: 'Before agents start',
                  bulletItems: [
                    BulletListItem(
                      title: 'Frame the decision',
                      text:
                          'State the target, constraints, and verified facts. Label anything else as an assumption.',
                      iconData: DSIconAssets.bullit,
                    ),
                    BulletListItem(
                      title: 'Choose model and effort',
                      text:
                          'Resolve the subagent model, then ask for analysis depth each run. Disclose if effort is only prompt guidance.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Four lenses, one shared brief',
                      text:
                          'Local capability, hosted feasibility, on-device performance, and safe execution. Research is read-only; never share secrets.',
                      iconData: DSIconAssets.group,
                    ),
                    BulletListItem(
                      title: 'Specify a return contract',
                      text:
                          'Each lens returns options, evidence, risks, and one test that could reject its recommendation.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/synthesize',
            title: 'Synthesize and verify',
            content: (context) => _page(
              context,
              heading: 'Synthesize; do not vote.',
              subText:
                  'Agreement is not proof. The coordinating thread owns verification, follow-up tests, and all edits.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'Group overlap; surface disagreement',
                      'Independent perspectives should expose different options, not create a vote.',
                      'Compare',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      'Verify consequential claims',
                      'Check repository evidence, tests, or authoritative documentation before recommending.',
                      'Evidence',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      'Choose the next discriminating test',
                      'State its baseline and pass criterion before running it.',
                      'Test',
                      DSTagType.warning,
                    ),
                    _fileRow(
                      'Stop and report honestly',
                      'Record blockers, budget limits, unresolved risks, or incomplete work.',
                      'Report',
                      DSTagType.neutral,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/feature-docs',
            title: 'App feature documentation',
            content: (context) => _page(
              context,
              heading: 'For app docs, prove coverage.',
              subText:
                  'Second use case: Gherkin describes behavior as Given / When / Then. Here is a capability verified by this deck\'s widget test.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'Observe and verify',
                      'Skill Feud has two Reveal all controls. The widget test verifies both boards reach 100.',
                      'Evidence',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      'Record the mapping',
                      'A coverage ledger is a table: capability -> evidence -> scenario or an explicit gap.',
                      'Trace',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      'Check the whole inventory',
                      'One example is not full coverage. Every in-scope capability needs a scenario or a recorded gap.',
                      'Gate',
                      DSTagType.warning,
                    ),
                  ],
                ),
                _codeBlock(
                  context,
                  'Feature: Skill Feud\n'
                  '  Scenario: Reveal every answer\n'
                  '    Given both boards have unrevealed answers\n'
                  '    When I reveal all answers on both boards\n'
                  '    Then each board shows a score of 100',
                ),
                const Text(
                  'Illustrative documentation, not an executable Gherkin test.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/mistakes',
            title: 'Common mistakes',
            content: (context) => _page(
              context,
              heading: 'Guardrails prevent predictable failures.',
              subText:
                  'Independent perspectives are useful only when the prompts and conclusions are handled carefully.',
              children: [
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Overlapping lenses',
                    bodyText:
                        'Near-identical agents add noise instead of independent evidence.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Treating agreement as proof',
                    bodyText:
                        'Verify consequential claims against code, tests, or trusted docs.',
                  ),
                ]),
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Silent model substitution',
                    bodyText:
                        'Honor the requested model; label unavailable details and prompt-only effort honestly.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Claiming complete app coverage early',
                    bodyText:
                        'Map every in-scope capability or record an evidence gap/out-of-scope item.',
                  ),
                ]),
              ],
            ),
          ),
          _slide(
            route: '/testing',
            title: 'Test like code',
            content: (context) => _page(
              context,
              heading: 'Validate the workflow, not agent charisma.',
              subText:
                  'Test the trigger, the independence of the research, and whether the conclusion is evidence-backed.',
              children: [
                DSList(
                  children: const [
                    DSListItem(
                      subjectIcon: DSIconAssets.pencil,
                      label:
                          'Positive: ask for independent technical approaches',
                      content: '01',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.comment,
                      label:
                          'Near miss: give a simple task with one clear owner',
                      content: '02',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.eye,
                      label:
                          'Confirm model resolution and effort question each run',
                      content: '03',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.arrowRotateright,
                      label:
                          'Check each agent has a distinct lens and shared facts',
                      content: '04',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.group,
                      label: 'Verify recommendations with a baseline test',
                      content: '05',
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.success,
                  titleText: 'Test the boundaries too',
                  bodyText:
                      'Check that explicit requests trigger the workflow and routine single-owner tasks do not fan out unnecessarily.',
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
            title: 'Live demo: model-selected tool routing',
            content: (context) => _page(
              context,
              heading: 'Demo: model-selected tool routing.',
              subText:
                  'Prepared hypothetical case, not claims about a real app. Watch how independent lenses change the recommendation.',
              children: [
                _columns(context, [
                  const DSNotification(
                    type: DSNotificationType.informative,
                    titleText: 'Live prompt: four independent lenses',
                    bodyText:
                        '/multi-agent-brainstorm Compare local, hosted, and hybrid tool routing for a hypothetical support app. Assume it must work offline, never send customer data to a provider, and always ask before write actions. No model or latency benchmarks exist yet. Use four lenses: local capability, hosted feasibility/privacy, on-device performance, and safe dispatch. Return ranked options, evidence vs assumptions, risks, and one minimal test. Research only; do not edit.',
                  ),
                  DSList(
                    children: [
                      DSListItem.twoLiner(
                        label: 'Before sending',
                        content:
                            'Keep the assumptions identical for every lens. Do not add customer data, credentials, or private reasoning traces.',
                      ),
                      DSListItem.twoLiner(
                        label: 'Resolve model + effort',
                        content:
                            'Confirm an available subagent model and answer the skill\'s effort question. These settings do not select the app\'s model.',
                      ),
                      DSListItem.twoLiner(
                        label: 'If the demo is blocked',
                        content:
                            'Stop rather than silently substitute. Walk through the brief and expected return structure; do not present invented results as a run.',
                      ),
                    ],
                  ),
                ]),
                DsBulletList(
                  title: 'What to watch for in the live run',
                  bulletItems: [
                    BulletListItem(
                      title: 'Do the lenses find different trade-offs?',
                      text:
                          'Look for distinct options, not four copies of the same answer.',
                      iconData: DSIconAssets.group,
                    ),
                    BulletListItem(
                      title: 'Does anyone invent a benchmark?',
                      text:
                          'No measured latency or model capability was supplied; those claims need verification.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'What would change our decision?',
                      text:
                          'Choose one proposed check and name its baseline and pass criterion before running it.',
                      iconData: DSIconAssets.checkcircle,
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
            title: 'Start small',
            buttonLabel: 'Back to start',
            onPrimaryPressed: (context) => context.flutterDeck.goToSlide(1),
            content: (context) => _page(
              context,
              heading: 'Make the next decision evidence-backed.',
              subText:
                  'This week: capture one repeated task in SKILL.md, test it in a fresh conversation, and share it after the checklist passes.',
              children: [
                DsBulletList(
                  title: 'Take the workflow with you',
                  bulletItems: [
                    BulletListItem(
                      title: 'Frame one useful question',
                      text:
                          'State what decision you need and which constraints matter.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Choose the skill workflow',
                      text:
                          'Independent brainstorm or evidence-backed Gherkin documentation.',
                      iconData: DSIconAssets.pencil,
                    ),
                    BulletListItem(
                      title: 'Verify before recommending',
                      text:
                          'Check evidence, disagreements, and one discriminating test.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                    BulletListItem(
                      title: 'Report what remains',
                      text:
                          'Name assumptions, blockers, budget limits, and coverage gaps.',
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
  String buttonLabel = 'Next',
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
    answer: 'Give a reviewer its own role instructions',
    detail:
        'Define the reviewer\'s priorities and expected output, rather than a task recipe.',
    points: 30,
  ),
  (
    answer: 'Limit a planner to read-only tools',
    detail:
        'Configure which tools the role can use; this is tool selection, not workflow guidance.',
    points: 25,
  ),
  (
    answer: 'Configure a model for a specialist role',
    detail:
        'Set the custom agent\'s model where the selected VS Code harness supports it.',
    points: 20,
  ),
  (
    answer: 'Switch from planning to implementation',
    detail:
        'A handoff switches the active agent with conversation context and a prefilled next-step prompt.',
    points: 15,
  ),
  (
    answer: 'Delegate research and get a result back',
    detail:
        'A custom subagent performs delegated work; the parent continues with its result rather than switching roles.',
    points: 10,
  ),
];

const List<_FeudAnswer> _skillAnswers = [
  (
    answer: 'Teach a repeatable testing procedure',
    detail:
        'Package the task steps and expected results independently of the agent\'s role.',
    points: 30,
  ),
  (
    answer: 'Bundle a setup script and service templates',
    detail:
        'Distribute the workflow with supporting files referenced from SKILL.md.',
    points: 25,
  ),
  (
    answer: 'Make domain guidance discoverable on demand',
    detail:
        'Metadata helps match a task; instructions load when invoked. Relevance does not guarantee invocation.',
    points: 20,
  ),
  (
    answer: 'Share task knowledge across AI products',
    detail:
        'Use the Agent Skills standard with compatible products; check locations, dependencies, and optional features.',
    points: 15,
  ),
  (
    answer: 'Keep a deployment recipe manual-only',
    detail:
        'Set disable-model-invocation: true and invoke /skill-name yourself; this controls activation, not permissions.',
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
          'When to choose which in VS Code? Agents configure roles; skills supply task know-how. These are distinct reasons to choose, not exclusive capabilities. They can work together. Source: VS Code customization docs. Game points: 100 per board.',
      children: [
        const Text(
          'Two teams, one board each. Alternate guesses; the presenter reveals a matching answer or records a wrong guess. After three strikes, the other team gets one guess; settle any steal verbally. Reveal all to compare the choices.',
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
                      label: 'Answer ${index + 1}',
                      content: '?',
                      semanticHint: 'Reveal answer ${index + 1}',
                      onTap: () => setState(() => _revealed.add(index)),
                    ),
          ],
        ),
        SizedBox(height: spacing.s),
        Row(
          children: [
            DSButton.secondary(
              text: 'Wrong guess',
              size: DSButtonSize.small,
              width: DSButtonWidth.hug,
              leadingIcon: DSIconAssets.times,
              onPressed: _strikes < _maxStrikes && !allRevealed
                  ? () => setState(() => _strikes++)
                  : null,
            ),
            SizedBox(width: spacing.s),
            DSButton.tertiary(
              text: 'Reveal all',
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
                text: 'Strike',
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
            titleText: 'Three strikes!',
            bodyText: 'The other team gets one guess to steal the points.',
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
      'File structure and metadata are valid',
      'Use <name>/SKILL.md with valid YAML; in VS Code, name must match the folder.',
    ),
    (
      'Description says what and when',
      'Include specific capabilities and trigger contexts, not a vague summary.',
    ),
    (
      'Instructions are concise and actionable',
      'Give clear steps and decision points; remove explanations the model already knows.',
    ),
    (
      'Examples and success checks are concrete',
      'Show expected inputs and outputs; explain how to validate results and fix failures.',
    ),
    (
      'Supporting resources are linked and usable',
      'Link files from SKILL.md; document dependencies and whether scripts should be read or run.',
    ),
    (
      'Safety and permissions are reviewed',
      'Audit bundled code and external sources; document risky actions and required approvals.',
    ),
    (
      'Discovery and results are tested',
      'Try relevant and unrelated prompts, real tasks, and intended models; compare with a no-skill baseline.',
    ),
  ];

  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    final spacing = context.theme.spacings;
    final done = _checked.length == _items.length;

    return _page(
      context,
      heading: 'Is your skill ready?',
      subText: 'Run through this list before you share a skill with your team.',
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
                  titleText: 'Ready to share',
                  bodyText:
                      'Authoring checks are complete. Share the skill and improve it with team feedback.',
                )
              : DSNotification(
                  type: DSNotificationType.informative,
                  titleText: '${_checked.length} of ${_items.length} checked',
                  bodyText:
                      'Review the skill itself before sharing it, not just the result of one run.',
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
    header: const DSFocusOverlayHeader(title: 'Skills for AI agents'),
    // Mirrors DSLinearProgressBar without its restart-from-zero animation.
    progressBar: LinearProgressIndicator(
      value: progress,
      semanticsLabel: 'Presentation progress',
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
