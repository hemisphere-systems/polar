{ unstable, ... }@inputs:
{ pkgs, ... }@args:

let
  unstable = unstable.legacyPackages.${pkgs.system};
in
{
  #inherit (unstable) _1password-gui _1password-cli;

  cargo-pgrx = import ./cargo-pgrx.nix inputs args;
}
