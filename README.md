# nur-packages-template

**InstantOS Nix repository**

## Setup

1. Fork this repo
2. Add your packages to the [pkgs](./pkgs) directory and to
   [default.nix](./default.nix)
   * Remember to mark the broken packages as `broken = true;` in the `meta`
     attribute, or travis (and consequently caching) will fail!
   * Library functions, modules and overlays go in the respective directories
3. Add your NUR repo name and your cachix repo name (optional) to
   [.travis.yml](./.travis.yml)
4. Enable travis for your repo
   * You can add a cron job in the repository settings on travis to keep your
     cachix cache fresh
5. Change your travis and cachix names on the README template section and delete
   the rest
6. [Add yourself to NUR](https://github.com/nix-community/NUR#how-to-add-your-own-repository)

## README template

[![Build Status](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages.svg?branch=master)](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages)
[![Cachix Cache](https://img.shields.io/badge/cachix-<YOUR_CACHIX_CACHE_NAME>-blue.svg)](https://<YOUR_CACHIX_CACHE_NAME>.cachix.org)


