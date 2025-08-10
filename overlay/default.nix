{ rust, ... }@inputs:
{ lib, ... }@args:

let
  overlay = final: prev: import ../pkgs inputs (args // { pkgs = final; });
in
lib.composeExtensions rust.overlays.default overlay
