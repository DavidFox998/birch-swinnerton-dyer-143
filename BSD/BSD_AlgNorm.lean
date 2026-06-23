import Towers.BSD.BSD_NormBridge
import Mathlib.NumberTheory.NumberField.Norm
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-
  Towers/BSD/BSD_AlgNorm.lean

  Proves BSD_algNorm_gen_CLOSED from BSD_NormBridge.lean:
    (Algebra.norm ℤ gen_OK : ℤ) = 1024

  Strategy:
    1. Compute Algebra.norm ℚ (gen_OK : K) = 1024 via the ℚ-power basis pb_BSD.
       The left-multiplication matrix of gen_K in [1, α] basis is
         M = [[-53/2, -429/2], [3/2, -53/2]]
       with det = (-53/2)(-53/2) − (-429/2)(3/2) = 2809/4 + 1287/4 = 4096/4 = 1024.
    2. Algebra.coe_norm_int: (Algebra.norm ℤ gen_OK : ℚ) = Algebra.norm ℚ (gen_OK : K).
    3. Conclude (Algebra.norm ℤ gen_OK : ℤ) = 1024 by exact_mod_cast.

  SORRY: 0.  Classical trio {propext, Classical.choice, Quot.sound}.
  NOT a brick.  BSD class number: OPEN (Phase 2 still needs ideal bridge).
-/

namespace Towers.BSD

open NumberField Polynomial

/-! ## §1. Key sub-lemmas about gen_OK in K -/

/-- α² = −143 in K.  Follows from α_eval_zero_BSD : aeval α (X²+143) = 0. -/
private theorem α_sq_BSD : α ^ 2 = -(143 : K) := by
  have h := α_eval_zero_BSD
  simp only [map_add, map_pow, Polynomial.aeval_X,
             Polynomial.aeval_C, map_ofNat] at h
  linarith

/-- (gen_OK : K) = (−53/2) • 1 + (3/2) • α  in the ℚ-span of [1, α].
    Proof: gen_K = −28 + 3ω = −28 + 3(1+α)/2 = −53/2 + (3/2)α. -/
private theorem gen_K_in_1_α_basis :
    (gen_OK : K) = (-(53 : ℚ) / 2) • (1 : K) + ((3 : ℚ) / 2) • α := by
  rw [gen_OK_coe, ω]
  simp only [Algebra.smul_def, map_inv₀, map_ofNat, RingHom.map_one]
  field_simp
  ring

/-- gen_OK · α = (−429/2) • 1 + (−53/2) • α.
    Proof: gen_K · α = (−53/2 + 3α/2)α = −53α/2 + 3α²/2 = −53α/2 − 429/2. -/
private theorem gen_K_times_α :
    (gen_OK : K) * α = (-(429 : ℚ) / 2) • (1 : K) + (-(53 : ℚ) / 2) • α := by
  rw [gen_K_in_1_α_basis]
  simp only [add_mul, smul_mul_assoc, Algebra.smul_def, map_inv₀, map_ofNat,
             RingHom.map_one, one_mul]
  rw [show α ^ 2 = -(143 : K) from α_sq_BSD]
  push_cast
  ring

/-! ## §2. Power basis computations -/

/-- pb_BSD.basis 0 = 1 (zeroth power of the generator). -/
private theorem pb_basis_0 : pb_BSD.basis 0 = (1 : K) := by
  simp [PowerBasis.coe_basis, pow_zero]

/-- pb_BSD.basis 1 = α (first power of the generator). -/
private theorem pb_basis_1 : pb_BSD.basis 1 = α := by
  simp [PowerBasis.coe_basis, pow_one, pb_BSD_gen_eq_α]

/-- gen_OK expressed in pb_BSD.basis coordinates:
    gen_K = (−53/2) · basis[0] + (3/2) · basis[1]. -/
private theorem gen_K_basis_repr :
    (gen_OK : K) = (-(53 : ℚ) / 2) • pb_BSD.basis 0 + ((3 : ℚ) / 2) • pb_BSD.basis 1 := by
  rw [pb_basis_0, pb_basis_1]
  exact gen_K_in_1_α_basis

/-- gen_OK · α expressed in pb_BSD.basis coordinates:
    gen_K · α = (−429/2) · basis[0] + (−53/2) · basis[1]. -/
private theorem gen_K_α_basis_repr :
    (gen_OK : K) * pb_BSD.basis 1 =
    (-(429 : ℚ) / 2) • pb_BSD.basis 0 + (-(53 : ℚ) / 2) • pb_BSD.basis 1 := by
  rw [pb_basis_1]
  exact gen_K_times_α

/-! ## §3. Matrix of left-multiplication by gen_OK in [1, α] basis -/

/-- The left-multiplication matrix of gen_OK in pb_BSD.basis is
    !![−53/2, −429/2; 3/2, −53/2]. -/
private theorem gen_lmul_matrix :
    LinearMap.toMatrix pb_BSD.basis pb_BSD.basis
      ((Algebra.lmul ℚ K) (gen_OK : K)) =
    !![-(53 : ℚ) / 2, -(429 : ℚ) / 2; (3 : ℚ) / 2, -(53 : ℚ) / 2] := by
  ext i j
  fin_cases i <;> fin_cases j
  all_goals simp only [LinearMap.toMatrix_apply, Algebra.lmul_apply,
                       Matrix.cons_val_zero, Matrix.cons_val_one,
                       Matrix.head_cons, Matrix.head_fin_const]
  · -- M[0][0] = repr(gen_K * basis 0)[0] = repr(gen_K)[0] = -53/2
    rw [pb_basis_0, mul_one, gen_K_basis_repr,
        map_add, map_smul, map_smul,
        pb_BSD.basis.repr_self, pb_BSD.basis.repr_self]
    simp [Finsupp.smul_apply, Finsupp.single_apply]
  · -- M[1][0] = repr(gen_K * basis 0)[1] = repr(gen_K)[1] = 3/2
    rw [pb_basis_0, mul_one, gen_K_basis_repr,
        map_add, map_smul, map_smul,
        pb_BSD.basis.repr_self, pb_BSD.basis.repr_self]
    simp [Finsupp.smul_apply, Finsupp.single_apply]
  · -- M[0][1] = repr(gen_K * basis 1)[0] = repr(gen_K · α)[0] = -429/2
    rw [gen_K_α_basis_repr,
        map_add, map_smul, map_smul,
        pb_BSD.basis.repr_self, pb_BSD.basis.repr_self]
    simp [Finsupp.smul_apply, Finsupp.single_apply]
  · -- M[1][1] = repr(gen_K * basis 1)[1] = repr(gen_K · α)[1] = -53/2
    rw [gen_K_α_basis_repr,
        map_add, map_smul, map_smul,
        pb_BSD.basis.repr_self, pb_BSD.basis.repr_self]
    simp [Finsupp.smul_apply, Finsupp.single_apply]

/-! ## §4. ℚ-norm of gen_OK = 1024 -/

/-- **PROVED** (0 sorry, classical trio):
    Algebra.norm ℚ (gen_OK : K) = 1024.

    Proof: the left-multiplication matrix of gen_K in [1, α] basis is
    !![−53/2, −429/2; 3/2, −53/2], whose det = (−53/2)² − (−429/2)·(3/2) = 1024. -/
theorem BSD_norm_gen_K_rat : Algebra.norm ℚ (gen_OK : K) = 1024 := by
  simp only [Algebra.norm_apply]
  rw [← LinearMap.det_toMatrix pb_BSD.basis]
  rw [gen_lmul_matrix]
  rw [Matrix.det_fin_two]
  norm_num

/-! ## §5. ℤ-norm of gen_OK = 1024 — BSD_algNorm_gen_CLOSED -/

/-- **PROVED** (0 sorry, classical trio):
    BSD_algNorm_gen_CLOSED : (Algebra.norm ℤ gen_OK : ℤ) = 1024.

    Proof chain:
    1. (Algebra.norm ℤ gen_OK : ℚ) = Algebra.norm ℚ (gen_OK : K)   [coe_norm_int]
    2. Algebra.norm ℚ (gen_OK : K) = 1024                            [BSD_norm_gen_K_rat]
    3. (Algebra.norm ℤ gen_OK : ℤ) = 1024                            [exact_mod_cast]

    SORRY: 0.  Classical trio.  NOT a brick. -/
theorem BSD_algNorm_gen_proof : BSD_algNorm_gen_CLOSED := by
  have hQ : (Algebra.norm ℤ gen_OK : ℚ) = 1024 := by
    rw [Algebra.coe_norm_int]
    exact_mod_cast BSD_norm_gen_K_rat
  exact_mod_cast hQ

/-! ## §6. absNorm combinator -/

/-- **BSD_absNorm_gen_CLOSED** (0 sorry, classical trio):
    Ideal.absNorm (span {gen_OK}) = 1024.

    Proof: BSD_algNorm_gen_proof + BSD_absNorm_gen_cond from BSD_NormBridge. -/
theorem BSD_absNorm_gen_CLOSED :
    Ideal.absNorm (Ideal.span ({gen_OK} : Set (𝓞 K))) = 1024 :=
  BSD_absNorm_gen_cond BSD_algNorm_gen_proof

end Towers.BSD
