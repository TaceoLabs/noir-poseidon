# tests poseidon, poseidon2, and eddsa_poseidon2
test-all: test-poseidon test-poseidon2 test-eddsa-poseidon2

# test poseidon
test-poseidon:
    cd poseidon && nargo test

# test poseidon2
test-poseidon2:
    cd poseidon2 && nargo test

# test eddsa_poseidon2
test-eddsa-poseidon2:
    cd eddsa_poseidon2 && nargo test