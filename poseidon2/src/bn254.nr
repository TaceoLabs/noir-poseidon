mod consts;
mod perm;
use dep::hash_utils;
use dep::hash_utils::poseidon;

struct Poseidon2Bn254Config<T, R> {
    first_full_rc: [[Field; T]; 4],
    partial_rc: [Field; R],
    second_full_rc: [[Field; T]; 4],
}

fn permute_bn254<T, R>(mut state: [Field; T], mm_external: fn([Field; T]) -> [Field; T], mm_internal: fn([Field; T]) -> [Field; T], config: Poseidon2Bn254Config<T,R>) -> [Field; T] {
    state = mm_external(state);
    for r in 0..4 {
        state = hash_utils::vec_add(state, config.first_full_rc[r]);
        state = poseidon::sbox(state);
        state = mm_external(state);
    }

    for r in 0..R {
        state[0] += config.partial_rc[r];
        state[0] = poseidon::sbox_e(state[0]);
        state = mm_internal(state);
    }
    for r in 0..4 {
        state = hash_utils::vec_add(state, config.second_full_rc[r]);
        state = poseidon::sbox(state);
        state = mm_external(state);
    }
    state
}

#[field(bn254)]
pub fn hash_1(input: [Field; 1]) -> Field {
    perm::x5_2([input[0], 1])[0]
}

#[field(bn254)]
pub fn hash_2(input: [Field; 2]) -> Field {
    perm::x5_2(input)[0]
}

#[field(bn254)]
pub fn hash_3(input: [Field; 3]) -> Field {
    perm::x5_3(input)[0]
}

#[field(bn254)]
pub fn hash_4(input: [Field; 4]) -> Field {
    perm::x5_4(input)[0]
}

#[field(bn254)]
pub fn hash_8(input: [Field; 8]) -> Field {
    perm::x5_8(input)[0]
}

#[field(bn254)]
pub fn hash_12(input: [Field; 12]) -> Field {
    perm::x5_12(input)[0]
}

#[field(bn254)]
pub fn hash_16(input: [Field; 16]) -> Field {
    perm::x5_16(input)[0]
}
