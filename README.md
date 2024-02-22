# Artifact for Demand m-CFA

- Supports a subset of R6RS
- Supports a subset of Plait (#lang racket/plait)

Context sensitivity is in the m-CFA style (last `m` stack frames).
Implementation uses an ADI style recursive decent big-step interpreter.

## Definitions
Demand-scalable - a constant cost (time / codeunit) gives nontrivial flow information, regardless of program size

## Building / Reproducing

### Compiling the paper and graphs

Make sure textlive is installed `sudo apt install textlive-full` 
```bash
make
```

## Results

Research Question:
Does adding m-CFA style context sensitivity to Demand-CFA give more precise results while remaining demand-scalable?


### Scalability
1. m-CFA scalability - program size vs time for m=0,1,2
2. Demand m-CFA scalability - timeout vs % nontrivial queries answered (information gained beyond compiler heuristics), series based on a few preset time per code unit values. Graphs for m=0,1,2,3,4,?

### Precision
3. Script `main-precision.rkt` checks that precision of Demand-mCFA results are equal to exhaustive exponential m-CFA
4. Reports % results that are singletons across all program points (TODO: omit nontrivial queries?), for m-CFA, exponential m-CFA, and Demand m-CFA (due to the previous the results of Demand m-CFA should equal exhaustive m-CFA) 