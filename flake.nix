{
  description = "Polar is a Hemisphere's Nix Overlay and Package Distribution Mechanism";

  inputs = {
    unstable.url = "nixpkgs/nixpkgs-unstable";

    unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "unstable";
    };

    crane.url = "github:ipetkov/crane";

    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "unstable";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      utils,
      unstable,
      ...
    }@inputs:

    utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = import unstable {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };

        lib = unstable.lib;

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
      lib = import ./lib inputs;
      overlays.default = import ./overlay inputs { inherit (unstable) lib; };
      nixosModules.default =
        { ... }:
        {
          nixpkgs.overlays = [ self.overlays.default ];
        };
    };
}
