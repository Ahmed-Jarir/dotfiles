{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
	name = "sddm-sugar-candy";
    installPhase = ''
		mkdir -p $out
		cp -R ./* $out/
        cp ${../../wallpapers/rocky-mountain-village.png} $out/Backgrounds/Background.png
        rm theme.conf
        cp ${./sugar-candy.conf} $out/theme.conf
	'';

	src = fetchFromGitHub {
		owner = "Kangie";
		repo = "sddm-sugar-candy";

		rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
		sha256 = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
	};
}
