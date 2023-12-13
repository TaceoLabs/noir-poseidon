# tests poseidon and poseidon2
test-all: test-poseidon test-poseidon2

# test poseidon
test-poseidon:
    cd poseidon && nargo test

# test poseidon2
test-poseidon2:
    cd poseidon2 && nargo test