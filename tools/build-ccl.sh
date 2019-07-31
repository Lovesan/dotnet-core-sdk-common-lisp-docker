#!/bin/bash
set -exo pipefail

version=$1
dl_suffix=$2
suffix=$3
executable=$4

wget -O ccl.tar.gz https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-${dl_suffix}.tar.gz

tar xzvf ccl.tar.gz -C /opt/

cd /opt/ccl

git fetch --tags --all

if [ $version != 'master' ]; then
    git checkout "v${version}"
else
    git pull
fi

cd /opt/ccl/lisp-kernel/$suffix

make

cd /opt/ccl

echo '(rebuild-ccl)' | ./$executable

rm -rf /opt/ccl/.git

cp /opt/ccl/scripts/ccl64 /opt/ccl/

cd /build

# Load quicklisp
wget https://beta.quicklisp.org/quicklisp.lisp

cd /opt/ccl/tools

rm -f asdf.*

wget https://common-lisp.net/project/asdf/archives/asdf.lisp

echo '(compile-file "asdf")' | /opt/ccl/$executable
