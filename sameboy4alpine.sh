#!/usr/bin/env sh

### /// sameboy4alpine.sh // ConzZah // 2026-04-05 03:27 ///

## find out where the script is located
sp="$(cd "$(dirname "$0")" && pwd)" ## <-- sp = scriptpath

## cd to $sp if we are somewhere else
[ "$sp" != "$(pwd)" ] && { cd "$sp" || exit 1 ;}

## find out if we are root and set $doas accordingly
[ "$(whoami)" != "root" ] && doas="doas"

## pull in dependencies 
$doas apk add \
git \
7zip \
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

## BUILD ##

build () { make clean; make; $doas make install ;}

## build cppp
cd cppp || exit 1
$doas mkdir -p /usr/local/share/man/man1
build
cd ..

## build rgbds
cd rgbds || exit 1
build
cd ..

## build SameBoy
build

## PACKAGE ##

## write install.sh
# shellcheck disable=SC2016
# REASON: expressions shouldn't expand, this is intentional.
echo '#!/usr/bin/env sh
### /// sameboy4alpine - install.sh // ConzZah ///

## find out where the script is located
sp="$(cd "$(dirname "$0")" && pwd)" ## <-- sp = scriptpath

## cd to $sp if we are somewhere else
[ "$sp" != "$(pwd)" ] && { cd "$sp" || exit 1 ;}

## find out if we are root and set $doas accordingly
[ "$(whoami)" != "root" ] && doas="doas"

## install rgbds (build dep)
$doas make -C rgbds install

## install cppp (build dep)
$doas mkdir -p /usr/local/share/man/man1
$doas make -C cppp install

## install SameBoy
$doas make install
' > install.sh

## cd to $sp and create our package
cd "$sp" || exit 1; 7z a "SameBoy-$(uname -m).7z" 'SameBoy' -mx=9
