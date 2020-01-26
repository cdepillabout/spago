let
  # haskell.nix master as of 2019-12-11
  haskell-nix = import (builtins.fetchTarball {
    url = https://github.com/input-output-hk/haskell.nix/archive/dbb83a4c7071f8e5ed9575267fbe4539c15e35df.tar.gz;
    sha256 = "sha256:1mz7kr45061c5hfvmmk4r2vbipzsg19p3whcy6y0z41ngrx0idkl";
  });

  # nixpkgs master as of 2020-01-26
  nixpkgs-src = builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/ba8fbd5352b8aca9410b10c8aa78e84740529e87.tar.gz;
    sha256 = "sha256:0sanh2h4h60ir6mg12m6ckqamzgnipfdkszg1kl4qv39hdmy9xzm";
  };

  nixpkgs = import nixpkgs-src {
    config = haskell-nix.config;
    overlays = haskell-nix.overlays ++ [ (import ./spago-overlay.nix) ];
  };
in

# nixpkgs.hs-pkgs.spago.components.library

nixpkgs
