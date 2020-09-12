{ stdenv, fetchFromGitHub, pkgconfig, writeText, libX11, ncurses
, libXft, harfbuzz, firacodenerd, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "instantSt";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "st-instantos";
    rev = "36e9c06512a83220c1e598b0468ab8ad4f583849";
    sha256 = "1bgm0cpphzbrngbd2ybk5ldc95gwgvibgviykwck7v1rcrjc6n1p";
    name = "instantOS_instantST";
  };

  inherit patches;

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  postPatch = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft harfbuzz firacodenerd ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = "https://github.com/instantOS/st-instantos";
    description = "InstatOS terminal derived from suckless' st";
    license = licenses.mit;
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com" ]; 
    platforms = platforms.linux;
  };
}
