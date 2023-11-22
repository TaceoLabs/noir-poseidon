mod old_poseidon;
mod new_poseidon;

fn main(input: [Field; 3]) -> pub [Field; 3] {
    //old_poseidon::poseidon::bn254::perm::x5_3(input)
    new_poseidon::poseidon::bn254::x5_3(input)
}
