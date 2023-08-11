#!/bin/bash
set -e
tools/preproc.lua src/main.lua /tmp/built.lua -strip-comments
tools/zlua.lua ClayBIOS < /tmp/built.lua > bios.lua
if [ $(stat -c %s bios.lua) -gt 4096 ]; then
  echo WARNING: bios.lua larger than 4096 bytes
else
  echo bios.lua is $(stat -c %s bios.lua) bytes
fi
