
self: super:

let

  inherit (self.haskell-nix) stackProject;
  inherit (self.haskell-nix.haskellLib) cleanGit;

  docsSearchAppJsFile = self.fetchurl {
    url = "https://github.com/spacchetti/purescript-docs-search/releases/download/v0.0.5/docs-search-app.js";
    sha256 = "11721x455qzh40vzfmralaynn9v8b5wix86r107hhs08vhryjib2";
  };

  purescriptDocsSearchFile = self.fetchurl {
    url = "https://github.com/spacchetti/purescript-docs-search/releases/download/v0.0.5/purescript-docs-search";
    sha256 = "16p1fmdvpwz1yswav8qjsd26c9airb22xncqw1rjnbd8lcpqx0p5";
  };

  spago-cleaned-source =
    let orig-src = cleanGit { src = ../.; };
    in
    self.runCommand "fixup-spago-source" {} ''
      mkdir -p "$out"
      cp -r "${orig-src}"/. "$out"
      chmod -R +w "$out"

      # The source for spago is pulled directly from GitHub.  It uses a
      # package.yaml file with hpack, not a .cabal file.  In the package.yaml file,
      # it uses defaults from the master branch of the hspec repo.  It will try to
      # fetch these at build-time (but it will fail if running in the sandbox).
      #
      # The following line modifies the package.yaml to not pull in
      # defaults from the hspec repo.
      substituteInPlace "$out/package.yaml" --replace 'defaults: hspec/hspec@master' ""

      # Spago includes the following two files directly into the binary
      # with Template Haskell.  They are fetched at build-time from the
      # `purescript-docs-search` repo above.  If they cannot be fetched at
      # build-time, they are pulled in from the `templates/` directory in
      # the spago source.
      #
      # However, they are not actually available in the spago source, so they
      # need to fetched with nix and put in the correct place.
      # https://github.com/spacchetti/spago/issues/510
      cp ${docsSearchAppJsFile} "$out/templates/docs-search-app.js"
      cp ${purescriptDocsSearchFile} "$out/templates/purescript-docs-search"
    '';

  hs-pkgs = stackProject {
    src = spago-cleaned-source;
    ghc = self.buildPackages.pkgs.haskell-nix.compiler.ghc865;
    modules = [
      ({pkgs,...}: {
        # Error with the haddocks in the fail library.
        packages.fail.doHaddock = false;
        # Error with the haddocks in the github library.
        packages.github.doHaddock = false;
      })
    ];
  };
in
{
  inherit hs-pkgs spago-cleaned-source;
}


