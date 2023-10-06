{ lib
, stdenv
, fetchFromGitHub
, sqlite
}:
stdenv.mkDerivation {

  pname = "instantConf";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantconf";
    rev = "0449f4be7582abec0307fb0be9132cc7130b8979";
    hash = "sha256-9ebY874ngGJSR73lAmxt5Q4FLh7x3dm8fLHql/rGL0I=";
    name = "instantOS_instantConf";
  };

  postPatch = ''
    substituteInPlace instantconf.sh \
      --replace sqlite3 "${lib.getBin sqlite}/bin/sqlite3"
  '';

  buildPhase = "true";

  installPhase = ''
    install -Dm 555 instantconf.sh $out/bin/instantconf
    ln -s $out/bin/instantconf $out/bin/iconf
  '';

  propagatedBuildInputs = [ sqlite ];

  meta = with lib; {
    description = "instantOS Conf";
    license = licenses.gpl2;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
