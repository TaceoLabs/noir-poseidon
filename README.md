# Noir-Griffin for BN254

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains a Noir crate implementing the zk-friendly hash function Griffin for Noir's native curve BN254.

Griffin utilizes low-degree equivalence, optimized for fast prover times. These designs rely on the observation that it is possible to prove the heavy computation $y=x^{1/d}$ by constraining $y^d=x$. If $d$ is small (5 for this implementation) and the prime field is large, then $1/d$ is a considerably large exponent with many multiplications involved. Using the power map $y=x^{1/d}$ leads to fewer rounds necessary to achieve a target security threshold.

Especially in contrast to older designs, which use the power map $y=x^d$ with a relatively small exponent (like Poseidon), Griffin has a drastically improved prover time. See the Performance section below.

As proposed in the Griffin paper, we provide an API for using Griffin in sponge mode. We use the instantiation with state size 3, bitrate $r=2$, and capacity $c=1$.

For further information, we refer to the [Griffin Paper](https://eprint.iacr.org/2022/403.pdf).

## Performance

We instantiated this Griffin instance with $d$=5 and hence $1/d=$`0x26b6a528b427b35493736af8679aad17535cb9d394945a0dcfe7f7a98ccccccd`.

Griffin has an internal state size $s \in \\{3, 4t\\}$ for a positive integer $t$. We provide an implementation for state sizes 3, 4, and 8. The following table shows the constraints obtained by `nargo info` for our implementation and the corresponding hashes from the standard library that work on Field elements.

| Input | Griffin | Poseidon | Pedersen | mimc_bn254 | `hash_to_field` (blake2) |
| ----- | ------- | -------- | -------- | ---------- | ------------------------ |
| 3     | 172     | 2280     | 3112     | 1375       | 8958                     |
| 4     | 279     | 2751     | 3260     | 1927       | 9088                     |
| 8     | 591     | 3938     | 3848     | 4506       | 15287                    |

Griffin heavily outperforms its peers for all instantiations. We also compare Griffin in sponge mode with Poseidon in sponge mode as provided by the standard library in the following table:

| Input | Griffin | Poseidon |
| ----- | ------- | -------- |
| 1     | 168     | 2728     |
| 2     | 269     | 2733     |
| 4     | 548     | 2751     |
| 8     | 1106    | 5525     |
| 16    | 2222    | 11073    |

**Note**: Our sponge API allows an arbitrarily long output stream. The sponge implementation from the standard library only allows a single output Field (version 0.10.5). Therefore, we compare the performance with a single output element.

## Installation

In your `Nargo.toml` file, add the following dependency:

```toml
[dependencies]
griffin = { tag = "v0.3.0", git = "https://github.com/TaceoLabs/noir-griffin" }
```

## Examples

To compute a hash from three Field elements, write:

```Rust
use dep::griffin;

fn main(plains: [Field; 3]) -> pub Field {
    griffin::bn254::hash_3(plains)
}
```

We also provide function calls for hashing 4 and 8 Field elements, with the respective functions `griffin::bn254::hash_4([..])` and `griffin::bn254::hash_8([..])`.

To use griffin in sponge mode, write:

```Rust
use dep::griffin;

fn main(plains: [Field; 8]) -> pub [Field;4] {
    griffin::bn254::sponge(plains)
}
```

In this example, we absorb 8 Field elements and the output 4 elements. The API supports arbitrary long inputs and outputs $>0$.

For further examples on how to use the Griffin crate, have a look in the `lib.nr` file in the `src/` directory and check the tests.

## Rounds constants

We used the same round constants like this [reference implementation](https://extgit.iaik.tugraz.at/krypto/zkfriendlyhashzoo/-/blob/33fe9952682eca1337ac7f947b9ebe366faeda9c/plain_impls/src/griffin/griffin_params.rs).

## Disclaimer

This is **experimental software** and is provided on an "as is" and "as available" basis. We do **not give any warranties** and will **not be liable for any losses** incurred through any use of this code base.

| #   | Poseidon old | Poseidon new | Poseidon2 |
| --- | ------------ | ------------ | --------- |
| 2   | 586          | 586          | 586       |
| 3   | 2183         | 2098         | 2094      |
| 4   | 2353         | 2305         | 2313      |
| 5   | 2833         | 2507         | -         |
| 6   | 3059         | 2795         | -         |
| 7   | 3532         | 3031         | -         |
| 8   | 3877         | 3283         | 3139      |
| 9   | 4076         | 3551         | -         |
| 10  | 4123         | 3835         | -         |
| 11  | 4948         | 4135         | -         |
| 12  | 4751         | 4451         | 3995      |
| 13  | 5539         | 4783         | -         |
| 14  | 6388         | 5131         | -         |
| 15  | 5813         | 5495         | -         |
| 16  | 6581         | 5875         | 4883      |
