#!/bin/bash
set -e
tools/preproc.lua src/main.lua /tmp/built.lua -strip-comments
rm -rf out
mkdir -p out/usr/share/prismbios
tools/zlua.lua PrismBIOS < /tmp/built.lua > out/usr/share/prismbios/bios.lua
if [ $(stat -c %s out/usr/share/prismbios/bios.lua) -gt 4096 ]; then
  echo WARNING: bios.lua larger than 4096 bytes
else
  echo bios.lua is $(stat -c %s out/usr/share/prismbios/bios.lua) bytes
fi
