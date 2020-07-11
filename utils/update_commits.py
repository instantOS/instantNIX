#!/usr/bin/env python3
"""Update hashes in nix files for fetchFromGitHub commands.

Usage:
    {} [options] [file|directory]...

Options:
    -h  --help   Print this helptext
"""

import sys, os, re, subprocess
from pathlib import Path as P
#import requests

rex_fetch = re.compile(
     # Find fetchFromGitHub lines in nix expressions (in lieu of a Nix AST)
     # ToDo: account for possible comments
    r"""
        fetchFromGitHub\s+{\s*(
          (\#[^\S\n\r]*update_rev:[^\S\n\r]*(?P<update_rev>[\w-]+)\s*\n\s* )|
          (?P<fullowner>  owner  \s* = \s* "(?P<owner>[\w-]+)"  \s* ; \s* )|
          (?P<fullrepo>   repo   \s* = \s* "(?P<repo>[\w-]+)"   \s* ; \s* )|
          (?P<fullrev>    rev    \s* = \s* "(?P<rev>[\w-]+)"    \s* ; \s* )|
          (?P<fullname>   name   \s* = \s* "(?P<name>[\w=]+)"     \s* ; \s* )|
          (?P<fullsha256> sha256 \s* = \s* "(?P<sha256>[\w=]+)"   \s* ; \s* )
        )+}
    """,
    re.MULTILINE | re.VERBOSE
)

def process_file(fl):
    text = fl.read_text()
    fetches = filter(None, rex_fetch.finditer(text))
    for fetch in fetches:
        print(f'{fetch["owner"]}/{fetch["repo"]}')


def walk_dir(dirs=None):
    if not dirs:
        dirs = ["./"]

    for dir_ in dirs:
        for fl in P(dir_).rglob("*.nix"):
            if fl.is_file():
                process_file(fl)


def main(args=None):
    args = args or sys.argv[1:]

    if any(x in args for x in ['-h', '--help', '-?', 'help']):
        sys.stderr.write(__doc__)

    walk_dir(args)
    return 0


if __name__ == "__main__":
    sys.exit( main() )
