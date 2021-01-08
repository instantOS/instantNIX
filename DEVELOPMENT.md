Development Notes
=================

Just some random notes on Nix development in this repository

Commands
--------

### Debug a single package in nix-shell

```
nix-shell default.nix -A instantsettings
unpackPhase
cd $sourceDir
patchPhase
installPhase
```

