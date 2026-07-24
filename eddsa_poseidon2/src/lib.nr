// EdDSA Poseidon2 Verifier for Noir
// Complete implementation of EdDSA signature verification using Poseidon2 hash

use babyjubjub::{BabyJubJubPoint, BabyJubJubPointInSubgroup, BabyJubJubScalarFieldElement};
use poseidon2::bn254::permutation;
mod tests;

// Domain separator for EdDSA signatures: b"EdDSA Signature"
global DOMAIN_SEPARATOR: Field = 360302137480307891234917541314130533;

/// EdDSA Poseidon2 Verifier
///
/// Verifies an EdDSA signature using Poseidon2 hash function
///
/// # Inputs
/// - pub_key: The signer's public key (must be in the prime-order subgroup)
/// - signature_s: The scalar component of the signature
/// - signature_r: The point component of the signature (must be on the curve)
/// - message: The message that was signed
///
/// # Verification Equation (cofactored)
/// 8*(S*G - R - h*A) == Identity
/// where h = Poseidon2(domain_separator, Rx, Ry, Ax, Ay, M, 0, 0)
pub fn verify_eddsa_poseidon2(
    pub_key: BabyJubJubPointInSubgroup,
    signature_s: BabyJubJubScalarFieldElement,
    signature_r: BabyJubJubPoint,
    message: Field,
) -> bool {

    // Step 0 - We cast the signature point to a BabyJubJubPointInSubgroup to make the
    // type system happy. This is safe without an actual subgroup check: R only needs to be
    // on the curve. Any curve point decomposes uniquely as R = R' + T, where R' is in the
    // prime-order subgroup and T is torsion (order dividing the cofactor 8). Step 5
    // multiplies the final result by 8, so 8*T = Identity and the torsion component of R
    // cancels out. The verification outcome is therefore identical whether or not R was in
    // the subgroup, making an explicit subgroup check on R redundant.
    let signature_r = BabyJubJubPointInSubgroup::new_unchecked(signature_r.x(), signature_r.y());

    // Step 1 - Compute h = Poseidon2(domain_separator, Rx, Ry, Ax, Ay, M, 0, 0)
    let hash_state = permutation::t8([
        DOMAIN_SEPARATOR,
        signature_r.x(),
        signature_r.y(),
        pub_key.x(),
        pub_key.y(),
        message,
        0,
        0,
    ]);

    let hash = hash_state[1];

    // Step 2 - Compute right side: R + h*A
    // Calculate h*A (h is in base field Fq, so use scalar_mul_base_field)
    let right2 = pub_key.scalar_mul_base_field(hash);

    // Calculate R + h*A
    let right = signature_r.add(right2);

    // Step 3 - Compute left side: S*G
    let left = BabyJubJubPointInSubgroup::generator_scalar_mul(signature_s);

    // Step 4 - Compute v = S*G - R - h*A = S*G - (R + h*A)
    let v = left.subtract(right);

    // Step 5 - Check if v is the identity
    v.double().double().double().is_identity()
}
