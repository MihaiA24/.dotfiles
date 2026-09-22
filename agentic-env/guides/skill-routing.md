# Choose a skill for the job

Use this guide to decide which skill a task needs, if any. It applies the routing policy in [Decisions §6](../DECISIONS_AI_TOOLING.md#6-skills) to day-to-day work. For host setup and the project verifier, follow [Start a new repo with the selected pstack skills](poteto-workflow.md) first. Several routes below assume that verifier exists.

Pick the one route that matches the task. The skills do not form a pipeline, so do not run the whole list as a ritual.

Explicitly invoke the skill in your prompt. Every pstack skill is manual-only, and so are Matt's `to-spec` and `to-tickets`. OMP hides manual skills from automatic discovery but still loads them by name. An invoked recipe can load the skills it names without a second request; reading a skill only to check discovery does not invoke it.

## Find the route

| Situation | Route |
|---|---|
| A small change you already understand | Implement it directly and exercise the affected path |
| A report you cannot restate yet | A plain-English restatement before any fix |
| How the current code works | `/how` |
| Why the code has its current shape | `/why`, scoped to one target and question |
| You need to understand and trust the agent's work | `/teach` |
| You are resuming earlier work in this workspace | `/recall` |
| Goals, constraints, or choices only a person can make | `/grilling` |
| An unknown that an experiment can measure | `/prototype`, with the verifier |
| A new interface that callers will use | `/technical-writing` and `/codebase-design` |
| A consequential doubt that evidence supports | `/interrogate` |
| A settled design that needs durable coordination | `/to-spec` or `/to-tickets` |
| Proof that a change works | The project verifier, on the affected paths |
| The verifier no longer matches the app | `/maintain-verification-skill`, on every mapped feature |

## Make small, understood changes directly

If you understand the change and it is small, skip every method in this guide. Implement it, then exercise the affected user path with the project verifier and show the evidence. A small fix needs no planning document, interview, or critique.

## Restate an ambiguous report before fixing it

If you cannot yet say what a report means, ask for understanding before implementation:

```text
Read this report and restate the underlying problem in plain English.
Separate observations from assumptions. Do not prescribe a fix yet.
```

## Use explanation skills only for their own questions

Each explanation skill answers one kind of question. Use the one that matches and stop there.

`/how` explains the current mechanism: what runs, where, and in what order.

```text
/how does [feature] handle [case]? Point to the relevant code and explain
it briefly. Do not change anything.
```

`/why` investigates why the code has its current shape. Its default is a broad evidence search, so give it one target, one question, and an explicit source scope for everyday use. The prompt below starts with Git history and project documents. It widens to other authorized sources only when those leave the question open. It is read-only, and it reports unsearched or unreachable evidence as coverage limits.

```text
/why does [module] [behavior]? Start with Git history and project documents.
Widen only to sources I have authorized, and list any evidence you could
not reach.
```

`/teach` explains engineering work so that you can understand and trust it. It uses `/how` and `/why` for the facts it needs. It states each claim with the confidence its evidence supports, and it separates what it read from what it infers. For a diagram, it uses a format the session can render, such as Mermaid or plain text, instead of assuming an image-generation tool. It does not change code, and it does not build a course or a learning workspace.

```text
/teach me why you implemented [change] this way and not [alternative].
What tradeoffs did you make, and which parts did you verify?
```

`/recall` rebuilds recent working context from this workspace's session history and the shared project record. Use it only when relevant earlier work exists. In a new project there is nothing to recall.

```text
/recall my work on [topic] in this repository over the last 7 days.
Check the current state before recommending the next action.
```

## Settle human goals with grilling

Use `/grilling` when goals, constraints, or tradeoffs depend on what a person wants. Answer those questions before the agent designs anything. Do not grill a question that an experiment can answer. Do not grill the same abstract plan again and again.

## Measure unknowns with a prototype

If the open question is measurable, such as how an interaction feels, how a state model behaves, or which layout is faster, build a prototype and measure it:

```text
/prototype the unresolved [interaction or state-model question].
Use /[verifier] where applicable to exercise the result and capture evidence.
Compare the alternatives against the question. Stop before production
implementation so I can choose.
```

## Design a new interface from the caller's side

For a new module or API that other code will call, write the caller's experience before the implementation:

```text
Use /technical-writing to draft a short tutorial showing how a caller
would use [module]. Apply /unslop. Use /codebase-design to assess the
interface and its tradeoffs. Stop before implementation.
```

## Reserve interrogate for consequential uncertainty

`/interrogate` has several models review one frozen snapshot of a change and returns a report. It costs more than an ordinary review. Use it when a mistake would be expensive to undo and specific evidence still leaves doubt. Name that evidence in the prompt. For routine review, use `code-review`. Do not interrogate an abstract plan.

## Plan durable work after the design settles

Use `/to-spec` or `/to-tickets` only after the design is settled, and only when the work must be coordinated across sessions or people. In each slice, require a live verification action and the observable result that proves it. Both skills end with a publish step. Approve publication separately, and do not let the agent publish what you did not ask for.

```text
/to-tickets for the settled [design]. In each ticket, name the /[verifier]
action and the observable result that proves it. Show me the tickets and
do not publish them until I approve.
```

## Verify affected paths, and maintain the whole map separately

For an ordinary change, use the project verifier on the paths the change affects. Do not run full maintenance for every change.

Maintenance is a separate, explicit job. `/maintain-verification-skill` checks the feature map against the source, exercises every mapped feature, fixes verifier drift, and reports product regressions separately. The prompt is in [Keep the verifier useful](poteto-workflow.md#7-keep-the-verifier-useful).

## Methods this stack does not include

`/poteto-mode`, `/architect`, and `/swarm` appear in Lauren Tan's articles but are excluded from this stack, so they are not available. Where an article uses `/poteto-mode` for planning, use the routes in this guide instead. Local subagents do not replace `swarm` coverage.
