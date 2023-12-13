# Noir-Poseidon for BN254

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This folder contains a Noir crate implementing the zk-friendly hash function Poseidon for Noir's native curve BN254. Poseidon, in contrast to traditional hash constructions like SHA-256, utilizes a low-degree round function (S-box) $x^d$ to minimize the necessary constraints inside a zk-circuit. In the case of BN254, the exponent in the round function is $d=5$. This implementation utilizes modern optimizations (in contrast to the existing Poseidon implementation in Noir's standard library) with all advances in cryptoanalysis in mind.

For further information, we refer to the [Poseidon Paper](https://eprint.iacr.org/2019/458.pdf).

## Performance

As the Noir's standard library, we provide an implementation for state sizes $t \in [2, 16]$. The following table shows the constraints obtained by `nargo info` for our implementation and the corresponding hashes from the standard library.

| Input | This Poseidon | Noir's standard library Poseidon |
| ----- | ------------- | -------------------------------- |
| 2     | 586           | 586                              |
| 3     | 2098          | 2183                             |
| 4     | 2305          | 2353                             |
| 5     | 2507          | 2833                             |
| 6     | 2795          | 3059                             |
| 7     | 3031          | 3532                             |
| 8     | 3283          | 3877                             |
| 9     | 3551          | 4076                             |
| 10    | 3835          | 4123                             |
| 11    | 4135          | 4948                             |
| 12    | 4451          | 4751                             |
| 13    | 4783          | 5539                             |
| 14    | 5131          | 6388                             |
| 15    | 5495          | 5813                             |
| 16    | 5875          | 6581                             |

It shows that thanks to the implemented optimizations and the fewer rounds of our implementation, we can improve on the necessary constraints for all state sizes $\ge 3$, whereas for state size $t=2$ the constraints are equivalent.

## Installation

In your `Nargo.toml` file, add the following dependency:

```toml
[dependencies]
poseidon = { tag = "v0.1.0", git = "https://github.com/TaceoLabs/noir-poseidon", directory = "poseidon"} }
```

## Examples

To compute a hash from three Field elements, write:

```Rust
use dep::poseidon;

fn main(plains: [Field; 8]) -> pub Field {
    poseidon::bn254::hash_8(plains)
}
```

As already mentioned, we also provide function calls for state sizes $t \in [2..16]$, with the respective functions `poseidon::bn254::hash_2([..])`, `poseidon::bn254::hash_3([..])`, etc.

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
