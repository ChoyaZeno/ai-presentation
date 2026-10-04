---
name: multi-agent-brainstorm
description: "Use when the user invokes this skill with a task for multi-agent coordination, or explicitly asks for parallel agent research, analysis, brainstorming, comparison, documentation, or implementation. The prompt after the slash defines the task and deliverable; BDD feature documentation is one example, not the skill's sole purpose."
argument-hint: 'Describe the task, desired outcome, scope and constraints, output location, and optional agent count or model.'
user-invocable: true
---

# Multi-Agent Task Coordination

Treat the prompt following `/multi-agent-brainstorm` as the task specification. It defines the requested work, outcome, scope, constraints, acceptance criteria, and output format or location. This skill provides a way to coordinate independent agent work; it does not impose a domain or deliverable. Follow the prompt as written: BDD feature documentation is supported when requested, but it is not the default.

## Guardrails

- Use agents when the user explicitly requests them or invokes this skill, but do not force delegation for a simple task or one with no meaningful independent workstreams.
- Respect the requested agent count. If none is specified, choose the smallest number that covers the independent parts of the task; do not default to four when fewer will do.
- Give each agent a distinct, bounded assignment derived from the user's prompt. Tailor the roles to the task instead of reusing fixed brainstorm lenses.
- Keep investigation read-only by default. If the user requests implementation or authored deliverables, agents may edit only when their file or output ownership is disjoint. The coordinating agent integrates changes and owns final verification.
- Preserve the user's scope, constraints, output format, and requested location. Follow repository conventions and do not overwrite existing work unnecessarily.
- For full-app behavior documentation, identify all in-scope first-party apps and meaningful variants. If multiple products exist and the intended scope materially changes the result, ask before choosing one.
- Claim complete documentation coverage only when every in-scope capability is represented or explicitly recorded as an evidence gap or out-of-scope item.
- If the user specifies a subagent model, use that exact model. Otherwise, use the main-thread model for every subagent when it is exposed; do not omit the model parameter and let the runner choose its default. If the main-thread model is not exposed, use `GPT-6 Luna (copilot)` as the subagent fallback. State when this fallback is being used; never describe it as the main-thread model. If the selected model is unavailable to the runner, explain the limitation and ask before substituting another model.
- On every skill invocation, after resolving the subagent model, ask the user which reasoning effort to request for this run. Do not reuse a prior effort choice without asking; effort options can differ by model. Use only effort levels exposed by the selected model or runner. If none are exposed, ask an open-ended question and offer `use model/runner default` rather than inventing supported levels.
- Apply the requested effort through a dedicated runner setting when one is exposed. If not, include the user's requested effort as prompt guidance and state that it is not a runtime-configured setting. In particular, the current `functions.runSubagent` interface exposes no effort parameter. Keep requested effort separate from actual configured effort. This question is about analysis depth, not a request for hidden chain-of-thought.
- Include the main/coordinating thread's model identifier and configured thinking-effort or reasoning-effort level in every agent prompt. Use only values exposed by the session or runner; write `not exposed` when unavailable rather than guessing. Keep these separate from the requested subagent model.
- Share concise task context, not hidden chain-of-thought or private reasoning traces. A short summary of the main thread's conclusions and evidence is appropriate when verified.
- A model selected for a subagent applies only to that agent's execution. It does not imply that the user's application, local runtime, or API has access to that model.
- Never include credentials, tokens, private keys, or unnecessary personal data in agent prompts.

## Workflow

1. **Parse the task.** Extract the requested outcome, deliverable, scope, constraints, acceptance criteria, and output format or location from the user's prompt. Ask only when missing information would materially change what to do.
2. **Choose whether to delegate.** Identify which parts benefit from independent work. If there are no useful parallel workstreams, handle the task directly instead of splitting it artificially.
3. **Design workstreams.** Assign each agent a non-overlapping area, question, or deliverable that fits the task. Give different agents distinct perspectives only when those perspectives are useful for the requested outcome.
4. **Resolve model and effort.** Select the subagent model using the guardrail above. Then ask the user, on every invocation, which effort to request for that model. Use `vscode_askQuestions` when available. Show model-supported effort choices only when they are exposed; otherwise allow a free-form answer and `use model/runner default`. Do not infer subagent effort from the main thread's effort or a previous run.
5. **Prepare shared context.** Give every agent the same concise, verified task facts, constraints, relevant prior attempts, and unresolved questions. Include the main thread's model and configured thinking/reasoning effort; mark unavailable values `not exposed`. Record requested subagent effort separately from runner-configured effort. Label assumptions, and keep independent first passes free of other agents' conclusions.
6. **Launch in parallel.** Use `multi_tool_use.parallel` for independent `functions.runSubagent` calls. Set each model as specified by the guardrails. Apply effort through a runner setting when available; otherwise label it prompt-only. Give each agent its specific assignment and a task-appropriate response contract. State if work cannot actually run in parallel.
7. **Bound and collect the work.** Request the deliverable relevant to each assignment, with evidence, assumptions, risks, prerequisites, and unresolved gaps. For research, keep agents read-only. For requested implementation, allow only clearly separated edits and require changed paths plus checks performed. Do not claim unverified behavior.
8. **Synthesize and complete the task.** Reconcile overlaps and disagreements; agent agreement is not proof. Verify consequential claims against code, tests, documentation, or authoritative sources. The coordinating agent owns the combined result, requested follow-up work, and final edits unless disjoint implementation work was explicitly delegated.
9. **Validate against the prompt.** Use checks that match the requested deliverable: verify evidence for research and documentation, check requested coverage for full-scope work, and run focused tests or other relevant checks for code changes. Do not invent extra acceptance criteria.
10. **Continue and recover.** Treat “continue,” “keep going,” and “try more ways” as requests to resume the same goal and scope. Keep a compact attempt ledger; after a failed or inconclusive attempt, proceed only with a materially different hypothesis. For long-running work, set a progress signal and bounded budget. Stop on success, a hard blocker, or budget exhaustion; ask before expanding scope or budget, and report incomplete work clearly.
11. **Report concisely.** Lead with the requested outcome. Summarize important findings, created or changed outputs, validation performed, and what remains unverified. Report model and effort details separately when agents were used.

## Prompt Pattern

Include this information in each independent agent prompt, tailoring the assignment and expected output to the user's task:

```text
Task: <specific subtask derived from the user's prompt>
Overall task: <requested outcome and acceptance criteria>
Main-thread model: <actual model identifier, or "not exposed">
Main-thread thinking/reasoning effort: <actual configured level, or "not exposed">
Subagent model: <exact user-specified identifier, exposed main-thread model when omitted, or "GPT-6 Luna (copilot)" fallback when the main-thread model is not exposed>
Subagent effort requested: <exact effort choice collected for this run>
Subagent effort configured: <actual runner-configured level, or "not exposed; requested effort is prompt-only">
Verified context: <relevant facts, evidence paths, prior results, and known gaps>
Constraints: <scope, privacy, compatibility, output format/location, and other user requirements>
Assigned workstream: <bounded area, question, or deliverable>
Return: <task-specific result, supporting evidence, assumptions, risks, and validation or open questions>
Restrictions: <read-only unless edits were explicitly assigned; do not exceed scope or claim unverified behavior>
```

## Task-Specific Guidance

- **Research or comparison:** assign independent areas or approaches; request evidence, tradeoffs, risks, and a recommended next check.
- **Implementation:** split only work that can be owned independently. Avoid concurrent edits to the same files; integrate changes and run focused checks.
- **Documentation:** follow the requested audience, format, scope, and destination. Ground behavioral claims in evidence and report gaps.

### Optional Example: App Feature Documentation

Use this specialized path only when the prompt requests behavior documentation, especially whole-app Gherkin files:

1. Identify the in-scope apps, roles, platforms, and variants. Clarify only when ambiguity materially changes coverage.
2. Inventory observable user behavior from source, tests, and docs. Do not infer behavior from names or document internal implementation details as user behavior.
3. Partition the inventory into non-overlapping areas. Ask agents for evidence-backed scenarios and gaps, not unsupported expectations.
4. Write user-oriented `.feature` files in the requested or existing repository location. Preserve existing files and do not imply scenarios are executable tests unless a Gherkin runner is configured.
5. Map in-scope capabilities to scenarios or explicit evidence gaps. Run an existing parser or linter when configured; otherwise check structure and evidence manually. Do not install tooling unless requested.
