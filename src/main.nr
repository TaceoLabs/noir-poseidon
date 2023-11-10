mod old_poseidon;
mod new_poseidon;

fn main(x: [Field;3]) -> pub Field {
    new_poseidon::poseidon::bn254::hash_3(x)
}

#[test]
fn test_main() {
    let input = [1,2,3];
    assert(new_poseidon::poseidon::bn254::hash_3(input) ==
            old_poseidon::poseidon::bn254::hash_3(input)
    );

    // Uncomment to make test fail
    // main(1, 1);
}
