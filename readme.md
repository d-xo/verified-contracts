# Verified Contracts

This is a WIP collection of smart contracts that have been formally verfied using the
[act](https://github.com/ethereum/act) toolchain.

We aim to eventually include the following:

- tokens
  - erc20
  - erc721
  - erc6909
- utilities
  - fixed point (wad/ray) math
  - merkle proof verification
- apps
  - amm   : uni-v2 style amm
  - synth : collateral backed synthetic asset
  - sell  : nft auction contract

## Developing

```
# bring up development shell
nix develop

# bulid and verify all properties
make

# produce bytecode
make build

# verify functional correctness
make equiv

# verify safety properties
make safety

# verify economic properties
make economic
```
