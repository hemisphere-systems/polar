{ affinity, ... }@inputs:
{ pkgs, ... }@args:

{
  cargo-pgrx = import ./cargo-pgrx.nix inputs args;

  affinity-designer = affinity.packages.${pkgs.system}.designer;
  affinity-photo = affinity.packages.${pkgs.system}.photo;
  affinity-publisher = affinity.packages.${pkgs.system}.publisher;
}
