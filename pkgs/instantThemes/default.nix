{ lib
, stdenv
, fetchFromGitHub
, Paperbash
}:
stdenv.mkDerivation {

  pname = "instantThemes";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantTHEMES";
    rev = "4937f346e481c7d18194d8d84b7f300b71cf2fa2";
    sha256 = "Cd1C5j2NDY2nvM9Apc700bATP0a92HWED0oJBgKUieA=";
    name = "instantOS_instantThemes";
  };

  postPatch = ''
    substituteInPlace instantthemes \
      --replace "/usr/share/instantthemes" "$out/share/instantthemes" \
      --replace "/usr/share/paperbash" "${Paperbash}/share/paperbash"
    '';

  installPhase = ''
    install -Dm 555 instantthemes $out/bin/instantthemes
    mkdir -p $out/share/instantthemes
    cp -r * $out/share/instantthemes
  '';

  propagatedBuildInputs = [ Paperbash ];

  meta = with lib; {
    description = "instantOS Themes";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantTHEMES";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
