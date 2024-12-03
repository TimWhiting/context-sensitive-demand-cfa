# Artifact for Demand m-CFA

- Supports a subset of R6RS (no set!)
- Contains installer for our fork of the Koka compiler + VSCode extension for Demand Analysis in a Language Server

Context sensitivity is in the m-CFA style (last `m` stack frames).
Implementation uses an ADI style recursive descent big-step interpreter.

## Building / Reproducing

### Compiling the paper and graphs

Make sure texlive is installed `sudo apt install texlive-full` and `racket` (https://download.racket-lang.org/)
```bash
make
```



Cleanup TODO:
- Add more details to readme, including plots
- Add Koka installer and bundles, and instructions for setting up the VSCode extension (add a gif of the extension in action)
- Add note about reachability / dependency tracking