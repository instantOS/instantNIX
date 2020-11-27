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
    rev = "6baddeb177f6c52984f4932aaaf7935ac5b828f3";
    sha256 = "sha256-ppZhVlIQAcC0n3aGLCdsalumd3EclrhUuP9NY7ZiMp0=";
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
