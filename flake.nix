{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    foundry.url = "github:shazow/foundry.nix/monthly";
    act.url = "github:ethereum/act";
  };

  outputs = inp:
    inp.utils.lib.eachDefaultSystem (system:
      let pkgs = import inp.nixpkgs { inherit system; };
      in {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            inp.foundry.defaultPackage.${system}
            inp.act.packages.${system}.default
          ];
        };
      });
}
