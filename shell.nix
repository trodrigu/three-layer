# shell.nix
let
  project = import ./default.nix;
  sources = import ./nix/sources.nix {};
  haskellNix = import sources.haskellNix {};
  # If haskellNix is not found run:
  #   niv add input-output-hk/haskell.nix -n haskellNix

  # Import nixpkgs and pass the haskell.nix provided nixpkgsArgs
  pkgs = import
    # haskell.nix provides access to the nixpkgs pins which are used by our CI,
    # hence you will be more likely to get cache hits when using these.
    # But you can also just use your own, e.g. '<nixpkgs>'.
    haskellNix.sources.nixpkgs-2009
    # These arguments passed to nixpkgs, include some patches and also
    # the haskell.nix functionality itself as an overlay.
    haskellNix.nixpkgsArgs;
in
  project.shellFor {
    # Builds a Hoogle documentation index of all dependencies,
    # and provides a "hoogle" command to search the index.
#    withHoogle = true;

    # Some common tools can be added with the `tools` argument
#    tools = {
#      cabal = "3.2.0.0";
#      hlint = "latest"; # Selects the latest version in the hackage.nix snapshot
#      haskell-language-server = "latest";
#    };
    # See overlays/tools.nix for more details

    # Some you may need to get some other way.
#    buildInputs = [ (import <nixpkgs> {}).git ];
    buildInputs = [
      pkgs.postgresql
    ];

    # Sellect cross compilers to include.
#    crossPlatforms = ps: with ps; [
#      ghcjs      # Adds support for `js-unknown-ghcjs-cabal build` in the shell
#      # mingwW64 # Adds support for `x86_64-W64-mingw32-cabal build` in the shell
#    ];

    # Prevents cabal from choosing alternate plans, so that
    # *all* dependencies are provided by Nix.
#    exactDeps = true;
  }