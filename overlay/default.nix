{ rust, ... }@inputs:
{ lib, ... }@args:

let
  overlay = final: prev: {
    cargo-pgrx = import ../pkgs/rust inputs args // {
      pkgs = final;
    };
  };
in
lib.composeManyExtensions [
  rust.overlays.default
  overlay
]
