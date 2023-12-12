//TODO is this bn254 dependent??
pub(crate) fn mat_mul<T>(mut state: [Field; T], mds: [[Field; T]; T]) -> [Field; T] {
    //TODO check if we lose something if we leave this
    //agnostic in contrast to explicitly write optimized
    //mat mul for states
    let mut result = [0; T];
    for i in 0..T {
        for j in 0..T {
            result[i] += state[j] * mds[i][j];
        }
    }
    result
}

pub(crate) fn vec_add<T>(lhs: [Field; T], rhs: [Field; T]) -> [Field; T] {
    let mut result = [0; T];
    for i in 0..T {
        result[i] = lhs[i] + rhs[i];
    }
    result
}

#[field(bn254)]
pub(crate) fn sbox<T>(mut state: [Field; T]) -> [Field; T] {
    //TODO play around with that, can we get lower constraints here?
    state.map(|x| sbox_e(x))
}

#[field(bn254)]
pub(crate) fn sbox_e(mut x: Field) -> Field {
    let mut result = x * x;
    result *= result;
    result * x
}
