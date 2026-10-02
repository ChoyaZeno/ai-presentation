---
name: multi-agent-brainstorm
description: "Use when the user explicitly asks to brainstorm with multiple agents, compare independent technical approaches, or document an application's full user-facing functionality in Gherkin .feature files."
argument-hint: 'Describe the question to explore or app/repository to document, scope, requested agent count/model, and output location. The skill asks for an effort choice per run.'
user-invocable: true
---

# Multi-Agent Brainstorm

Use this workflow for broad questions where independent perspectives can uncover meaningfully different options. When the user asks to record an application's functionality, use the App Feature Documentation workflow below and create a coverage-backed set of Gherkin `.feature` files. The goal is either a small set of useful, testable choices or a verified description of the app's user-visible behavior, not a pile of agent responses.

## Guardrails

- Spawn agents only when the user explicitly asks for multiple agents, parallel brainstorming, or invokes this skill. Do not use this workflow for a simple question or a task with only one obvious owner.
- Respect the requested agent count. If none is specified, use four agents for a broad brainstorm; use fewer when the problem has fewer independent dimensions.
- Use read-only agents for research. The coordinating agent owns verification, follow-up experiments, and all edits; when the user requests app documentation, those edits are limited to the requested `.feature` files.
- For a request to cover the whole app, identify all in-scope first-party apps and meaningful variants. If the repository contains multiple products and the user's intended scope is materially unclear, ask before choosing one.
- Reuse the repository's existing `.feature` location and style. If none exists, put documentation under the repository-root `features/` directory. Preserve existing feature files and do not imply they are executable tests unless the repo has a configured Gherkin runner.
- Claim complete coverage only when every in-scope user-facing capability in the coverage inventory is represented by a feature or explicitly recorded as an evidence gap/out-of-scope item.
- If the user specifies a subagent model, use that exact model. Otherwise, use the main-thread model for every subagent when it is exposed; do not omit the model parameter and let the runner choose its default. If the main-thread model is not exposed, use `GPT-6 Luna (copilot)`, the previously user-approved brainstorm fallback, and proceed without asking the user to choose again. State when this fallback is being used; never describe it as the main-thread model. If the selected model is unavailable to the runner, explain the limitation and ask before substituting another model.
- On every skill invocation, after resolving the subagent model, ask the user which reasoning effort to request for this run. Do not reuse a prior effort choice without asking; effort options can differ by model. Use only effort levels exposed by the selected model or runner. If none are exposed, ask an open-ended question and offer `use model/runner default` rather than inventing supported levels.
- Apply the requested effort through a dedicated runner setting when one is exposed. If not, include the user's requested effort as prompt guidance and state that it is not a runtime-configured setting. In particular, the current `functions.runSubagent` interface exposes no effort parameter. Keep requested effort separate from actual configured effort. This question is about analysis depth, not a request for hidden chain-of-thought.
- Include the main/coordinating thread's model identifier and configured thinking-effort or reasoning-effort level in every agent prompt. Use only values exposed by the session or runner; write `not exposed` when unavailable rather than guessing. Keep these separate from the requested subagent model.
- Share concise task context, not hidden chain-of-thought or private reasoning traces. A short summary of the main thread's conclusions and evidence is appropriate when verified.
- A model selected for a subagent is only the brainstorm model. It does not imply that the user's application, local runtime, or API has access to that model.
- Never include credentials, tokens, private keys, or unnecessary personal data in agent prompts.

## Workflow

1. **Frame the question.** Identify the decision the user needs to make, any explicit success target, and the constraints that matter. Read only enough nearby code or documentation to give agents accurate context.
2. **Resolve model and effort.** Select the subagent model using the guardrail above. Then ask the user, on every invocation, which effort to request for that model. Use `vscode_askQuestions` when available. Show model-supported effort choices only when they are exposed; otherwise allow a free-form answer and `use model/runner default`. Do not infer subagent effort from the main thread's effort or a previous run.
3. **Separate the angles.** Give each agent a distinct, non-overlapping lens. For a model/tool-routing brainstorm, useful lenses are:
   - What can the current local model and scoring interface realistically do?
   - What hosted-model or provider integration is feasible, and what are its security and privacy costs?
   - What on-device alternatives fit the platforms, latency, and offline requirements?
   - What execution architecture safely validates, authorizes, and audits proposed tool calls?
4. **Prepare shared context.** Give every agent the same concise, verified facts, user goal, constraints, previous attempts and results, and unresolved questions. Include a metadata header for the main thread's model and configured thinking/reasoning effort; mark either value `not exposed` if it is unavailable. Record the requested subagent effort separately from any runner-configured effort. Keep assumptions explicitly labeled. Do not give agents one another's conclusions before their first response; independent first passes are more useful.
5. **Launch in parallel.** Use `multi_tool_use.parallel` to invoke the requested number of independent `functions.runSubagent` calls. Set each call's model to the user-specified model; if omitted, use the exposed main-thread model, or `GPT-6 Luna (copilot)` when the main-thread model is not exposed. Apply the selected effort through a runner setting if available; otherwise include it as prompt guidance and label it prompt-only. Give each call its assigned lens and the same response contract. If work cannot actually run in parallel, be clear about that limitation.
6. **Keep exploration bounded.** Ask agents not to edit files or claim unverified behavior. Have them return:
   - Ranked, viable options for their lens.
   - Evidence from the provided context versus assumptions or external claims.
   - Main failure modes, prerequisites, and material costs.
   - One minimal test or verification step, including what result would support or reject the option.
7. **Synthesize, do not vote.** Group duplicate ideas, surface disagreements and unique insights, and distinguish repository facts from hypotheses. Agent agreement is not proof. Verify consequential claims against the code, tests, or authoritative documentation before recommending them.
8. **Choose a discriminating next step.** If the user asked only for brainstorming, present the options and a recommended next check without editing. If they also asked to find or validate a solution, select the smallest experiment that distinguishes the leading hypotheses. State its baseline and pass criterion before running it.
9. **Continue and recover.** Treat “continue,” “keep going,” and “try more ways” as requests to resume the same goal and scope, not permission to expand them or the agreed budget. Keep a compact attempt ledger: approach, hypothesis, result or failure mode, and next predicted test. After a failed or inconclusive attempt, diagnose it and proceed only when there is a materially different, falsifiable recovery; do not repeat unchanged variants. Before long-running work, state the expected duration, progress signal or checkpoints, and bounded time/resource budget. Classify work as completed, progressing, stalled, failed, blocked, or incomplete. Mark it stalled only when a predeclared progress signal fails to advance at a checkpoint; missing output alone does not prove failure or success. Continue unfinished work only within that budget, ask before exceeding it or changing scope, and report its status, what remains incomplete, and the next step when stopping. Stop on success, a hard blocker, budget exhaustion, or when no remaining test is likely to change the decision.
10. **Evaluate honestly.** Use representative cases and, when tuning prompts or scoring rules, keep a held-out set that is not used to choose the configuration. Do not count repeated inputs under different prompt layouts as independent examples. Do not tune to a requested score by overfitting; report a miss and stop when the evidence does not support another meaningful iteration.
11. **Report concisely.** Lead with the recommendation or measured outcome. Summarize points of agreement, important disagreements, risks, and the next action. Record the main-thread model and configured effort separately from the subagent model, and report both the requested subagent effort and whether the runner actually configured it. Mark unavailable values `not exposed`. State what remains unverified and whether any code was changed.

## Prompt Pattern

Include this information in each independent agent prompt, tailoring the final section to its lens:

```text
Task: <decision or problem to explore>
Goal: <what a useful outcome looks like>
Main-thread model: <actual model identifier, or "not exposed">
Main-thread thinking/reasoning effort: <actual configured level, or "not exposed">
Subagent model: <exact user-specified identifier, exposed main-thread model when omitted, or "GPT-6 Luna (copilot)" fallback when the main-thread model is not exposed>
Subagent effort requested: <exact effort choice collected for this run>
Subagent effort configured: <actual runner-configured level, or "not exposed; requested effort is prompt-only">
Verified context: <relevant code paths, interfaces, runtime facts, and test results>
Constraints: <privacy, platforms, latency, offline behavior, compatibility, scope>
Prior attempts: <what was tried and measured; do not repeat without a new hypothesis>
Your lens: <one distinct area to investigate>
Return: ranked viable options; evidence versus assumptions; risks/prerequisites; one minimal falsifiable test and expected result.
Restrictions: read-only; do not edit. Do not claim behavior you could not verify. If no viable option is supported, say so.
```

## Example: Tool-Routing Brainstorm

For a four-agent exploration of model-selected tool routing, assign one agent to local-model capability and scoring, one to hosted tool-calling integration, one to on-device alternatives, and one to safe dispatch/validation architecture. Share measured routing results and clarify that choosing a model for the agents does not make it available to the application. After synthesis, test only a concrete leading hypothesis against a fixed baseline and unseen requests before recommending production routing.

## App Feature Documentation

Use this path when the user wants the app's functionality written down as feature files. Deliver the files, not only a proposed inventory or a summary.

1. **Set the app boundary.** Inspect the repository structure and project documentation to identify the app or apps, supported flavors, user roles, and platforms in scope. Ask a clarifying question only when multiple plausible scopes would produce materially different feature sets.
2. **Inventory observable behavior.** Trace entry points, routes, screens, user actions, domain workflows, state transitions, integrations, permissions, and meaningful success, alternate, and failure states. Use source, tests, and docs as evidence; do not treat a class or file name alone as proof of behavior. Focus on behavior an actor can observe, not internal implementation details.
3. **Build a coverage ledger.** Track each app area/capability, evidence paths, matching existing feature file or proposed file, and status (documented, uncertain, or out of scope). Use it to find gaps and partition the app into non-overlapping slices for agents.
4. **Resolve model and effort, then delegate slices.** Follow the model and effort guardrails above. Give each agent a distinct app area or end-to-end workflow, plus the same verified app context. For a broad app, use the requested agent count or four by default; use fewer when the codebase has fewer independent slices.
5. **Collect evidence-backed scenarios.** Ask agents to return concise Gherkin candidates for their slice, with source/test/doc paths supporting each behavior, important variants and error paths, and unresolved evidence gaps. Agents must not edit files, duplicate other slices, or invent expected behavior.
6. **Synthesize and write the files.** Reconcile overlapping scenarios and preserve genuine flavor, platform, role, and state differences. Create one or more clearly named `.feature` files grouped by functional area, following any repository convention. Write user-oriented `Feature`, optional `Rule`, and `Scenario`/`Scenario Outline` sections with meaningful `Given`, `When`, and `Then` behavior. Keep each scenario independently understandable and avoid implementation details in its steps. Include only evidence-supported behavior; leave uncertain behavior out of normative scenarios and report it as a gap.
7. **Check completeness and syntax.** Reconcile the files against the coverage ledger and app entry points, routes, capability modules, variants, and agent slices. Each in-scope capability must map to a scenario or have a clearly reported evidence gap. Run an existing Gherkin parser/linter if configured; otherwise check the Gherkin structure, duplicate scenarios, unresolved placeholders, and evidence for each claim manually. Do not install tooling or wire up test execution unless requested.
8. **Report the result.** List the created/updated feature files, summarize covered areas, identify evidence gaps or excluded scope, and state what validation ran. Do not call the result complete while any in-scope area is unmapped or materially uncertain.

### Feature Documentation Prompt Pattern

Include this information in each agent prompt and tailor the assigned slice:

```text
Task: Document user-visible behavior for app slice <area/workflow>
Goal: Produce concise, evidence-backed Gherkin candidates for the requested app scope
Main-thread model: <actual model identifier, or "not exposed">
Main-thread thinking/reasoning effort: <actual configured level, or "not exposed">
Subagent model: <exact selected identifier>
Subagent effort requested: <effort choice collected for this run>
Subagent effort configured: <actual runner-configured level, or "not exposed; requested effort is prompt-only">
Verified app context: <app boundaries, relevant routes/modules, existing docs/tests, known variants>
Assigned slice: <specific non-overlapping functional area>
Constraints: <platforms, roles, flavors, privacy, and scope>
Return: Gherkin Feature/Rule/Scenario blocks; an evidence map from each scenario to source/test/doc paths; meaningful alternate/error states; unresolved gaps.
Restrictions: read-only; do not edit files; do not infer behavior from names alone; do not invent unsupported outcomes; avoid duplicate scenarios and sensitive data.
```
