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
, lxappearance-gtk3
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
    lxappearance-gtk3
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
    owner = "SCOTT-HAMILTON";
    repo = "instantSETTINGS";
    rev = "d17718ff2d9eedfee093c3d7efa41f24ab13d861";
    sha256 = "1n8lvz4jn4b0476rb45x5x8ps0041l3nsjvdvkxhkb3sv9s8scwp";
    name = "scotthamilton_instantSettings";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = utilities;

  postPatch = ''
    substituteInPlace settings.sh \
      --replace /opt/instantos/menus "${instantAssist}/opt/instantos/menus"
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
