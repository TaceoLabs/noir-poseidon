pub mod poseidon;

pub fn mat_mul<let T: u32>(mut state: [Field; T], mat: [[Field; T]; T]) -> [Field; T] {
    let mut result = [0; T];
    for i in 0..T {
        for j in 0..T {
            result[i] += state[j] * mat[i][j];
        }
    }
    result
}

pub fn vec_add<let T: u32>(lhs: [Field; T], rhs: [Field; T]) -> [Field; T] {
    let mut result = [0; T];
    for i in 0..T {
        result[i] = lhs[i] + rhs[i];
    }
    result
}
fn double(x: Field) -> Field {
    2 * x
}

pub fn square(x: Field) -> Field {
    x * x
}
