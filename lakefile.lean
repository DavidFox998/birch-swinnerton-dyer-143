import Lake
open Lake DSL

package «classNumber-143» where
  -- Standalone Lean 4 proof that h(ℚ(√-143)) = 10.
  --
  -- SORRY: 0.  Axiom footprint: classical trio {propext, Classical.choice, Quot.sound}.
  -- 0 named gates (2026-06-23): h(K) = 10 proved unconditionally.
  -- BSD_BQF_ClassNumber_bridge CLOSED in BSD_BQF_Bridge_Closed.lean.
  -- MAIN THEOREM: classNumber K = 10  PROVED, classical trio.
  --
  -- DO NOT run `lake update` — Mathlib must remain pinned to v4.12.0.

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.12.0"

lean_lib ClassNumber143 where
  roots := #[`BSD]
