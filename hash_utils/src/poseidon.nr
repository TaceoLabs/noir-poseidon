use crate::double;

#[field(bn254)]
pub fn sbox<T>(mut state: [Field; T]) -> [Field; T] {
    state.map(|x| sbox_e(x))
}

#[field(bn254)]
pub fn sbox_e(mut x: Field) -> Field {
    let mut result = x * x;
    result *= result;
    result * x
}

#[field(bn254)]
pub fn mds_2(state: [Field; 2])->[Field; 2] {
    let sum = state[0] + state[1];
    [sum + state[0], sum + state[1]]
}

#[field(bn254)]
pub fn mds_4(mut state: [Field; 4]) -> [Field; 4] {
    let t_0 = state[0] + state[1];
    let t_1 = state[2] + state[3];
    let t_2 = double(state[1]) + t_1;
    let t_3 = double(state[3]) + t_0;
    let t_4 = double(double(t_1)) + t_3;
    let t_5 = double(double(t_0)) + t_2;
    state[0] = t_3 + t_5;
    state[1] = t_5;
    state[2] = t_2 + t_4;
    state[3] = t_4;
    state
}
