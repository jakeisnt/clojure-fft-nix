with import <nixpkgs> {};
let
  buildLeinFromGitHub = { name, owner, repo, rev, sha256, cd }:
  stdenv.mkDerivation {
    name = name;
    src = fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
      buildInputs = [ leiningen ];
      buildPhase = ''
        # https://blog.jeaye.com/2017/07/30/nixos-revisited/
        export LEIN_HOME=$PWD/.lein
        mkdir -p $LEIN_HOME
        echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj
        cd ${cd}
        LEIN_SNAPSHOTS_IN_RELEASE=1 ${leiningen}/bin/lein uberjar
      '';
      installPhase = ''
        cp target/${repo}*-standalone.jar $out
      '';
  };

  tesser = buildLeinFromGitHub {
    name = "tesser";
    owner = "aphyr";
    repo = "tesser";
    rev = "b7b67dfaf25f1764c70c90dc6681dd333d24d6a4";
    sha256 = "1vma6ram4qs7llnfn84d4xvpn0q7kmzmkmsjpnkpqnryff9w2gvr";
    cd = "core";
  };

  matrix = buildLeinFromGitHub {
    name = "matrix";
    owner = "mikera";
    repo = "core.matrix";
    rev = "f864c29d4e85d35de018295a87a295fc3df632a6";
    sha256 = "1dywj2av5rwnv7qhh09lpx9c2kx7wvgllwyssvyr75cb6fa6smvg";
    cd = ".";
  };

in
  stdenv.mkDerivation rec {
    name = "diaconis.clj";
    src = ./.;
    buildInputs = [ clojure jdk ];
    shellHook = ''
    it () {
      java -cp ${tesser}:${matrix} clojure.main ${name}
    }
    '';
  }
