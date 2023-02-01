pragma circom 2.1.2;

template NonEqual() {
    signal input in0;
    signal input in1;
    signal inverse;
    inverse <-- 1/ (in0-in1);
    inverse * (in0 - in1) === 1;
}

template Distinct(n) {
    signal input in[n];
    component nonEqual[n][n];
    for(var i =0; i<n;i++){
        for(var j =0; j<n;j++){
            nonEqual[i][j] = NonEqual();
            nonEqual[i][j].in0 <== in[i];
            nonEqual[i][j].in1 <== in[j];
        }    
    }
}

// Enforce that 1 <= in <= 16
template Bits4() {
    signal input in;
    signal bits[4];
    var bitsum = 0;
    for (var i = 0; i < 4; i++) {
        bits[i] <-- (in >> i) & 1;
        bits[i] * (bits[i] - 1) === 0;
        bitsum = bitsum + 2 ** i * bits[i];
    }
    bitsum === in;
}

// Enforce that 1 <= in <= 9
template OneToNine() {
    signal input in;
    component lowerBound = Bits4();
    component upperBound = Bits4();
    lowerBound.in <== in - 1; // We check that in - 1 is in [0, 15]
    upperBound.in <== in + 6; // We check that in + 6 is in [0, 15]
}

template Sudoku(n) {
    signal input solution[n][n];
    signal input puzzle[n][n];

    component inRange[n][n];
    component distinctRow[n];

    for(var i =0; i < n; i++){
        distinctRow[i] = Distinct(n);
        distinctRow[i].in <== solution[i];
        for(var j =0; j<n;j++){
            inRange[i][j] = OneToNine();
            inRange[i][j].in <== solution[i][j];
            puzzle[i][j] * (puzzle[i][j] - solution[i][j]) === 0;
        }    
    }
}

component main { public[ puzzle ] }= Sudoku(9);
