# Insufficient Predicate Check

What is wrong with the following implementation of `OneToNine`?

```
template OneToNine()
{
    signal input in;
    signal out;
    if (in>=1 && in<=9 ){
       out <-- 1;
    }
    out === 1;
}
```

Explanation by @devesh:
The only constraint this code is checking is the following: the witness element "out == 1". It is not checking any predicate over the input in.
You have specified some computation which links in to out, but that is the computation that the prover performs as part of generating the witness, and a malicious prover can't be trusted to do it correctly.
think of it this way, the only thing a verifier can ensure is that the constraints are checked properly. So they need to be robust enough to handle all cheating strategies

## Cheating Strategy example:

#### Step 1:

Compiled the circuit and setup the system by executing the following steps using the above faulty implementation of `OneToNine` by using the following commands:

```
circom sudoku.circom --r1cs --wasm
snarkjs powersoftau new bn128 12 tmp.ptau
snarkjs powersoftau prepare phase2 tmp.ptau sudoku.ptau
rm tmp.ptau
snarkjs groth16 setup sudoku.r1cs sudoku.ptau sudoku.pk
snarkjs zkey export verificationkey sudoku.pk sudoku.vk
```

#### Step 2:

Remove the following section from `OneToNine` implementation:

```
if (in>=1 && in<=9 ){
  out <-- 1;
}
```

#### Step 3:

Change one of the solutions value to an invalid one and then generate the proof & verify by executing the following command:

```
circom sudoku.circom --r1cs --wasm
node sudoku_js/generate_witness.js sudoku_js/sudoku.wasm sudoku.input.json sudoku.witness &&
snarkjs groth16 prove sudoku.pk sudoku.witness sudoku.proof sudoku.inst.json &&
snarkjs groth16 verify sudoku.vk sudoku.inst.json sudoku.proof
```

---

Thanks to @devesh for the explanation. And @nono for bringing raising the question.
