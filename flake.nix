{
  description = "Userspace tools for bcachefs";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, utils, ... }:
    {
      overlays.default = final: prev: {
        bcachefs = final.callPackage ./build.nix { };
      };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in {
        packages = {
          inherit (pkgs) bcachefs;
          default = pkgs.bcachefs;
        };

        formatter = pkgs.nixfmt;
      });
}
