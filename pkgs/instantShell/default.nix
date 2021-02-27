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
      rev = "11c89b29d751e22fae072e46044c0ff1b4c7bfb8";
      sha256 = "sha256-ut2D7lYzqUk49BcALXnTQRGUcerSrGwL6ozui4549gU=";
      name = "instantOS_instantShell";
    })
    (fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "9a9f3831925432fdf4352c24a002506a06d329c1";
      sha256 = "sha256-befalsEX/o5WwVn0bzDnMVhlZawmpGV4AGzvxl7UHLI=";
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
    ls -al instantOS_instantShell/
    #install -Dm 644 instantOS_instantShell/zshrc $out/share/instantshell/zshrc
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
