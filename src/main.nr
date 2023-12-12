mod old_poseidon;
mod new_poseidon;

fn main(input: [Field; 2]) -> pub [Field; 2] {
    //old_poseidon::poseidon::bn254::perm::x5_2(input)
    new_poseidon::poseidon::bn254::x5_2(input)
    //old_poseidon::poseidon::bn254::perm::x5_3(input)
    //new_poseidon::poseidon::bn254::x5_3(input)
    //old_poseidon::poseidon::bn254::perm::x5_4(input)
    //new_poseidon::poseidon::bn254::x5_4(input)
    //old_poseidon::poseidon::bn254::perm::x5_5(input)
    //new_poseidon::poseidon::bn254::x5_5(input)
    //old_poseidon::poseidon::bn254::perm::x5_6(input)
    //new_poseidon::poseidon::bn254::x5_6(input)
    //old_poseidon::poseidon::bn254::perm::x5_8(input)
    //new_poseidon::poseidon::bn254::x5_8(input)
}
