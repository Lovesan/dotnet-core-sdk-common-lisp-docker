#!/bin/bash
set -exo pipefail

version=$1
config_suffix=$2

git clone git://git.code.sf.net/p/sbcl/sbcl sbcl

cd sbcl

git checkout $version

if [ -n $config_suffix ]; then
  echo '(lambda (features) (cons :sb-core-compression features))' > \
      customize-target-features.lisp

  sed -i.bak 's/OS_LIBS += -lz/OS_LIBS += -Wl,-Bstatic -lz -Wl,-Bdynamic/g' src/runtime/Config.${config_suffix}
fi
bash make.sh

export INSTALL_ROOT=/opt/sbcl

bash install.sh

export SBCL_HOME=/opt/sbcl/lib/sbcl

cd /build

# Load quicklisp
wget https://beta.quicklisp.org/quicklisp.lisp
