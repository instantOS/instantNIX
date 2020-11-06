{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation {

  pname = "Paperbash";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "paperbenni";
    repo = "bash";
    rev = "77dfb51fd015bb9a4a8c967eef929c0c97bd61ab";
    sha256 = "sha256-S4M11K/892QcbxEBA07s1U7IS+fFNzenYmCLKiYUtSI=";
    name = "paperbenni_bash";
  };

  # postPatch = ''
  #   substituteInPlace programs/instantstartmenu \
  #     --replace "firefox" "${firefox}/bin/firefox"
  #   substituteInPlace programs/appmenu \
  #     --replace "tmp_placeholder" "${instantDotfiles}/share/instantdotfiles/rofi/appmenu.rasi"
  # '';

  installPhase = ''
    mkdir -p $out/share/paperbash
    cp -r * $out/share/paperbash
  '';

  meta = with lib; {
    description = "Collection of neat little bash functions, meant for use in Scripting";
    license = licenses.mit;
    homepage = "https://github.com/paperbenni/bash";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
