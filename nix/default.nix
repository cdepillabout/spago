let
  # haskell.nix master as of 2019-12-11
  haskell-nix = import (builtins.fetchTarball {
    url = https://github.com/input-output-hk/haskell.nix/archive/3dd555bcc1f986ad23b7fd75ae4ab5dc15f2c48b.tar.gz;
    sha256 = "sha256:1p8paz9ls9mdlm606ivrddc1s087fv1bgdayww4bvr7fnwjgj4d4";
  });

  # nixpkgs master as of 2020-01-03
  nixpkgs-src = builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/7e8454fb856573967a70f61116e15f879f2e3f6a.tar.gz;
    sha256 = "sha256:0lnbjjvj0ivpi9pxar0fyk8ggybxv70c5s0hpsqf5d71lzdpxpj8";
  };

  nixpkgs = import nixpkgs-src {
    config = haskell-nix.config;
    overlays = haskell-nix.overlays ++ [ (import ./spago-overlay.nix) ];
  };
in

# nixpkgs.hs-pkgs.spago.components.library

nixpkgs
