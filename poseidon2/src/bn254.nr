mod consts;
mod perm;
use dep::crypto_math;
use dep::crypto_math::poseidon;

fn permute_bn254<T, R>(mut state: [Field; T], rc: [[Field; T]; R], mm_external: fn([Field; T]) -> [Field; T], mm_internal: fn([Field; T]) -> [Field; T]) -> [Field; T] {
    state = mm_external(state);
    for r in 0..4 {
        state = crypto_math::vec_add(state, rc[r]);
        state = poseidon::sbox(state);
        state = mm_external(state);
    }

    for r in 4..R - 4 {
        state[0] += rc[r][0];
        state[0] = poseidon::sbox_e(state[0]);
        state = mm_internal(state);
    }
    for r in R - 4..R {
        state = crypto_math::vec_add(state, rc[r]);
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