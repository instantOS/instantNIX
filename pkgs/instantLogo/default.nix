{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
}:
stdenv.mkDerivation {

  pname = "instantLogo";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantLOGO";
    rev = "f44d82d8179ccdf8c9393804597af7b9845d4a4b";
    sha256 = "162v4gk2kcgb9bqxfzclla1pmqiszs11f3hqqpihqpzndibac49h";
    name = "instantOS_instantLogo";
  };

  installPhase = ''
    install -Dm 644 wallpaper/readme.jpg $out/share/backgrounds/readme.jpg
  '';

  meta = with lib; {
    description = "Logo assets of instantOS.";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
