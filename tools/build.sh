#!/bin/bash
set -e
tools/preproc.lua src/main.lua /tmp/built.lua -strip-comments
tools/zlua.lua ClayBIOS < /tmp/built.lua > bios.lua
#tools/compress.lua < /tmp/built.lua > compressed.lua
#tools/preproc.lua src/lzssloader.lua bios.lua
