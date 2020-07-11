{ lib
, stdenv
, fetchFromGitHub
, acpi
, conky
, dunst
, firefox
, libnotify
, neofetch
, nitrogen
, pciutils
, rangerplugins
, rofi
, st
, xfce4-power-manager
}:
stdenv.mkDerivation rec {

  pname = "instantUtils";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantOS";
    rev = "06baba865d5cf3413eb210e057e46cccf84267f8";
    sha256 = "0awa0hrvslglrnmrl9jzag87kpa045lwx4527pzj0h5clhbq7x2s";
  };

  postPatch = ''
    substituteInPlace programs/instantstartmenu \
      --replace "st -e" "${st}/bin/st -e" \
      --replace "st &" "${st}/bin/st &" \
      --replace "neofetch" "${neofetch}/bin/neofetch" \
      --replace "firefox" "${firefox}/bin/firefox"
    substituteInPlace programs/appmenu \
      --replace "#!/usr/bin/dash" "#!/bin/sh" \
      --replace "/usr/share/instantdotfiles/rofi/appmenu.rasi" "tmp_placeholder" \
      --replace rofi "${rofi}/bin/rofi" \
      --replace "tmp_placeholder" "\$(instantdata -d)/share/instantdotfiles/rofi/appmenu.rasi"
    substituteInPlace programs/ifeh \
      --replace "nitrogen" "${nitrogen}/bin/nitrogen"
    substituteInPlace autostart.sh \
      --replace "instantthemes" "\$(instantdata -t)/bin/instantthemes" \
      --replace "dunst" "${dunst}/bin/dunst" \
      --replace "instantshell" "\$(instantdata -s)/bin/instantshell" \
      --replace "instantdotfiles" "\$(instantdata -d)/bin/instantdotfiles" \
      --replace "conky -c" "${conky}/bin/conky -c" \
      --replace /usr/bin/instantstatus "$out/bin/instantstatus" \
      --replace /usr/share/instantutils "$out/share/instantutils" \
      --replace /usr/share/rangerplugins "${rangerplugins}/share/rangerplugins" \
      --replace /usr/share/instantwidgets "\$(instantdata -wi)/share/instantwidgets" \
      --replace /usr/share/instantwallpaper "\$(instantdata -wa)/share/instantwidgets" \
      --replace /opt/instantos/menus "\$(instantdata -a)/opt/instantos/menus" \
      --replace xfce4-power-manager "${xfce4-power-manager}/bin/xfce4-power-manager" \
      --replace notify-send "${libnotify}/bin/notify-send"
    substituteInPlace userinstall.sh \
      --replace "acpi" "${acpi}/bin/acpi" \
      --replace "lspci" "${pciutils}/bin/lspci"
    substituteInPlace install.sh \
      --replace /usr/share/instantutils "$out/share/instantutils"
    substituteInPlace instantutils.sh \
      --replace /usr/share/instantutils "$out/share/instantutils"
    substituteInPlace installinstantos.sh \
      --replace /usr/share/instantutils "$out/share/instantutils"
  '';
  
  installPhase = ''
    install -Dm 555 autostart.sh $out/bin/instantautostart
    install -Dm 555 status.sh $out/bin/instantstatus
    install -Dm 555 monitor.sh $out/bin/instantmonitor

    install -Dm 555 instantutils.sh $out/bin/instantutils
    install -Dm 555 installinstantos.sh $out/bin/installinstantos
    
    mkdir -p $out/share/instantutils
    chmod +x *.sh
    mv *.sh $out/share/instantutils
    chmod +x programs/*
    mv programs/* $out/bin

    mkdir -p $out/share/applications
    mv desktop/* $out/share/applications

    mkdir -p "$out/etc/X11/xorg.conf.d"
    mv xorg/* "$out/etc/X11/xorg.conf.d"
  '';

  propagatedBuildInputs = [ conky st neofetch firefox nitrogen acpi dunst rangerplugins xfce4-power-manager libnotify ];

  meta = with lib; {
    description = "instantOS Utils";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantOS";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
