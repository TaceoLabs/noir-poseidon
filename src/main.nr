mod old_poseidon;
mod new_poseidon;
use new_poseidon::poseidon2::bn254::x5_4;
use dep::std::println;

fn main() {
    let test = x5_4([1, 0, 0, 0]);
    println(test);
    //old_poseidon::poseidon::bn254::perm::x5_2(input)
    //new_poseidon::poseidon::bn254::x5_2(input)
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
