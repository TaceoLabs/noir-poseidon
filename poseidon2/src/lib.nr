mod bn254;

#[test]
fn compute_merkle_root() {
    // root created from https://github.com/HorizenLabs/poseidon2/tree/main/plain_implementations/src/merkle_tree
    let index = 2;
    let leaf = 0x193c4e41dd965c707d738672626157d4c951ed12a85a36da6d954e9ab605c037;
    let hash_path = [0x0d490ea58a8e26fc75656b77400b7ceeae89640963767b70cf82b729248a312d,
        0x169577083ea6a7f1259fb1824112239a40fe69fb35b4de31d41961b086d0049b,
        0x2c0145c2842afdcbdf891c245d4ebd0ba0c1123e790f8514cd377e11b099bcc9];
    let root = 0x0ad9565ee58cedc7bf6ab1c1fd2d7c1ea499301dd68c78801d0eedb720997134;

    //copied from https://github.com/noir-lang/noir/blob/e3dcc21cb2c0fef7f28f50b018747c4f09609b11/noir_stdlib/src/merkle.nr#L4
    let n = hash_path.len();
    let index_bits = index.to_le_bits(n as u32);
    let mut current = leaf;
    for i in 0..n {
        let path_bit = index_bits[i] as bool;
        let (hash_left, hash_right) = if path_bit {
            (hash_path[i], current)
        } else {
            (current, hash_path[i])
        };
        current = bn254::hash_3([hash_left, hash_right, 0]);
    }
    assert(current == root);
}
