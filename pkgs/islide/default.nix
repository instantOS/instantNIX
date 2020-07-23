{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
, instantAssist
}:
stdenv.mkDerivation {

  pname = "islide";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "islide";
    rev = "97d272cc5498b9cae75cee8db0c9fddbaf475817";
    sha256 = "02c06g7xfnf3ciqd0b188hzjlvfk5kigcpp3scjnvnmcd9mhnrwa";
    name = "instantOS_islide";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/" "PREFIX = $out"
    substituteInPlace islide.c \
      --replace /opt/instantos/menus "${instantAssist}/opt/instantos/menus" \
  '';

  # installPhase = ''
  #   install -Dm 555 autostart.sh $out/bin/instantautostart
  #   install -Dm 644 desktop/st-luke.desktop $out/share/applications/st-luke.desktop
  # '';

  # propagatedBuildInputs = [ st instantDotfiles neofetch firefox nitrogen instantConf acpi instantThemes dunst instantShell rangerplugins ];
  # propagatedBuildInputs = [];
  nativeBuildInputs = [ gnumake ];
  buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];

  propagatedBuildInputs = [ instantAssist ];

  meta = with lib; {
    description = "instantOS Slide";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/islide";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
