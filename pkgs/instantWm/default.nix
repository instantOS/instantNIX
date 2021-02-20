{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
, pavucontrol
, rofi
, rxvt_unicode
, st
, cantarell-fonts
#, joypixels
, instantAssist
, instantUtils
, instantDotfiles
, wmconfig ? null
, extraPatches ? []
, defaultTerminal ? st
}:
stdenv.mkDerivation {

  pname = "instantWm";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantWM";
    rev = "8b8d791c8136a5638469c811b70c8f8e83210fef";
    sha256 = "sha256-cOl8+k7CUwdCg5yr4XcYSivhE6mu5CV6ANSvSf2Nt/Y=";
    name = "instantOS_instantWm";
  };
  #src = ../../src/instantwm;

  patches = [ ] ++ extraPatches;

  postPatch =
  ( if builtins.isPath wmconfig then "cp ${wmconfig} config.def.h\n" else "" ) + 
  ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
    substituteInPlace config.def.h \
      --replace "\"pavucontrol\"" "\"${pavucontrol}/bin/pavucontrol\"" \
      --replace "\"rofi\"" "\"${rofi}/bin/rofi\"" \
      --replace "\"urxvt\"" "\"${rxvt_unicode}/bin/urxvt\"" \
      --replace "\"st\"" "\"${defaultTerminal}/bin/${builtins.head (builtins.match "(.*)-.*" defaultTerminal.name)}\"" \
      --replace /usr/share/instantassist/ "${instantAssist}/share/instantassist/" \
      --replace /usr/share/instantdotfiles/ "${instantDotfiles}/share/instantdotfiles/"
  '';

  nativeBuildInputs = [ gnumake ];
  buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];
  propagatedBuildInputs = [
    cantarell-fonts
    #joypixels
    pavucontrol
    rofi
    rxvt_unicode
    defaultTerminal
  ] ++
  [
    instantAssist
    instantUtils
  ];

  installPhase = ''
    install -Dm 555 instantwm $out/bin/instantwm
    install -Dm 555 startinstantos $out/bin/startinstantos
    install -Dm 555 instantwmctrl.sh $out/bin/instantwmctrl
  '';

  checkPhase = ''
    $out/bin/instantwm -V > /dev/null
  '';

  meta = with lib; {
    description = "Window manager of instantOS.";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ 
        maintainers.shamilton
        "con-f-use <con-f-use@gmx.net>"
        "paperbenni <instantos@paperbenni.xyz>"
    ];
    platforms = platforms.linux;
  };
}
