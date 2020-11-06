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
    rev = "f4f7f0fa1470e82f51aceb0d61c863f0942ee5ef";
    sha256 = "sha256-qjWpa5x5HSReRHps+/3tDOxt+TYvqYOkAIys2GvyHoo=";
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
