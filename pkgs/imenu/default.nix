{ lib
, stdenv
, fetchFromGitHub
, instantMenu
}:
stdenv.mkDerivation {

  pname = "imenu";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "imenu";
    rev = "8e5b7eacce4eb5cf300d1d3158db9249958d7130";
    sha256 = "sha256-/OobJvHDWzuaE6zCO1nG/XQ7T0IU/hJUtqivLR3SZwU=";
    name = "instantOS_imenu";
  };

  propagatedBuildInputs = [
    instantMenu
  ];

  installPhase = ''
    install -Dm 555 imenu.sh $out/bin/imenu
  '';

  meta = with lib; {
    description = "instantOS imenu";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/imenu";
    maintainers = [ "con-f-use <con-f-use@gmx.net" ];
    platforms = platforms.linux;
  };
}
