// Instantiations of Poseidon constants, permutations and sponge for prime field of the same order as BN254
mod default_perm;
mod perm;
mod consts;

use dep::hash_utils;
use dep::hash_utils::poseidon;

struct PoseidonBn254Config<T, RP, T1> {
    first_full_rc: [[Field; T]; 4],
    opt_rc_outer: [Field; T],
    opt_partial_rc: [Field; RP],
    second_full_rc: [[Field; T]; 4],
    mds: [[Field; T]; T],
    m_i: [[Field; T]; T],
    v: [[Field; T1]; RP],
    w_hat: [[Field; T1]; RP],
}

fn permute_bn254<T, RP, T1>(
    mut state: [Field; T],
    config: PoseidonBn254Config<T, RP, T1>
) -> [Field; T] {
    for i in 0..4 {
        state = hash_utils::vec_add(state, config.first_full_rc[i]);
        state = poseidon::sbox(state);
        state = hash_utils::mat_mul(state, config.mds);
    }
    //the 0-th round
    state = hash_utils::vec_add(state, config.opt_rc_outer);
    state = hash_utils::mat_mul(state, config.m_i);

    for r in 0..RP {
        state[0] = poseidon::sbox_e(state[0]);
        //only one addition for round key
        state[0] = state[0] + config.opt_partial_rc[r];
        //the cheaper mat mul with M^\prime\prime
        state = cheap_matmul(state, config.v[RP - r -1], config.w_hat[RP - r -1], config.mds[0][0]);
    }
    for r in 0..4 {
        state =hash_utils::vec_add(state, config.second_full_rc[r]);
        state =poseidon::sbox(state);
        state =hash_utils::mat_mul(state, config.mds);
    }
    state
}

fn cheap_matmul<T, T1>(
    mut state: [Field; T],
    v: [Field; T1],
    w_hat: [Field; T1],
    mds: Field
) -> [Field; T] {
    let mut new_state = [0; T];
    new_state[0] = mds * state[0];
    for i in 0..T1 {
        new_state[0] += w_hat[i] * state[i+1];
    }
    for i in 1..T {
        new_state[i] = state[0] * v[i-1] + state[i];
    }
    new_state
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
pub fn hash_5(input: [Field; 5]) -> Field {
    perm::x5_5(input)[0]
}

#[field(bn254)]
pub fn hash_6(input: [Field; 6]) -> Field {
    perm::x5_6(input)[0]
}

#[field(bn254)]
pub fn hash_7(input: [Field; 7]) -> Field {
    perm::x5_7(input)[0]
}

#[field(bn254)]
pub fn hash_8(input: [Field; 8]) -> Field {
    perm::x5_8(input)[0]
}

#[field(bn254)]
pub fn hash_9(input: [Field; 9]) -> Field {
    perm::x5_9(input)[0]
}

#[field(bn254)]
pub fn hash_10(input: [Field; 10]) -> Field {
    perm::x5_10(input)[0]
}

#[field(bn254)]
pub fn hash_11(input: [Field; 11]) -> Field {
    perm::x5_11(input)[0]
}

#[field(bn254)]
pub fn hash_12(input: [Field; 12]) -> Field {
    perm::x5_12(input)[0]
}

#[field(bn254)]
pub fn hash_13(input: [Field; 13]) -> Field {
    perm::x5_13(input)[0]
}

#[field(bn254)]
pub fn hash_14(input: [Field; 14]) -> Field {
    perm::x5_14(input)[0]
}

#[field(bn254)]
pub fn hash_15(input: [Field; 15]) -> Field {
    perm::x5_15(input)[0]
}

#[field(bn254)]
pub fn hash_16(input: [Field; 16]) -> Field {
    perm::x5_16(input)[0]
}

