{ crane, ... }:

{ pkgs, lib, ... }:

let
  rustToolchain = pkgs.rust-bin.stable.latest.minimal;
  craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
in
craneLib.buildPackage {
  #src = ./.;

  inherit (craneLib.crateNameFromCargoToml { cargoToml = ./cargo-pgrx/Cargo.toml; }) pname version;

  cargoExtraArgs = "--package cargo-pgrx";
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs =
    [ pkgs.openssl ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pkgs.darwin.apple_sdk.frameworks.Security
      pkgs.libiconv
    ];
  # fixes to enable running pgrx tests
  preCheck = ''
    export PGRX_HOME=$(mktemp -d)
  '';
  # skip tests that require pgrx to be initialized using `cargo pgrx init`
  cargoTestExtraArgs = "-- --skip=command::schema::tests::test_parse_managed_postmasters";
}
