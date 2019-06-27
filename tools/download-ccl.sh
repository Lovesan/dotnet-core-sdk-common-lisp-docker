#!/bin/bash
set -exo pipefail

version=$1
suffix=$2

wget -O ccl.tar.gz https://github.com/Clozure/ccl/releases/download/v${version}/ccl-${version}-${suffix}.tar.gz

tar xzvf ccl.tar.gz -C /opt/

rm -rf /opt/ccl/.git

cp /opt/ccl/scripts/ccl64 /opt/ccl/

# Load quicklisp
wget https://beta.quicklisp.org/quicklisp.lisp

cd /opt/ccl/tools

rm -f asdf.*

wget https://common-lisp.net/project/asdf/archives/asdf.lisp

echo '(compile-file "asdf")' | /opt/ccl/lx86cl64