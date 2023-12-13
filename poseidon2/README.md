# Noir-Poseidon2 for BN254

This folder contains a Noir crate implementing the zk-friendly hash function Poseidon2 for Noir's native curve BN254. Poseidon2, similar to [Poseidon](poseidon), utilizes a low-degree round function with the $x^d$ S-box to minimize the necessary constraints inside a zk-circuit. In the case of BN254, the exponent in the round function is $d=5$.

Poseidon2 improves on Poseidon by changing the linear layers to use different matrices in the partial and full rounds. These matrices provide faster hashing performance (even faster than using the optimized partial layer implementation of Poseidon) and smaller Noir circuit representation, while providing the same security. Thus Poseidon2 provides a much needed improvement to Poseidon, as the plain execution of Poseidon (i.e., outside of proof systems) is often a bottleneck in real-world scenarios.

For further information, we refer to the [Poseidon2 Paper](https://eprint.iacr.org/2023/323.pdf).

## Performance

Poseidon2 has an internal state size $t\in \\{2,3,4t^\prime,\dots,24\\} \text{ for } t^\prime \in \mathbb{N}$. We provide an implementation for state sizes $t\in \\{2,3,4,8,12,16\\}$, mirroring the Poseidon implementation in Noir's standard library. The following table shows the constraints obtained by `nargo info` for this Poseidon2 implementation, Noir's standard library Poseidon implementation, and the Poseidon implementation found [in this repository](poseidon).

| #   | Poseidon (stdlib) | Poseidon | Poseidon2 |
| --- | ----------------- | -------- | --------- |
| 2   | 586               | 586      | 586       |
| 3   | 2183              | 2098     | 2094      |
| 4   | 2353              | 2305     | 2313      |
| 8   | 3877              | 3283     | 3139      |
| 12  | 4751              | 4451     | 3995      |
| 16  | 6581              | 5875     | 4883      |

The table shows that for $t=2$ all implementations produce the same number of constraints. For $t=4$, the new Poseidon implementation in this repository actually outperforms Poseidon2 with respect to constraint sizes, but for all other state sizes, Poseidon2 produces fewer constraints. **Note** that this table only depicts the amount of constraints (rows in a plonkish proof system), impacting the computation when computing FFTs. What this table does not show is the plain speed improvement of Poseidon2 in contrast to Poseidon, which is necessary for filling the trace and native hashing.

## Installation

In your `Nargo.toml` file, add the following dependency:

```toml
[dependencies]
poseidon2 = { tag = "v0.1.0", git = "https://github.com/TaceoLabs/noir-poseidon", directory = "poseidon2"}
```

## Examples

To compute a hash from eight Field elements, write:

```Rust
use dep::poseidon;

fn main(plains: [Field; 8]) -> pub Field {
    poseidon2::bn254::hash_8(plains)
}
```

As already mentioned, we also provide function calls for state sizes $t\in {2,3,4,8,12,16}$, with the respective functions `poseidon2::bn254::hash_2([..])`, `poseidon2::bn254::hash_3([..])`, etc.

For further examples on how to use the Poseidon2 crate, have a look at the [tests](src/bn254/perm.nr).

## Round Constants

We used the same matrices and round constants as the official [Poseidon2 implementation](https://github.com/HorizenLabs/poseidon2/tree/main). We added the script that produces the round constants [in the repository](scripts/poseidon2_constants.sage). You can generate the round constants by executing the following command in the root of the repository and setting the parameter $t$ at the top of the file:

```bash
cd scripts && sage poseidon2_constants.sage
```

## Disclaimer

This is **experimental software** and is provided on an "as is" and "as available" basis. We do **not give any warranties** and will **not be liable for any losses** incurred through any use of this code base.
