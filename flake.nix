{
  description = "Rust devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              (rust-bin.stable.latest.default.override {
                extensions = ["rust-analyzer"];
                targets = ["thumbv6m-none-eabi"];
              })
              probe-rs-tools
              flip-link
              fd
              bacon
              elf2uf2-rs
            ];

            shellHook = ''
            '';
          };
      }
    );
}