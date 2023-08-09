#!/bin/bash
set -e
tools/preproc.lua src/main.lua /tmp/built.lua -strip-comments
tools/compress.lua < /tmp/built.lua > compressed.lua
tools/preproc.lua src/loader.lua bios.lua
