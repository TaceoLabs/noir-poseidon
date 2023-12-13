mod old_poseidon;
mod new_poseidon;
use new_poseidon::poseidon2::bn254::x5_4;
use dep::std::println;

fn main(input: [Field; 16]) -> pub [Field; 16] {
    //old_poseidon::poseidon::bn254::perm::x5_16(input)
    //new_poseidon::poseidon::bn254::x5_16(input)
    new_poseidon::poseidon2::bn254::x5_16(input)
}
