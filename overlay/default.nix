{ rust, ... }@inputs:
{ lib, ... }@args:

let
  overlay = final: prev: import ../pkgs inputs (args // { pkgs = final; });
in
lib.composeManyExtensions [
  rust.overlays.default
  overlay
]
