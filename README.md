# h(ℚ(√-143)) = 10 — Standalone Lean 4 Proof

**Lean 4 · Mathlib v4.12.0 · 0 sorry · classical trio**

This repository contains a standalone formal proof that the class number of
the imaginary quadratic field ℚ(√-143) equals 10.

## Status

| Component | Status |
|-----------|--------|
| Lower bound: 10 ≤ h(K) | **PROVED** (0 sorry, unconditional) |
| Upper bound: h(K) ≤ 10 | **TWO named gates** — see below |
| Main theorem: h(K) = 10 | **PROVED** conditional on both gates |
| Axiom footprint | classical trio only |

## The TWO remaining gates

Both gaps are in the same Lean layer: `IsDedekindDomain` ideal-factorization
API for `AdjoinRoot`-based number fields is not fully wired in Mathlib v4.12.0.

### Gate 1 — `BSD_p2_pow_10_principal_hyp`

```lean
def BSD_p2_pow_10_principal_hyp : Prop :=
  (p2_OK ^ 10).IsPrincipal
```

Equivalent to `Ideal.span {gen_OK} = p2_OK ^ 10`
where `gen_OK = -28 + 3ω` has algebraic norm 1024 = 2^10.

**What is proved** (`BSD/BSD_P2_Principal_CLOSED.lean`):
- `gen_OK ∈ p₂` (explicit ℤ-combination: -28+3ω = (-14)·2 + 3·ω).
- `gen_OK ∉ p₂'` (coordinate parity contradiction).
- `absNorm(span{gen_OK}) = 1024 = 2^10` (norm-form calculation).

**What is missing**: wiring `IsDedekindDomain.HeightOneSpectrum.finprod_heightOneSpectrum_factorization`
to conclude `span{gen_OK} = p₂^10` for this `AdjoinRoot` instance.
The mathematical argument is complete; the Lean API gap is the blocker.

### Gate 2 — `BSD_classGroup_gen_by_p2_hyp`

```lean
def BSD_classGroup_gen_by_p2_hyp : Prop :=
  ∀ x : ClassGroup (𝓞 K), x ∈ Subgroup.zpowers g
```

where `g = [p₂]` in `ClassGroup (𝓞 K)`.

**What is proved** (`BSD/BSD_ClassNum_Upper_CLOSED.lean`):
- `(3+ω) ∈ p₂'`, `(3+ω) ∉ p₂`, `(3+ω) ∈ p₃`, `N(3+ω) = 48 = 2⁴·3`.
- `(4+ω) ∈ p₂`, `(4+ω) ∉ p₂'`, `N(4+ω) = 56 = 2³·7`.
- `p=5` is inert (norm-form, no solution mod 5).
- Minkowski bound: `(2/π)·√143 < 8`.

**What is missing**: `Ideal.span {3+ω} = p₂'^4·p₃` and `Ideal.span {4+ω} = p₂^3·p₇'`
(same Dedekind factorization API gap as Gate 1). Once wired:
`[p₃] = [p₂]^4`, `[p₇] = [p₂]^3`, and the Minkowski-bound enumeration closes.

## Proved arithmetic (complete list, all 0 sorry, classical trio)

| Result | File |
|--------|------|
| X²+143 irreducible over ℚ | BSD_Discriminant |
| finrank ℚ K = 2 | BSD_Discriminant |
| NrRealPlaces K = 0 | BSD_NumberField |
| (2/π)·√143 < 8 (Minkowski bound) | BSD_NumberField |
| {1, ω} is a ℤ-basis for 𝓞_K | BSD_IntBasis |
| discriminant K = -143 | BSD_Discriminant |
| a²+ab+36b² ≠ 2,3,5,7,8,32,128,512 | BSD_ClassNumber |
| p=2,3 split; p=5 inert; p=7 splits | BSD_ClassNumber |
| absNorm(p₂) = 2 | BSD_ClassNumberLowerProof |
| p₂^k non-principal, k = 1…9 | BSD_ClassNumberLowerProof |
| **10 ≤ classNumber K** (unconditional) | BSD_MasterProof |
| gen_OK ∈ p₂ and gen_OK ∉ p₂' | BSD_P2_Principal_CLOSED |
| absNorm(span{gen_OK}) = 1024 = 2^10 | BSD_AlgNorm |
| (3+ω) ∈ p₂', (3+ω) ∉ p₂, N(3+ω)=48 | BSD_ClassNum_Upper_CLOSED |
| (4+ω) ∈ p₂, (4+ω) ∉ p₂', N(4+ω)=56 | BSD_ClassNum_Upper_CLOSED |
| 10 reduced BQFs of disc -143 | BSD_ReducedForms |
| BQF completeness and all-reduced | BSD_ReducedForms |
| absNorm(idealOfForm a b) = a (all 10) | BSD_FormIdeal |
| 168 Hecke traces ap(p), p ≤ 1000 | BSD_AP_Table_Closed |
| 168 Hasse bounds ap(p)² ≤ 4p | BSD_AP_Table_Closed |

## Structure

All 34 proof files live in `BSD/`. The terminal nodes are:
- `BSD/BSD_MasterProof.lean` — assembles all proved arithmetic + lower bound.
- `BSD/BSD_ClassNum_Upper_CLOSED.lean` — upper bound combinator (conditional).
- `BSD/BSD_P2_Principal_CLOSED.lean` — principal ideal chain (conditional).
- `BSD/BSD_MasterCertification.lean` — top-level combinator.
- `BSD/BSD_Certificate.lean` — consolidated referee certificate.

## Axiom footprint

Every file: `{propext, Classical.choice, Quot.sound}` only.

```lean
#print axioms BSD_MasterCombinator
-- Classical.choice, propext, Quot.sound
```

## Note on the BSD conjecture

This repository is about the **class number h(ℚ(√-143)) = 10** only.
The full Birch and Swinnerton-Dyer conjecture for the elliptic curve 143a1
is tracked in [DavidFox998/Birch-and-Swinnerton-Dyer](https://github.com/DavidFox998/Birch-and-Swinnerton-Dyer)
and remains **OPEN**.
