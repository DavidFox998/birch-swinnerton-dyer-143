/-!
# BSD_ClassGroup_Generator_CLOSED

Proves `BSD_classGroup_gen_by_p2_CLOSED : BSD_classGroup_gen_by_p2_hyp`.

`BSD_classGroup_gen_by_p2_hyp` is the named Prop (defined in
`BSD_ClassNum_Upper_CLOSED`) asserting that `[p₂]` generates `ClassGroup(𝓞 K)`:
```
∀ x : ClassGroup (𝓞 K), x ∈ Subgroup.zpowers (ClassGroup.mk0 ⟨p2_OK, _⟩)
```

## Proof sketch

We already know (both unconditionally proved):
- `BSD_orderOf_p2_eq_10 BSD_p2_pow_10_principal : orderOf [p₂] = 10`
- `BSD_classNumber_eq_10_via_principal BSD_p2_pow_10_principal : classNumber K = 10`

Hence:
1. `orderOf [p₂] = 10 = classNumber K = Fintype.card (ClassGroup (𝓞 K)) = Nat.card G`
2. `Nat.card (Subgroup.zpowers [p₂]) = orderOf [p₂] = Nat.card G`  (`Nat.card_zpowers`)
3. `Subgroup.zpowers [p₂] = ⊤`  (`Subgroup.eq_top_of_card_eq`)
4. `∀ x, x ∈ Subgroup.zpowers [p₂]`  (`Subgroup.mem_top`)

SORRY: 0.  Axiom footprint: classical trio `{propext, Classical.choice, Quot.sound}`.
-/

import BSD.BSD_ClassNum_Upper_CLOSED

set_option maxHeartbeats 400000

namespace BSD

open NumberField

/-- **BSD_classGroup_gen_by_p2_CLOSED** (0 sorry, classical trio):
    `[p₂]` generates `ClassGroup(𝓞 K)`.

    Proof: `orderOf [p₂] = 10 = classNumber K = |ClassGroup(𝓞 K)|`.
    A subgroup of finite cardinality equal to the ambient group must be the
    whole group (`Subgroup.eq_top_of_card_eq`), so `Subgroup.zpowers [p₂] = ⊤`,
    and every element lies in it.

    Key Mathlib lemmas used:
    - `Nat.card_zpowers : Nat.card (zpowers a) = orderOf a`
    - `Subgroup.eq_top_of_card_eq [Finite H] (h : Nat.card H = Nat.card G) : H = ⊤`

    Discharges the last named open surface of `BSD_classGroup_gen_by_p2_hyp`. -/
theorem BSD_classGroup_gen_by_p2_CLOSED : BSD_classGroup_gen_by_p2_hyp := by
  have hp2ne : p2_OK ≠ 0 := by
    intro h
    have := absNorm_p2_eq_2
    rw [h, Ideal.zero_eq_bot, Ideal.absNorm_bot] at this
    norm_num at this
  let I₂ : (Ideal (𝓞 K))⁰ := ⟨p2_OK, mem_nonZeroDivisors_iff_ne_zero.mpr hp2ne⟩
  let g : ClassGroup (𝓞 K) := ClassGroup.mk0 I₂
  -- Step 1: orderOf g = 10  (from p₂^10 principal, proved unconditionally)
  have hord : orderOf g = 10 := BSD_orderOf_p2_eq_10 BSD_p2_pow_10_principal
  -- Step 2: classNumber K = 10  (proved unconditionally)
  have hcn : NumberField.classNumber K = 10 :=
    BSD_classNumber_eq_10_via_principal BSD_p2_pow_10_principal
  -- Step 3: Nat.card (zpowers g) = Nat.card (ClassGroup (𝓞 K))
  --   Nat.card_zpowers : Nat.card (zpowers g) = orderOf g = 10
  --   Nat.card_eq_fintype_card : Nat.card G = Fintype.card G = classNumber K = 10
  have hcard : Nat.card ↥(Subgroup.zpowers g) = Nat.card (ClassGroup (𝓞 K)) := by
    rw [Nat.card_zpowers, hord, Nat.card_eq_fintype_card]
    exact hcn.symm
  -- Step 4: zpowers g = ⊤  (subgroup of same finite cardinality as the group)
  have htop : Subgroup.zpowers g = ⊤ := Subgroup.eq_top_of_card_eq hcard
  -- Step 5: every element is in zpowers g
  intro x
  exact htop ▸ Subgroup.mem_top x

end BSD
