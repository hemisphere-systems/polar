{
  description = "Polar is a Hemisphere's Nix Overlay and Package Distribution Mechanism";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    crane.url = "github:ipetkov/crane";

    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity.url = "github:mrshmllow/affinity-nix";

    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      utils,
      nixpkgs,
      ...
    }@inputs:

    utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        lib = nixpkgs.lib;

        args = { inherit pkgs lib system; };

        callPkg = import ./callPkg.nix inputs;

        packages = import ./pkgs inputs (args // { inherit callPkg; });
        checks = utils.lib.flattenTree packages;
      in
      {
        inherit packages checks;
      }
    )
    // {
      overlays.default = import ./overlay inputs { inherit (nixpkgs) lib; };
      lib = import ./lib inputs;
    };
}
