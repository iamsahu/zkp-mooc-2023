circom sudoku.circom --r1cs --wasm
snarkjs powersoftau new bn128 12 tmp.ptau
snarkjs powersoftau prepare phase2 tmp.ptau sudoku.ptau
rm tmp.ptau
snarkjs groth16 setup sudoku.r1cs sudoku.ptau sudoku.pk
snarkjs zkey export verificationkey sudoku.pk sudoku.vk
node sudoku_js/generate_witness.js sudoku_js/sudoku.wasm sudoku.input.json sudoku.witness
snarkjs groth16 prove sudoku.pk sudoku.witness sudoku.proof sudoku.inst.json
snarkjs groth16 verify sudoku.vk sudoku.inst.json sudoku.proof