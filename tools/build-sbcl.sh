#!/bin/bash
set -exo pipefail

version=$1

git clone git://git.code.sf.net/p/sbcl/sbcl sbcl

cd sbcl

git checkout $version

rm -f /usr/lib/`uname -m`-linux-gnu/libz.so

echo '(lambda (features) (cons :sb-core-compression features))' > \
    customize-target-features.lisp
bash make.sh

export INSTALL_ROOT=/opt/sbcl

bash install.sh

export SBCL_HOME=/opt/sbcl/lib/sbcl

cd /build

# Load quicklisp
wget https://beta.quicklisp.org/quicklisp.lisp
