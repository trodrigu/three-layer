let
  # Read in the Niv sources
  sources = import ./nix/sources.nix {};
  # If ./nix/sources.nix file is not found run:
  #   niv init
  #   niv add input-output-hk/haskell.nix -n haskellNix

  # Fetch the haskell.nix commit we have pinned with Niv
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
haskellNix.stackProject' {
  src = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "three-layer";
    src = ./.;
  };

  modules = [
    {
      # learn about nonReinstallablePkgs they seem useful for caching
      # nonReinstallablePkgs =
      #    [ "rts" "ghc-heap" "ghc-prim" "integer-gmp" "integer-simple" "base"
      #      "deepseq" "array" "ghc-boot-th" "pretty" "template-haskell"
      #      "ghc-boot"
      #      "ghc" "Cabal" "Win32" "array" "binary" "bytestring" "containers"
      #      "directory" "filepath" "ghc-boot" "ghc-compact" "ghc-prim"
      #      "ghci" "haskeline"
      #      "hpc"
      #      "mtl" "parsec" "process" "text" "time" "transformers"
      #      "unix" "xhtml"
      #      "stm" "terminfo"
      #    ];

    }
  ]
}
#in pkgs.haskell-nix.project {
#  # 'cleanGit' cleans a source directory based on the files known by git
#  src = pkgs.haskell-nix.haskellLib.cleanGit {
#    name = "three-layer";
#    src = ./.;
#  };
#  # Specify the GHC version to use.
#  # compiler-nix-name = "ghc8102"; # Not required for `stack.yaml` based projects.
#}
