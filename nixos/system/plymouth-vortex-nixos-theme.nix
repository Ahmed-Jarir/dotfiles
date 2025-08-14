{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
	name = "sddm-sugar-candy";
    installPhase = ''

        runHook preInstall
        mkdir -p $out/share/plymouth/themes/vortex-ubuntu
        cp vortex-ubuntu/* $out/share/plymouth/themes/vortex-ubuntu
        substituteInPlace $out/share/plymouth/themes/vortex-ubuntu/vortex-ubuntu.plymouth \
          --replace-fail "/usr/" "$out/"
        runHook postInstall

        cp ${../../wallpapers/rocky-mountain-village.png} $out/Backgrounds/Background.png
        rm theme.conf
        cp ${./sugar-candy.conf} $out/theme.conf
	'';

	src = fetchFromGitHub {
		owner = "emanuele-scarsella";
		repo = "vortex-ubuntu-plymouth-theme";

		rev = "5b3c88102fd8f322626c01514deedd7ba8e7ebdd";
		sha256 = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
	};
}
