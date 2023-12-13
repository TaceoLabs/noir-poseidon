# Noir-Poseidon for BN254

This folder contains a Noir crate implementing the zk-friendly hash function Poseidon for Noir's native curve BN254. Poseidon, in contrast to traditional hash constructions like SHA-256, utilizes a low-degree round function (S-box) $x^d$ to minimize the necessary constraints inside a zk-circuit. In the case of BN254, the exponent in the round function is $d=5$. This implementation utilizes modern optimizations (in contrast to the existing Poseidon implementation in Noir's standard library) with all advances in cryptoanalysis in mind.

For further information, we refer to the [Poseidon Paper](https://eprint.iacr.org/2019/458.pdf).

## Performance

Similar to Noir's standard library, we provide an implementation for state sizes $t \in [2, 16]$. The following table shows the constraints obtained by `nargo info` for our implementation and the corresponding hashes from the standard library.

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

It shows that thanks to the implemented optimizations and the fewer rounds of our implementation (see Section [Round Constants](#round-constants)), we can improve on the necessary constraints for all state sizes $\ge 3$, whereas for state size $t=2$ the constraints are equivalent.

For state sizes $t \le 4$, we use optimized MDS matrices for the linear layer. This improves performance without sacrificing security. For all other state sizes, we used equivalent transformations to the linear layer in the half rounds, improving on constraints of the matrix multiplication, as seen in [the rust implementation](https://extgit.iaik.tugraz.at/krypto/zkfriendlyhashzoo/-/tree/master/bellman/src/poseidon?ref_type=heads).

## Installation

In your `Nargo.toml` file, add the following dependency:

```toml
[dependencies]
poseidon = { tag = "v0.1.0", git = "https://github.com/TaceoLabs/noir-poseidon", directory = "poseidon"}
```

## Examples

To compute a hash from eight Field elements, write:

```Rust
use dep::poseidon;

fn main(plains: [Field; 8]) -> pub Field {
    poseidon::bn254::hash_8(plains)
}
```

As already mentioned, we also provide function calls for state sizes $t \in [2..16]$, with the respective functions `poseidon::bn254::hash_2([..])`, `poseidon::bn254::hash_3([..])`, etc.

For further examples on how to use the Poseidon crate, have a look at the [tests](https://github.com/TaceoLabs/noir-poseidon/blob/db5ed1f0eaa1b59895dd5d76967c44b11a5ec578/poseidon/src/bn254/perm.nr).

## Round Constants

In contrast to Noir's standard libraries' Poseidon implementation, we used the same round constants as the [reference implementation](https://extgit.iaik.tugraz.at/krypto/hadeshash/-/tree/master/code?ref_type=heads). We added the script that produces the round constants [in the repository](https://github.com/TaceoLabs/noir-poseidon/blob/db5ed1f0eaa1b59895dd5d76967c44b11a5ec578/scripts/poseidon_constants.sage). You can generate the round constants (except the MDS matrices for $t \in [2,4]$) by executing the following command in the root of the repository:

```bash
cd scripts && sage poseidon_constants.sage
```

We give the MDS for the remaining state sizes here:

\[
poseidonperm_x5_2 = \text{circ}(2 1)
\]

\[
poseidonperm_x5_3 =
\begin{pmatrix}
2 & 1 & 1\\
1 & 3 & 1\\
1 & 1 & 2
\end{pmatrix}
\]

\[
poseidonperm_x5_4 =
\begin{pmatrix}
5 & 7 & 1 & 3\\
4 & 6 & 1 & 1\\
1 & 3 & 5 & 7\\
1 & 1 & 4 & 6
\end{pmatrix}

\]

We use the already mentioned [rust implementation](https://extgit.iaik.tugraz.at/krypto/zkfriendlyhashzoo/-/tree/master/bellman/src/poseidon?ref_type=heads) to compute the constants for the transformed linear layer in the half rounds.

The old implementation sacrificed performance for interoperability with the Circom implementation, hence using more rounds for certain instantiations than necessary. Our implementation is not conformant to Circom, but to the reference implementation from the authors of Poseidon. On top of the implemented optimizations, we can also improve the performance due to fewer rounds.

## Disclaimer

This is **experimental software** and is provided on an "as is" and "as available" basis. We do **not give any warranties** and will **not be liable for any losses** incurred through any use of this code base.
