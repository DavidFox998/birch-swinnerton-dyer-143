/-
================================================================
Towers / BSD / BSD_HasseEndDeg_CLOSED  (genesis-759)

**Endomorphism-Degree Route to BSD_HasseFull_143_OPEN**

Wires BSD_HasseBridge_CLOSED (genesis-734, previously orphaned) into
the main tower and proves the structural combinator:

  BSD_EndomorphismDegree_OPEN → BSD_HasseFull_143_OPEN

using the already-proved §V.5 algebraic bridge from BSD_Frobenius_Certificate.

### New definitions (0 sorry, classical trio)

| Name | Type | Role |
|------|------|------|
| `BSD_EndomorphismDegree_OPEN` | `∀ p prime good, BSD_FrobeniusDegreeNonneg_OPEN p` | Named surface (Silverman §III.6+§V.5) |
| `BSD_HasseViaEndDeg` | `BSD_EndomorphismDegree_OPEN → BSD_HasseFull_143_OPEN` | Structural combinator (PROVED) |
| `BSD_EndomorphismDegree_Partial_CLOSED` | 4-prime conjunction | Partial evidence (PROVED) |
| `BSD_Hasse_OPEN_partial_CLOSED` | Hasse for {2,3,5,7} | Partial evidence (PROVED) |

### What the §V.5 chain looks like end-to-end

  BSD_EndomorphismDegree_OPEN
    (∀ p good, ∀ r:ℝ, r²−a_p(p)·r+p ≥ 0)
     ↓  BSD_hasse_of_degree_nonneg  (BSD_Frobenius_Certificate, 0 sorry)
  BSD_HasseFull_143_OPEN
    (∀ p good, |a_p p : ℝ| ≤ 2·√p)
     ↓  Modularity_143_CLOSED_1gate  (BSD_Multiplicativity_Closed, 0 sorry)
  Modularity_143_OPEN
     ↓  BSD_TwoGateCombinator  (genesis-757, 0 sorry)
  BSD conclusion bundle

### Wiring note

BSD_HasseBridge_CLOSED.lean (genesis-734) proves BSD_FrobeniusDegreeNonneg_OPEN p
and BSD_Hasse_OPEN p for p ∈ {2,3,5,7} via:
  decide (card count) → omega (a_p value) → nlinarith (completed square) →
  BSD_hasse_of_degree_nonneg.
This file is the first to import BSD_HasseBridge_CLOSED in the main chain.
BSD_EndomorphismDegree_Partial_CLOSED and BSD_Hasse_OPEN_partial_CLOSED document
these 4 concrete witnesses — NOT a discharge of the universal statement.

### Genuine gap

BSD_EndomorphismDegree_OPEN (universal over ALL good primes) requires:
  1. deg(r·1 − π_p) = r² − a_p·r + p  (Silverman AEC §III.6 degree formula)
  2. Positivity of deg on End(E) ⊗_ℤ ℝ  (Rosati involution; §V.5)
Neither is in Mathlib v4.12.0.  For p ∈ {2,3,5,7}: proved directly.
For all other good primes: OPEN.

SORRY: 0.  Axiom footprint: classical trio.  NOT a brick.  BSD: OPEN.
================================================================
-/

import Towers.BSD.BSD_HasseBridge_CLOSED

open NumberField NumberField.InfinitePlace Real
open Towers.BSD

-- ============================================================
-- §1.  BSD_EndomorphismDegree_OPEN — named surface
-- ============================================================

/-- **`BSD_EndomorphismDegree_OPEN`** — GENUINE GAP (Silverman AEC §III.6 + §V.5).

    The degree quadratic form on End(E_{143a1}) ⊗_ℤ ℝ is non-negative at every
    real point: for every prime p of good reduction (p ∤ 143),

      ∀ r : ℝ,  r² − (a_p p : ℝ) · r + (p : ℝ) ≥ 0.

    This is the uniform version of `BSD_FrobeniusDegreeNonneg_OPEN` (per prime;
    BSD_Frobenius_Certificate.lean).  The algebraic consequence
    `BSD_hasse_of_degree_nonneg` converts it to `BSD_Hasse_OPEN p` per prime,
    and `BSD_HasseViaEndDeg` (below) assembles the universal statement.

    Mathematical justification:
    Weil's proof (Silverman AEC §V.5) shows deg(m·1 + n·π_p) ≥ 0 for all m,n ∈ ℤ
    where π_p is the Frobenius endomorphism.  This extends to ℝ via continuity of
    the degree function on End(E) ⊗_ℤ ℝ (positive semidefinite quadratic form
    via Rosati involution positivity).  Setting m = r, n = −1 and taking r ∈ ℝ gives
    the surface as stated.

    Gaps requiring Mathlib API absent from v4.12.0:
    1. The degree formula: deg(r·1 − π_p) = r² − a_p·r + p  (§III.6 degree theory).
    2. Real extension of deg to End(E) ⊗_ℤ ℝ (Rosati involution positivity; §V.5).

    PARTIAL EVIDENCE (0 sorry, classical trio):
    BSD_DegreeNonneg_p2 / p3 / p5 / p7 in BSD_HasseBridge_CLOSED.lean prove
    BSD_FrobeniusDegreeNonneg_OPEN p for p ∈ {2, 3, 5, 7} unconditionally.
    These are instances of this surface — NOT a discharge of the universal statement.

    NOT an axiom.  NOT sorry.  Named def-Prop.  BSD: OPEN. -/
def BSD_EndomorphismDegree_OPEN : Prop :=
  ∀ (p : ℕ) [Fact p.Prime], ¬(p ∣ 143) → BSD_FrobeniusDegreeNonneg_OPEN p

-- ============================================================
-- §2.  BSD_HasseViaEndDeg — structural combinator (PROVED)
-- ============================================================

/-- **`BSD_HasseViaEndDeg`** (0 sorry, classical trio) — PROVED.

    `BSD_EndomorphismDegree_OPEN → BSD_HasseFull_143_OPEN`.

    Proof: for each prime p of good reduction, apply `BSD_hasse_of_degree_nonneg`
    (BSD_Frobenius_Certificate.lean, 0 sorry, trio) to `h p hn`, which provides
    `BSD_FrobeniusDegreeNonneg_OPEN p`.  The §V.5 algebraic bridge
    (`BSD_weil_discriminant_step`) is already proved unconditionally:
    if the quadratic r ↦ r² − c·r + p is everywhere non-negative, its discriminant
    satisfies c² ≤ 4p, hence |c| ≤ 2√p.

    This is the main theorem of this file: it makes the §V.5 chain
    fully explicit inside the BSD tower.  The only remaining gap is the
    geometric input: `BSD_EndomorphismDegree_OPEN` itself.

    Chain:
      BSD_EndomorphismDegree_OPEN
        → (BSD_hasse_of_degree_nonneg, per prime p)
      BSD_Hasse_OPEN p
        for all p prime, p ∤ 143
        = BSD_HasseFull_143_OPEN  (by definition) -/
theorem BSD_HasseViaEndDeg
    (h : BSD_EndomorphismDegree_OPEN) :
    BSD_HasseFull_143_OPEN :=
  fun p _hp hn => BSD_hasse_of_degree_nonneg p (h p hn)

-- ============================================================
-- §3.  Concrete witnesses — 4 primes proved (newly wired in)
-- ============================================================

/-- **`BSD_EndomorphismDegree_Partial_CLOSED`** (0 sorry, classical trio) — PROVED.

    BSD_FrobeniusDegreeNonneg_OPEN holds for p ∈ {2, 3, 5, 7}.
    Proved in BSD_HasseBridge_CLOSED.lean (genesis-734) via:
      decide (E143_Finset p card) → omega (exact a_p value) →
      nlinarith (completed-square non-negativity argument).

    This provides 4 concrete witnesses for BSD_EndomorphismDegree_OPEN.
    NOT a discharge of the universal statement (which requires all good primes).
    First time these proofs appear in the main MasterCertification import chain. -/
theorem BSD_EndomorphismDegree_Partial_CLOSED :
    BSD_FrobeniusDegreeNonneg_OPEN 2 ∧
    BSD_FrobeniusDegreeNonneg_OPEN 3 ∧
    BSD_FrobeniusDegreeNonneg_OPEN 5 ∧
    BSD_FrobeniusDegreeNonneg_OPEN 7 :=
  ⟨BSD_DegreeNonneg_p2, BSD_DegreeNonneg_p3, BSD_DegreeNonneg_p5, BSD_DegreeNonneg_p7⟩

/-- **`BSD_Hasse_OPEN_partial_CLOSED`** (0 sorry, classical trio) — PROVED.

    BSD_Hasse_OPEN p holds unconditionally for p ∈ {2, 3, 5, 7}.
    Partial discharge of BSD_HasseFull_143_OPEN for these 4 primes.
    Proved in BSD_HasseBridge_CLOSED.lean (genesis-734) via BSD_hasse_of_degree_nonneg.

    Key point counts (by decide in BSD_HasseBridge_CLOSED):
      p=2: #E₁₄₃_affine(𝔽₂) = 2, a₂ = 0,  |0| ≤ 2√2  ✓
      p=3: #E₁₄₃_affine(𝔽₃) = 4, a₃ = −1, |−1| ≤ 2√3 ✓
      p=5: #E₁₄₃_affine(𝔽₅) = 6, a₅ = −1, |−1| ≤ 2√5 ✓
      p=7: #E₁₄₃_affine(𝔽₇) = 9, a₇ = −2, |−2| ≤ 2√7 ✓ -/
theorem BSD_Hasse_OPEN_partial_CLOSED :
    BSD_Hasse_OPEN 2 ∧ BSD_Hasse_OPEN 3 ∧ BSD_Hasse_OPEN 5 ∧ BSD_Hasse_OPEN 7 :=
  ⟨BSD_Hasse_OPEN_p2, BSD_Hasse_OPEN_p3, BSD_Hasse_OPEN_p5, BSD_Hasse_OPEN_p7⟩

-- ============================================================
-- §4.  Compatibility bridge witnesses — ap = a_p for {2,3,5,7}
-- ============================================================

/-- **`BSD_ApCompat_Partial_CLOSED`** (0 sorry, classical trio) — PROVED.

    The LMFDB trace table `E1859.ap` and the geometric count `a_p` agree
    for p ∈ {2, 3, 5, 7}.  Proved in BSD_HasseBridge_CLOSED.lean (genesis-734):
      E1859.ap p = literal value (by rfl on pattern match)
      a_p p = literal value (from BSD_ap_pN theorems)
      → agree by transitivity.

    For primes p > 7 in the trace table: `BSD_HasseCompatibility_OPEN`
    (BSD_Frobenius_Certificate.lean) remains open — bridging requires
    `(E143_Finset p).card = specific integer`, proved by `decide` which
    OOMs for p ≥ 83 (ZMod p × ZMod p has p² ≥ 6889 pairs). -/
theorem BSD_ApCompat_Partial_CLOSED :
    E1859.ap 2 = a_p 2 ∧
    E1859.ap 3 = a_p 3 ∧
    E1859.ap 5 = a_p 5 ∧
    E1859.ap 7 = a_p 7 :=
  ⟨BSD_ApCompat_p2, BSD_ApCompat_p3, BSD_ApCompat_p5, BSD_ApCompat_p7⟩

-- ============================================================
-- §5.  Gap sentinels
-- ============================================================

/-- Gap sentinel: BSD_EndomorphismDegree_OPEN is OPEN for all good primes. -/
theorem BSD_endeg_sentinel : BSD_EndomorphismDegree_OPEN → True := fun _ => trivial
