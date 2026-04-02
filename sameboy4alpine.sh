#!/bin/sh

### /// sameboy4alpine.sh // ConzZah // 2026-04-01 5:15 ///

## pull in dependencies 
doas apk add \
git \
bison \
sdl2-dev \
glib-dev \
clang-dev \
libpng-dev \
build-base \
gdk-pixbuf-dev

#### ENSURE THAT EVERYTHING HAS BEEN CLONED & IS UP TO DATE ####

## clone / update SameBoy
[ ! -d SameBoy ] && git clone https://github.com/LIJI32/SameBoy
[ -d SameBoy ] && { cd SameBoy || exit 1; git pull ;}

## clone / update cppp
[ ! -d cppp ] && git clone https://github.com/LIJI32/cppp
[ -d cppp ] && { cd cppp || exit 1; git pull; cd .. || exit 1 ;}

## clone / update rgbds
[ ! -d rgbds ] && git clone https://github.com/gbdev/rgbds
[ -d rgbds ] && { cd rgbds || exit 1; git pull; cd .. || exit 1 ;}

#### GO BUILD ####

build () { make clean; make; doas make install ;}

## build cppp
cd cppp || exit 1
doas mkdir -p /usr/local/share/man/man1
build
cd ..

## build rgbds
cd rgbds || exit 1
build
cd ..

## build SameBoy
build
