{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
, pavucontrol
, rofi
, rxvt_unicode
, st
, instantAssist
, instantUtils
, extraPatches ? []
}:
stdenv.mkDerivation rec {

  pname = "instantWm";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantWM";
    rev = "847e9f78fab4448186b42420283d6298c361d889";
    sha256 = "14pfg18xa96m2dpszdq6c9kg6rlfpj3y64pm5nxy2jy5mimdrw2n";
  };

  patches = [
    ./config_def_h.patch
  ] ++ extraPatches;

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
    substituteInPlace instantwm.c \
      --replace "cd /usr/bin; ./instantautostart &" "${instantUtils}/bin/instantautostart &"
    substituteInPlace config.def.h \
      --replace "\"pavucontrol\"" "\"${pavucontrol}/bin/pavucontrol\"" \
      --replace "\"rofi\"" "\"${rofi}/bin/rofi\"" \
      --replace "\"urxvt\"" "\"${rxvt_unicode}/bin/urxvt\"" \
      --replace "\"st\"" "\"${st}/bin/st\"" \
      --replace /opt/instantos/menus "${instantAssist}/opt/instantos/menus"
  '';

  nativeBuildInputs = [ gnumake ];
  buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];
  propagatedBuildInputs = [ 
    pavucontrol
    rofi
    rxvt_unicode
    st
  ] ++
  [
    instantAssist
    instantUtils
  ];

  installPhase = ''
    install -Dm 555 instantwm $out/bin/instantwm
    install -Dm 555 startinstantos $out/bin/startinstantos
  '';

  meta = with lib; {
    description = "Window manager of instantOS.";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
