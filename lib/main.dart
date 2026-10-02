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
              heading: 'Write skills your AI can actually use.',
              subText:
                  'A practical guide to agent files, SKILL.md, and getting discovery right.',
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
                      'A clear mental model, a SKILL.md template, and a checklist to ship your first skill this week.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/agenda',
            title: 'Agenda',
            content: (context) => _page(
              context,
              heading: 'What we will cover.',
              subText: 'From why skills matter to a skill you can ship.',
              children: [
                DSList(
                  children: [
                    for (final (index, item) in const [
                      ('Why skills?', DSIconAssets.notificationCirclequestion),
                      ('Pick the right file', DSIconAssets.layergroup),
                      ('How skills get loaded', DSIconAssets.download),
                      ('Anatomy of a skill', DSIconAssets.filesFile),
                      ('Writing the description', DSIconAssets.search),
                      ('Writing the body', DSIconAssets.pencil),
                      ('Bundled resources', DSIconAssets.briefcasemedical),
                      ('Mistakes and testing', DSIconAssets.checkcircle),
                      ('Game: Skill Feud', DSIconAssets.group),
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
              heading: 'Prompts get retyped. Skills get reused.',
              subText:
                  'A skill captures how your team does a task, so the agent does it the same way every time.',
              children: [
                _columns(context, [
                  DsBulletList(
                    title: 'Without a skill',
                    bulletItems: [
                      BulletListItem(
                        text: 'You re-explain the process in every chat.',
                        iconData: DSIconAssets.thumbDown,
                      ),
                      BulletListItem(
                        text: 'Results depend on who wrote the prompt.',
                        iconData: DSIconAssets.thumbDown,
                      ),
                      BulletListItem(
                        text: 'Know-how lives in one person\'s head.',
                        iconData: DSIconAssets.thumbDown,
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'With a skill',
                    bulletItems: [
                      BulletListItem(
                        text: 'The procedure is written once and versioned in git.',
                        iconData: DSIconAssets.thumbUp,
                      ),
                      BulletListItem(
                        text: 'Same steps, same quality, for everyone.',
                        iconData: DSIconAssets.thumbUp,
                      ),
                      BulletListItem(
                        text: 'Loaded only when relevant, so no wasted context.',
                        iconData: DSIconAssets.thumbUp,
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
              heading: 'Pick the right file for the job.',
              subText:
                  'Each customization file answers a different question. Choose by scope first.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'copilot-instructions.md / AGENTS.md',
                      'Repo-wide conventions the agent should always follow.',
                      'Always on',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      '.github/instructions/*.instructions.md',
                      'Rules for specific paths, targeted with a narrow applyTo glob.',
                      'By file path',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      '.github/agents/*.agent.md',
                      'A specialist persona with its own tools, model, and boundaries.',
                      'A role',
                      DSTagType.warning,
                    ),
                    _fileRow(
                      '.github/prompts/*.prompt.md',
                      'One reusable task you start yourself as a slash command.',
                      'A command',
                      DSTagType.neutral,
                    ),
                    _fileRow(
                      '.github/skills/<name>/SKILL.md',
                      'A capability with steps and helpers, loaded when the task matches.',
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
              heading: 'Skills load in three levels.',
              subText:
                  'Progressive disclosure keeps the context window lean until the skill is needed.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      '1. Metadata: name + description',
                      'Always visible to the agent. This is the only thing it uses to decide whether to open your skill.',
                      'Always loaded',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      '2. Body of SKILL.md',
                      'Read when a request matches the description. Holds the procedure and decision points.',
                      'On match',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      '3. Resources: scripts/, references/, assets/',
                      'Opened only when the body points to them, so they can be large.',
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
              heading: 'One folder, one SKILL.md, optional helpers.',
              subText: 'Example: a skill that drafts release notes.',
              children: [
                _columns(context, [
                  DSList(
                    children: const [
                      DSListItem(
                        subjectIcon: DSIconAssets.layergroup,
                        label: '.github/skills/release-notes/',
                        content: 'Folder',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesFile,
                        label: 'SKILL.md',
                        content: 'Required',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.calculator,
                        label: 'scripts/collect_commits.sh',
                        content: 'Optional',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.book,
                        label: 'references/changelog-style.md',
                        content: 'Optional',
                      ),
                      DSListItem(
                        subjectIcon: DSIconAssets.filesContract,
                        label: 'assets/template.md',
                        content: 'Optional',
                      ),
                    ],
                  ),
                  DsBulletList(
                    title: 'Rules that prevent silent failures',
                    bulletItems: [
                      BulletListItem(
                        text:
                            'name uses lowercase letters, digits, and hyphens, and matches the folder name.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text: 'description is required and stays under 1024 characters.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text: 'Keep SKILL.md under roughly 500 lines.',
                        iconData: DSIconAssets.check,
                      ),
                      BulletListItem(
                        text: 'Link helpers with relative paths from SKILL.md.',
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
              heading: 'Start with the frontmatter.',
              subText:
                  'The YAML header at the top of SKILL.md is what the agent sees first.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'name',
                      'release-notes',
                      'Required',
                      DSTagType.negative,
                    ),
                    _fileRow(
                      'description',
                      'Draft release notes from merged pull requests in our changelog style. '
                          'Use when the user asks for release notes, a changelog, or a summary of what shipped.',
                      'Required',
                      DSTagType.negative,
                    ),
                    _fileRow(
                      'argument-hint',
                      'version or date range, e.g. "v2.4.0" or "last two weeks"',
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
              heading: 'The description is the trigger.',
              subText:
                  'Write it for the model: say what the skill does and when to use it.',
              children: [
                _columns(context, [
                  const DSNotification(
                    type: DSNotificationType.error,
                    titleText: 'Too vague',
                    bodyText: '"Helps with documentation."',
                  ),
                  const DSNotification(
                    type: DSNotificationType.success,
                    titleText: 'Specific and triggerable',
                    bodyText:
                        '"Generate API reference pages from OpenAPI specs. Use when the user asks to document endpoints, '
                        'update API docs, or convert a Swagger file to Markdown."',
                  ),
                ]),
                DsBulletList(
                  title: 'Four habits of good descriptions',
                  bulletItems: [
                    BulletListItem(
                      title: 'Lead with the capability',
                      text: 'Start with a verb: generate, review, migrate, validate.',
                      iconData: DSIconAssets.pencil,
                    ),
                    BulletListItem(
                      title: 'Add "Use when ..."',
                      text: 'List the phrases people actually type.',
                      iconData: DSIconAssets.comment,
                    ),
                    BulletListItem(
                      title: 'Name concrete nouns',
                      text: 'File types, tools, frameworks, and domains help matching.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Lean towards triggering',
                      text: 'Under-triggering is the most common failure. Be explicit.',
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
              heading: 'Write the body like a runbook.',
              subText:
                  'Clear, ordered steps beat clever prose. Explain the why so the model can handle edge cases.',
              children: [
                DsBulletList(
                  bulletItems: [
                    BulletListItem(
                      title: 'Use imperative, numbered steps',
                      text: '"Collect merged PRs since the last tag. Group them by label."',
                      iconData: DSIconAssets.bullit,
                    ),
                    BulletListItem(
                      title: 'Explain the reasoning',
                      text: 'A short "because ..." generalises better than ALWAYS or NEVER in capitals.',
                      iconData: DSIconAssets.comment,
                    ),
                    BulletListItem(
                      title: 'Show one example',
                      text: 'An input and the expected output anchor the format.',
                      iconData: DSIconAssets.eye,
                    ),
                    BulletListItem(
                      title: 'Define done',
                      text: 'State the checks to run and what the final output looks like.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                    BulletListItem(
                      title: 'Keep it lean',
                      text: 'Move long detail into references/ and say when to read it.',
                      iconData: DSIconAssets.sliders,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _slide(
            route: '/resources',
            title: 'Bundled resources',
            content: (context) => _page(
              context,
              heading: 'Bundle helpers, load them on demand.',
              subText: 'Resources keep SKILL.md short and make results deterministic.',
              children: [
                DSList(
                  children: [
                    _fileRow(
                      'scripts/',
                      'Deterministic or repeated work: validation, conversion, data collection. Executed, not read.',
                      'Run',
                      DSTagType.positive,
                    ),
                    _fileRow(
                      'references/',
                      'Long docs, schemas, and API specs. Tell the agent when each file is worth reading.',
                      'Read',
                      DSTagType.informative,
                    ),
                    _fileRow(
                      'assets/',
                      'Templates, boilerplate, and sample files used in the output.',
                      'Copy',
                      DSTagType.neutral,
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.informative,
                  titleText: 'Rule of thumb',
                  bodyText:
                      'If the agent writes the same helper code twice, turn it into a script in the skill.',
                ),
              ],
            ),
          ),
          _slide(
            route: '/mistakes',
            title: 'Common mistakes',
            content: (context) => _page(
              context,
              heading: 'Common mistakes.',
              subText: 'Most broken skills fail in one of these four ways.',
              children: [
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Vague description',
                    bodyText:
                        'The skill never triggers, or it triggers for everything.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Name does not match the folder',
                    bodyText: 'Validation fails and the skill is never offered.',
                  ),
                ]),
                _columns(context, const [
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'One giant skill',
                    bodyText:
                        'Split by workflow. Each skill should do one job well.',
                  ),
                  DSNotification(
                    type: DSNotificationType.warning,
                    titleText: 'Rules disguised as a skill',
                    bodyText:
                        'Always-on conventions belong in instructions, not in a skill.',
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
              heading: 'Test a skill like you test code.',
              subText: 'A short loop catches most trigger and quality problems.',
              children: [
                DSList(
                  children: const [
                    DSListItem(
                      subjectIcon: DSIconAssets.pencil,
                      label: 'Write 3 to 5 realistic prompts, including near misses',
                      content: '01',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.comment,
                      label: 'Run each one in a fresh chat',
                      content: '02',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.eye,
                      label: 'Check: did it trigger, and did it follow the steps?',
                      content: '03',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.arrowRotateright,
                      label: 'Tighten the description or body, then repeat',
                      content: '04',
                    ),
                    DSListItem(
                      subjectIcon: DSIconAssets.group,
                      label: 'Commit it and share it with the team',
                      content: '05',
                    ),
                  ],
                ),
                const DSNotification(
                  type: DSNotificationType.success,
                  titleText: 'Test the negatives too',
                  bodyText:
                      'Prompts that should NOT trigger the skill are as valuable as prompts that should.',
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
              heading: 'Ship one skill this week.',
              subText:
                  'Pick a task you repeat, write the steps, and test the trigger.',
              children: [
                DsBulletList(
                  title: 'Your next steps',
                  bulletItems: [
                    BulletListItem(
                      title: 'Pick a repeated task',
                      text: 'Release notes, code review, migrations, or test scaffolding.',
                      iconData: DSIconAssets.search,
                    ),
                    BulletListItem(
                      title: 'Write SKILL.md',
                      text: 'Frontmatter first, then numbered steps and a definition of done.',
                      iconData: DSIconAssets.pencil,
                    ),
                    BulletListItem(
                      title: 'Test in a fresh chat',
                      text: 'Check both triggering and quality, then refine.',
                      iconData: DSIconAssets.checkcircle,
                    ),
                    BulletListItem(
                      title: 'Share it',
                      text: 'Commit it to .github/skills/ so the whole team benefits.',
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
    answer: 'Defines a specialist persona',
    detail: 'A focused role such as reviewer, planner, or tester.',
    points: 32,
  ),
  (
    answer: 'Restricts which tools it can use',
    detail: 'The tools list keeps the agent safe and on task.',
    points: 24,
  ),
  (
    answer: 'You pick it yourself',
    detail: 'Chosen from the agent picker, or called as a subagent.',
    points: 18,
  ),
  (
    answer: 'Lives in .github/agents/',
    detail: 'Saved as <name>.agent.md.',
    points: 14,
  ),
  (
    answer: 'Can hand off to other agents',
    detail: 'Handoffs chain roles, e.g. plan then implement.',
    points: 12,
  ),
];

const List<_FeudAnswer> _skillAnswers = [
  (
    answer: 'Loaded on demand',
    detail: 'Only when the request matches the description.',
    points: 35,
  ),
  (
    answer: 'A folder with SKILL.md',
    detail: 'Plus optional scripts/, references/, and assets/.',
    points: 25,
  ),
  (
    answer: 'Description says what and when',
    detail: 'The description is the trigger.',
    points: 20,
  ),
  (
    answer: 'Name matches the folder',
    detail: 'Lowercase with hyphens, or it will not load.',
    points: 12,
  ),
  (
    answer: 'Portable across agents',
    detail: 'Follows the open Agent Skills format.',
    points: 8,
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
          'We asked 100 developers to name a characteristic of each file. Guess the top answers, then tap to reveal.',
      children: [
        _columns(context, const [
          _FeudBoard(title: 'Agent file (.agent.md)', answers: _agentAnswers),
          _FeudBoard(title: 'Skill file (SKILL.md)', answers: _skillAnswers),
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

  int get _score => _revealed.fold(
    0,
    (total, index) => total + widget.answers[index].points,
  );

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
    ('Folder name matches the name field', 'Lowercase letters, digits, and hyphens.'),
    ('Description says what and when', 'Includes the phrases people actually type.'),
    ('Steps are imperative and ordered', 'Each step explains why when it matters.'),
    ('Done is defined', 'Checks to run and the expected output.'),
    ('SKILL.md stays lean', 'Long detail lives in references/.'),
    ('Helpers are linked relatively', 'scripts/, references/, assets/ are referenced from the body.'),
    ('Tested in a fresh chat', 'Including prompts that should not trigger it.'),
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
                  titleText: 'Ready to ship',
                  bodyText: 'Commit it to .github/skills/ and tell your team.',
                )
              : DSNotification(
                  type: DSNotificationType.informative,
                  titleText: '${_checked.length} of ${_items.length} checked',
                  bodyText: 'Tick every item before you share the skill.',
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
