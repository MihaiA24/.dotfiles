---
name: apache-spark
description: Optimizes existing Apache Spark jobs using execution plans, completed-run telemetry, and controlled before/after measurements while preserving results. Use when reviewing Spark SQL, PySpark, Scala/DataFrame or RDD job performance, slow stages, skew, shuffle, spill, executor memory, Python UDF overhead, or excessive output files.
---

# Apache Spark: optimize existing jobs

Optimize an implemented job, not a hypothetical pipeline. Rank work by the user's latency, throughput, or cost objective; a faster stage is not necessarily a faster or cheaper application.

## 1. Establish the baseline

Read available code, job configuration, and execution artifacts before requesting missing evidence. Record:

- Exact Spark/runtime version, language/API, batch versus streaming, deployment mode, relevant connectors/table formats, and code revision.
- Entry point and production action/sink; input snapshot, bytes/rows, file layout, join-key distribution, output contract, and resource constraints.
- A representative application ID/attempt, SQL execution IDs when applicable, elapsed time, effective configuration, executor allocation, and available UI/history/event logs.
- The objective and acceptable correctness, latency, and cost boundaries. Separate queue/startup time from execution, without excluding them from an end-to-end objective.

Event logs exist only if enabled before the run; enabling them now cannot recover a past run. **Gate:** identify the representative run and evidence gaps. Without runtime evidence, deliver a code/plan-based hypothesis and an exact collection/rerun procedure; do not claim a measured bottleneck or gain.

## 2. Locate the critical path

Trace the production action through SQL execution → jobs → stages → task attempts. For RDD jobs, start from the action and stage DAG. Account for overlapping jobs, retries, speculation, executor loss, and changing allocation.

For each expensive critical-path stage/operator, relate task-duration distribution to input/shuffle bytes, records, spill, GC, fetch wait, and available concurrency. Inspect scan pruning, exchanges, join build side, sorts/windows, Python boundaries, and repeated computation. Compare initial and final AQE plans from the same execution; pre-action EXPLAIN is not the completed plan.

**Gate:** each ranked bottleneck has a run/stage/operator locator, supporting measurements, an alternative explanation, and confidence. Distinguish observed facts from hypotheses; aggregate task time is not application wall time.

## 3. Choose the smallest supported intervention

Prefer reducing unnecessary data and work before hints, configuration, or more hardware. Check the existing physical plan first: Catalyst or AQE may already perform the proposed optimization. Use the exact runtime's Apache documentation, and provider documentation for provider-specific features.

For each candidate, specify the code/config delta and its scope, causal hypothesis, expected plan/metric change, semantic risk, resource/cost tradeoff, and rollback. Each independent change is its own experiment with its own predicted metric, including dead-work removal; queue the rest instead of bundling them. Configure deployment settings at submission/startup, SQL settings in the relevant session, and persistent layout changes only with authorization. Derive every configuration value from a named measurement (partition bytes, built relation size, failed memory domain); when that measurement is missing, name it instead of proposing a number.

**Gate:** provide a ranked experiment plan; implement the leading candidate only when the request authorizes edits. An analysis-only request stops at the plan. Access to production does not authorize expensive reruns, catalog changes, compaction, destructive writes, or cluster-wide changes.

## 4. Prove correctness and improvement

Run the actual action/sink in an authorized isolated destination; a lazy transformation or substituted count does not prove the production path improved.

Check schema/types and row multiset equivalence, including duplicate and null behavior; test relevant join, aggregation, window, ordering, floating-point, and nondeterministic edge cases. Preserve sink mode, partition layout, checkpoint/state, and downstream contracts. Keep correctness-check execution outside timed runs.

Compare repeat runs on the same input snapshot, runtime, resources, relevant configuration, and cache policy. Report variability and both end-to-end time and resource/cost evidence. Verify the predicted physical-plan/metric change, not just elapsed time. Reject regressions or explain an explicitly accepted tradeoff; keep the prior revision/config as rollback.

**Gate:** mark the result `measured improvement`, `no improvement`, `regression`, or `unverified`. Without a real comparable rerun, deliver the reachable analysis/change and name the missing prerequisite; never invent speedup or savings.

## Deliverable

1. **Baseline:** job/run locator, objective, input/resources/runtime, and evidence coverage.
2. **Findings:** ranked `stage/operator | observation | cause/hypothesis | confidence` rows.
3. **Change:** exact delta, expected effect, semantic/resource risks, and rollback.
4. **Proof:** `metric | baseline | candidate | variability`; output checks and artifacts, or the exact missing evidence and next command/action.
5. **Decision:** keep/reject the candidate against the objective; identify the next experiment only if evidence warrants one.

## Example invocations

```text
/apache-spark Review jobs/daily_orders.py using the completed application in
artifacts/spark-run/. Rank causes of the 45-minute runtime; do not edit yet.
```

```text
/apache-spark Optimize this existing Scala job's skewed join. Use its event
log and final SQL plan, preserve duplicates/nulls, and compare isolated reruns
on the same snapshot and executor budget. Do not publish production output.
```
