{ lib
, stdenv
, fetchFromGitHub
, sqlite
}:
stdenv.mkDerivation {

  pname = "instantShell";
  version = "unstable";

  srcs = [ 
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantshell";
      rev = "a3348b1cc73deeea4fcdb7bdf7ae7ae15bc514cb";
      sha256 = "Z3Hy+cXY7aOND3MrAGeyGNwVMFXXccDr6q/PStiKUtE=";
      name = "instantOS_instantShell";
    })
    (fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "3f50482674c2b3153590a4aba92fbfa1c01bc583";
      sha256 = "KZ8cOIyBhaZ45NXTRlslY176ORwxTt5T0rkORm4J/fo=";
      name = "ohmyzsh";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    ls -lh
    cat instantOS_instantShell/zshrc >> ohmyzsh/templates/zshrc.zsh-template
    rm instantOS_instantShell/zshrc
  '';

  installPhase = ''
    install -Dm 755 instantOS_instantShell/instantshell.sh "$out/bin/instantshell"
    install -Dm 644 instantOS_instantShell/instantos.plugin.zsh $out/share/instantshell/custom/plugins/instantos/instantos.plugin.zsh
    install -Dm 644 instantOS_instantShell/instantos.zsh-theme $out/share/instantshell/custom/themes/instantos.zsh-theme
    install -Dm 644 instantOS_instantShell/zshrc $out/share/instantshell/zshrc || true
    cp -r ohmyzsh/* $out/share/instantshell
  '';

  meta = with lib; {
    description = "instantOS Shell";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantshell";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
