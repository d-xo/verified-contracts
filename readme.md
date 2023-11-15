# Verified Contracts

This is a WIP collection of smart contracts that have been formally verfied using the
[act](https://github.com/ethereum/act) toolchain. The act syntax in this repo is currently not
supported by the existing toolchain and at this point in time functions more as concept art to guide
development of the tool.

We aim to eventually include the following contracts:

```
- tokens
  - erc20   : erc20 with admin controlled mint/burn
  - erc721  : nft contract
  - erc6909 : multi-token contract
- utilities
  - wards   : multi-user auth
  - math    : fixed point (wad/ray) math
  - merkle  : merkle proof verification
- apps
  - amm     : uni-v2 style amm
  - synth   : collateral backed synthetic asset
  - sell    : nft auction
```

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
