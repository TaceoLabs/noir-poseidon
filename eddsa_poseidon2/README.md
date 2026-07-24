# EdDSA over Poseidon2 for Noir

This folder contains a Noir crate implementing EdDSA signature verification over the [BabyJubJub](https://github.com/TaceoLabs/oprf-nr/tree/main/babyjubjub) twisted Edwards curve, using the [Poseidon2](../poseidon2) permutation as the signature hash. This mirrors the widely used Circom/EIP-2494 EdDSA-Poseidon construction, but with Poseidon2 instead of the original Poseidon hash.

The crate exposes a single verification function that checks the **cofactored** EdDSA verification equation:

$$
8 \cdot (S \cdot G - R - h \cdot A) = \mathcal{O}
$$

where $G$ is the BabyJubJub generator, $A$ is the signer's public key, $(R, S)$ is the signature, and

$$
h = \text{Poseidon2}(DS, R_x, R_y, A_x, A_y, M, 0, 0)
$$

with $DS$ a fixed domain separator for EdDSA signatures and $M$ the signed message.

Before computing the equation, the function validates that:

- $S$ is a valid element of the BabyJubJub scalar field
- $A$ lies on the curve, is in the prime-order subgroup, and is not the identity
- $R$ lies on the curve

Note that $R$ is **not** checked for prime-order subgroup membership, unlike $A$. This is
sound because the verification equation is cofactored: any curve point decomposes uniquely
as $R = R' + T$, where $R'$ lies in the prime-order subgroup and $T$ is a torsion point whose
order divides the cofactor 8. Since the equation multiplies through by 8 and $8 \cdot T =
\mathcal{O}$, the torsion component of $R$ cancels out and the outcome is identical whether
or not $R$ was in the subgroup. An explicit subgroup check on $R$ would therefore be
redundant.

## Dependencies

This crate depends on:

- [`poseidon2`](../poseidon2) from this repository (path dependency), for the Poseidon2 permutation used to compute $h$.
- [`babyjubjub`](https://github.com/TaceoLabs/oprf-nr/tree/main/babyjubjub) (git dependency), for BabyJubJub curve arithmetic.

## Installation

In your `Nargo.toml` file, add the following dependencies:

```toml
[dependencies]
eddsa_poseidon2 = { tag = "v0.7.0", git = "https://github.com/TaceoLabs/noir-poseidon", directory = "eddsa_poseidon2" }
```

## Examples

```Rust
use dep::babyjubjub::{BabyJubJubPoint, BabyJubJubPointInSubgroup, BabyJubJubScalarFieldElement};
use dep::eddsa_poseidon2;

fn main(
    pub_key_x: Field,
    pub_key_y: Field,
    signature_s: Field,
    signature_r: [Field; 2],
    message: Field,
) -> pub bool {
    let pub_key = BabyJubJubPointInSubgroup::new(pub_key_x, pub_key_y);
    let signature_s = BabyJubJubScalarFieldElement::new(signature_s);
    let signature_r = BabyJubJubPoint::new(signature_r[0], signature_r[1]);

    eddsa_poseidon2::verify_eddsa_poseidon2(pub_key, signature_s, signature_r, message)
}
```

For further examples, have a look at the [tests](src/tests.nr).

## Disclaimer

This is **experimental software** and is provided on an "as is" and "as available" basis. We do **not give any warranties** and will **not be liable for any losses** incurred through any use of this code base.
