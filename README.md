# Artifact for Demand m-CFA

- Supports a subset of R6RS (no set!)
- Supports a subset of Plait (#lang racket/plait)

Context sensitivity is in the m-CFA style (last `m` stack frames).
Implementation uses an ADI style recursive decent big-step interpreter.

## Definitions
Demand-scalable - a constant cost (time / codeunit) gives nontrivial flow information, regardless of program size

## Building / Reproducing

### Compiling the paper and graphs

Make sure texlive is installed `sudo apt install texlive-full` and `racket` (https://download.racket-lang.org/)
```bash
make
```

## Results




### Scalability
### Precision