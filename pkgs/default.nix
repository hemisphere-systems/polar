{ ... }@inputs:
{ pkgs, ... }@args:

let
  unfree = inputs.unfree.legacyPackages.${pkgs.system};
in
{
  inherit (unfree) _1password-gui _1password-cli discord;

  cargo-pgrx = import ./cargo-pgrx.nix inputs args;
}
