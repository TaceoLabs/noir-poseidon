// Instantiations of Poseidon constants, permutations and sponge for prime field of the same order as BN254
mod perm;
mod perm3;
mod consts;

use consts::x5_3_config;

struct PoseidonBn254Config<T, RF, RP, T1, RE> {
    pre_round_constants: [[Field; T]; RF],
    opt_round_constants_half_round: [Field; T],
    opt_round_constants_full_round: [Field; RP],
    end_round_constants: [[Field; T]; RE],
    mi: [[Field; T];T],
    mds: [[Field; T]; T],
    v: [[Field; T1]; RP],
    w_hat: [[Field; T1]; RP],
}

#[field(bn254)]
fn permute_bn254<T, RF, RP, T1, RE>(mut state: [Field; T], config: PoseidonBn254Config<T, RF, RP, T1, RE>) -> [Field; T] {
    for i in 0..RF {
        state = vec_add(state, config.pre_round_constants[i]);
        state = sbox(state);
        state = mat_mul(state, config.mds);
    }
    state = vec_add(state, config.opt_round_constants_half_round);
    state = mat_mul(state, config.mds);

    for r in 0..RP - 1 {
        state[0] = sbox_e(state[0]);
        state[0] = state[0] + config.opt_round_constants_full_round[r];
        state = cheap_matmul(state, config.v[RP - r - 1], config.w_hat[RP - r -1], config.mds[0][0]);
    }
    state[0] = sbox_e(state[0]);
    state = cheap_matmul(state, config.v[0], config.w_hat[0], config.mds[0][0]);
    for r in 0..RE {
        state = vec_add(state, config.end_round_constants[r]);
        state = sbox(state);
        state = mat_mul(state, config.mds);
    }
    state
}

fn small_mds<T>(state: [Field; T])->[Field;T] {
    let sum = state.reduce(|a,b| a + b);
    let mut ret_val = [0; T];
    ret_val[0] = state[0] + sum;
    ret_val[1] = 2 * state[1] + sum;
    ret_val[2] = state[2] + sum;
    ret_val
}

fn cheap_matmul<T, T1>(mut state: [Field; T], v: [Field; T1], w_hat: [Field; T1], mds: Field) -> [Field; T] {
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

//TODO is this bn254 dependent??
fn mat_mul<T>(mut state: [Field; T], mds: [[Field; T]; T]) -> [Field; T] {
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

#[field(bn254)]
pub(crate) fn sbox<T>(mut state: [Field; T]) -> [Field; T] {
    //TODO play around with that, can we get lower constraints here?
    state.map(|x| sbox_e(x))
}

#[field(bn254)]
fn sbox_e(mut x: Field) -> Field {
    let mut result = x * x;
    result *= result;
    result * x
}

pub(crate) fn vec_add<T>(lhs: [Field; T], rhs: [Field; T]) -> [Field; T] {
    let mut result = [0; T];
    for i in 0..T {
        result[i] = lhs[i] + rhs[i];
    }
    result
}

pub fn x5_3(input: [Field; 3]) -> [Field; 3] {
    perm3::permute_3(input)
}

#[test]
fn test_perm() {
    let result = permute_bn254([0, 1, 2], x5_3_config());
    let should = [0x2e72c60509a284872f62830b58ed8524a58c362dd3ddb98b2767f36b566596bd,
        0x180a812301272545f79ae1012b0425162a1833ac39101e070732f4d8a8bc4718,
        0x1828343d70eed99aae404e3ea58209f45743f3d54983fe250ce1526a9d8cf88e];
  // let should = [0x1eca43adaa40dd2e3ab7eed8dadf345d05d9d0cbfc4580fe7c6d08c96f7718aa,
  //     0x2c94545a7f257006211a040c7d7dba6c5ebbc62dae694d4378df34ec1e22c282,
  //     0x2bfce23660c70dce9866f349c597eb2cbf07fe0c54d365eee0a3953349e3bb0d];
    assert(should == result);
}

#[test]
fn test_cheap_matmul_3() {
    let input= [0x128fc51db6db6faf3d3f9bdd492159874ec2678c08a11957003a3db50f6aab91,
        0x2f4fcaac2767a8403f5182e390caa199736557d73a72a52e9f1c1534236c4758,
        0x128823fdb71961eb8060a789d5a057996e7a04ab7bc32563a474395b3f8324fd];
    let should_result = [0x22b386d285f3c0433d0d1d7ebc62d87f573edbfbaf95d4040fb4f3d2601c6cb1,
        0x247f5feb93dec4460cec3efb5bdd75bb9fdfac8e7e9dd0a0a251b07a02372ca9,
        0x2b8bb1868c5f829c9da6ba6cc28ddb783247ec8ecd1e4a96401d10fe725f4465];
    let config = x5_3_config();
    let is_result = cheap_matmul(input, config.v[56], config.w_hat[56], config.mds[0][0]);
    assert(should_result == is_result);
}
