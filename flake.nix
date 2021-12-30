{
  inputs = {
    nixpkgs.url = "github:NickCao/nixpkgs/riscv";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ rust-overlay.overlay ]; };
      in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            (rust-bin.nightly.latest.minimal.override {
              extensions = [ "llvm-tools-preview" ];
              targets = [ "riscv64imac-unknown-none-elf" ];
            })
            cargo-binutils
            pkgsCross.riscv64.buildPackages.binutils
          ];
        };
      });
}
