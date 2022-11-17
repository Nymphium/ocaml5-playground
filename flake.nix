{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    opam-repository = { url = "github:ocaml/opam-repository"; flake = false; };

    flake-utils.url = "github:numtide/flake-utils";

    opam-nix = {
      url = "github:tweag/opam-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        opam-repository.follows = "opam-repository";
      };
    };
  };
  outputs = { self, flake-utils, opam-nix, nixpkgs, ... }:
    let package = "ocaml5-playground";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};
        src = ./.;

        devPackages = {
          # ocaml-lsp-server = "*";
          # utop = "*";
        };

        scope = on.buildOpamProject' {
          inherit pkgs;
          resolveArgs = { with-test = true; };
        } src devPackages;

      in {
        legacyPackages = scope;
        packages.default = self.legacyPackages.${system}.${package};
        devShells.default =
          let
            ocamlformat = pkgs.callPackage ./nix/ocamlformat.nix { ocamlformat = ./.ocamlformat; };
          in
          pkgs.mkShell {
            inputsFrom = [ self.legacyPackages.${system}.${package} ];
            buildInputs = [ ocamlformat ]
              ++ (builtins.map
                (s: builtins.getAttr s self.legacyPackages.${system}.${package})
                (builtins.attrNames devPackages));
          };
    });
}
