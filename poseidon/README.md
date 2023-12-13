# Noir-Poseidon for BN254

This folder contains a Noir crate implementing the zk-friendly hash function Poseidon for Noir's native curve BN254. Poseidon, in contrast to traditional hash constructions like SHA-256, utilizes a low-degree round function (S-box) $x^d$ to minimize the necessary constraints inside a zk-circuit. In the case of BN254, the exponent in the round function is $d=5$. This implementation utilizes modern optimizations (in contrast to the existing Poseidon implementation in Noir's standard library) with all advances in cryptoanalysis in mind.

For further information, we refer to the [Poseidon Paper](https://eprint.iacr.org/2019/458.pdf).

## Performance

Similar to Noir's standard library, we provide an implementation for state sizes $t \in [2, 16]$. The following table shows the constraints obtained by `nargo info` for our implementation and the corresponding hashes from the standard library.

| Input | Noir's standard library Poseidon | This Poseidon |
| ----- | -------------------------------- | ------------- |
| 2     | 586                              | 586           |
| 3     | 2183                             | 2098          |
| 4     | 2353                             | 2305          |
| 5     | 2833                             | 2507          |
| 6     | 3059                             | 2795          |
| 7     | 3532                             | 3031          |
| 8     | 3877                             | 3283          |
| 9     | 4076                             | 3551          |
| 10    | 4123                             | 3835          |
| 11    | 4948                             | 4135          |
| 12    | 4751                             | 4451          |
| 13    | 5539                             | 4783          |
| 14    | 6388                             | 5131          |
| 15    | 5813                             | 5495          |
| 16    | 6581                             | 5875          |

The table shows that thanks to optimizations and fewer rounds of our implementation (see Section [Round Constants](#round-constants)), we can improve on the necessary constraints for all state sizes $\ge 3$, whereas for state size $t=2$ the constraints are equivalent.

For state sizes $t \le 4$, we use optimized MDS matrices for the linear layer. This improves performance without sacrificing security. For all other state sizes, we use equivalent transformations to the linear layer in the half rounds, improving on constraints of the matrix multiplication, as seen in [the rust implementation](https://extgit.iaik.tugraz.at/krypto/zkfriendlyhashzoo/-/tree/master/bellman/src/poseidon?ref_type=heads).

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

For further examples on how to use the Poseidon crate, have a look at the [tests](src/bn254/perm.nr).

## Round Constants

In contrast to Noir's standard libraries' Poseidon implementation, we use the same round constants as the [reference implementation](https://extgit.iaik.tugraz.at/krypto/hadeshash/-/tree/master/code?ref_type=heads). We added the script that produces the round constants [in the repository](/scripts/poseidon_constants.sage). You can generate the round constants (except the MDS matrices for $t \in [2,4]$) by executing the following command in the root of the repository:

```bash
cd scripts && sage poseidon_constants.sage
```

We give the MDS matrices for the remaining state sizes here:

$$
\text{MDS}_2 = \text{circ}(2\text{ }1)
$$

$$
\text{MDS}_3 = \begin{pmatrix}
2 & 1 & 1\\
1 & 3 & 1\\
1 & 1 & 2
\end{pmatrix}
$$

$$
\text{MDS}_4 =
\begin{pmatrix}
5 & 7 & 1 & 3\\
4 & 6 & 1 & 1\\
1 & 3 & 5 & 7\\
1 & 1 & 4 & 6
\end{pmatrix}
$$

We use the already mentioned [rust implementation](https://extgit.iaik.tugraz.at/krypto/zkfriendlyhashzoo/-/tree/master/bellman/src/poseidon?ref_type=heads) to compute the constants for the transformed linear layer in the half rounds.

The old implementation sacrificed performance for interoperability with the Circom implementation, hence using more rounds for certain instantiations than necessary. Our implementation is not conformant to Circom, but to the reference implementation from the authors of Poseidon. On top of the implemented optimizations, we can also improve the performance due to fewer rounds.

## Disclaimer

This is **experimental software** and is provided on an "as is" and "as available" basis. We do **not give any warranties** and will **not be liable for any losses** incurred through any use of this code base.
