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
      rev = "44e3d8264e69751f5a02d4e296185b377e47abd1";
      sha256 = "r3jxU/NEVPS5ASKtlhF85z2vCEMQ+hy5nueoBE2TLs0=";
      name = "instantOS_instantShell";
    })
    (fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "12669f29f0843b8b980dd137f150a74511f88842";
      sha256 = "K6NprlHprX3znsqgAXmlanb9tqED+EcLOZBuBgzvbB8=";
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
