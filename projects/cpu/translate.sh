#!/bin/sh

yasm -o out.bin program.asm && \
< out.bin > project/out.bindump perl -ne '$\="\n" and map { print } unpack "(B16)*"' && \
cat project/out.bindump
