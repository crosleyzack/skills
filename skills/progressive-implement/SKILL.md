---
name: progressive-implement
description: "Implement a spec or tickets in gated passes: stubs first, then one function per pass, then tests."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.
Do the work in **passes**.
Each pass ends at a **gate**: report the pass, review it, then stop and wait for the user to approve.
Start the next pass only after the user approves.
If the user asks for changes, apply them, run the review again, and stop at the same gate.

## Pass 1: stubs

Write a **stub** for every function, method, and type the work needs.
Write all the stubs in this one pass.
Each stub has:

- The final signature.
- A doc comment that says what the function will do, its inputs, its outputs, and its error cases.
- A body that returns a "not implemented" error, or the zero value when the signature has no error.

List the stubs in **leaf-first** order: utility functions with no in-scope dependencies come first, and orchestration functions that call the others come last.
This list is the implementation plan for the passes that follow.
Put the list in the report.

Done when every stub exists and the project builds or typechecks.

## Passes 2 to N: one function per pass

Implement the next function in the leaf-first order.
Implement exactly one function per pass.
Keep every other stub as it is.

If the implementation shows that a signature, a doc comment, or the order is wrong, update the stub and the order, and say so in the report.

Done when the function matches its doc comment and the project builds or typechecks.

## Test pass

Start the test pass only after every stub has an implementation.
Write the tests for all functions in this one pass.
Give each function exactly one test.
Make each test table-driven: one table of cases, one loop that runs them.
Cover the success cases and each error case from the doc comment.

Done when every function has its test and the full test suite passes.

## Final review

After the user approves the test pass, use /code-review to review all the work.
Report its findings and stop at a last gate.

## Review

Run this review at the end of every pass, before the gate.
Look at the code from this pass and at the code from earlier passes that it touches.

- **Complexity**: flag functions that are long, nest deeply, or have many branches.
  For each flag, name a specific change that makes the function simpler.
- **Abstraction**: flag logic that now occurs in two or more places.
  Propose a shared helper only for a pattern that recurs.
  A single use is not a pattern.

Report findings only.
Apply a finding only after the user approves it at the gate.

## Report

At each gate, give:

1. **Pass**: the pass number and its name, for example "Pass 4: implement `parseHeader`".
2. **Changes**: the files and functions that changed, and one line on each.
3. **Plan changes**: changes to signatures, doc comments, or the leaf-first order, with the reason.
4. **Review**: the complexity and abstraction findings, or "none".
5. **Next**: the function that the next pass will implement, "test pass" after the last function, or "final review" after the test pass.
