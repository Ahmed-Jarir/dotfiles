{ stdenv, fetchFromGitLab }:
stdenv.mkDerivation rec {
  name = "sddm-sugar-candy";
  # latest master commit, no recent tags :(
  dontBuild = true;
  installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-candy
    '';
  patches = [ ./sugar-candy-conf.patch ];
  src = fetchFromGitLab {
    owner = "Kangie";
    repo = "sddm-sugar-candy";

    rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
    sha256 = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
  };
}
