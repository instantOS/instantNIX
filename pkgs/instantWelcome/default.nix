{ lib
, buildPythonApplication
, fetchFromGitHub 
, pygobject3
, instantConf
, wrapGAppsHook
, gobject-introspection
, pango
, gdk-pixbuf
, atk
}:
let
  pyModuleDeps = [
    pygobject3
  ];
  gnomeDeps = [
    wrapGAppsHook 
    gobject-introspection
    atk
    gdk-pixbuf
    pango
  ];
in
buildPythonApplication {
  pname = "instantWelcome";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "SCOTT-HAMILTON";
    repo = "instantWELCOME";
    rev = "d3152445de8509c6460dd0ffec3f23ace9af707a";
    sha256 = "YxHZhQkurQTcs4IC+Ij9HxGZrXQ6bRkT0Vy+9vlNOP8=";
    name = "instantOS_instantWelcome";
  };

  postPatch = ''
    patchShebangs instantWELCOME/welcome.sh
    substituteInPlace instantWELCOME/welcome.py \
      --replace welcome.glade  "$out/share/welcome.glade"
  '';

  nativeBuildInputs = gnomeDeps;
  buildInputs = pyModuleDeps ;
  propagatedBuildInputs = pyModuleDeps;

  doCheck = false;

  postInstall = ''
    mkdir -p "$out/bin"
    ln -s "$out/lib/python3.7/site-packages/instantWELCOME/welcome.sh" "$out/bin/instantwelcome"
    install -Dm 644 instantWELCOME/welcome.glade "$out/share/welcome.glade"
    install -Dm 644 instantWELCOME/instantwelcome.desktop "$out/share/applications/instantwelcome.desktop"
  '';

  meta = with lib; {
    description = "Welcome app for instantOS";
    license = licenses.mit;
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
