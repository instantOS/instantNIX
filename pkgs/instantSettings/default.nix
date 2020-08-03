{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, instantAssist
, instantConf
, instantUtils
, instantWallpaper
, arandr
, arc-theme
, autorandr
, bc
, blueman
, firaCodeNerd
, gnome-disk-utility
, gufw
, hicolor-icon-theme
, lxappearance
, neovim
, papirus-icon-theme
, pavucontrol
, st
, system-config-printer
, udiskie
, xfce4-power-manager
}:
let
  utilities = [
    instantAssist
    instantUtils
    instantConf
    instantWallpaper
    arandr
    autorandr
    bc
    blueman
    gnome-disk-utility
    gufw
    lxappearance
    neovim
    pavucontrol
    st
    system-config-printer
    udiskie
    xfce4-power-manager
    firaCodeNerd
    papirus-icon-theme
    arc-theme
    hicolor-icon-theme
  ];
in
stdenv.mkDerivation {

  pname = "instantSettings";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantSETTINGS";
    rev = "46a2a2de7192abee98f6c37340af23079da2da1d";
    sha256 = "1fhbn5v2p8hfxjxvrx3v6sfx690kgzx765f69s463mb0pi75bm9h";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = utilities;

  postPatch = ''
    substituteInPlace settings.sh \
      --replace "/usr/share/instantassist" "$out/share/instantassist"
  '';

  installPhase = ''
    mkdir -p "$out/share/applications"
    cp *.desktop "$out/share/applications"
    install -Dm 555 settings.sh "$out/bin/instantsettings"
    ln -s "$out/bin/instantsettings" "$out/bin/instantos-control-center"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantsettings" \
      --prefix PATH : ${lib.makeBinPath utilities}
  '';

  meta = with lib; {
    description = "Simple settings app for instant-OS";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantSETTINGS";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
