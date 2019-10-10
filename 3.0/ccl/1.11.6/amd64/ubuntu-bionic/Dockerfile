FROM ubuntu:bionic AS build

WORKDIR /build

COPY . /build

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       texinfo build-essential gcc-8 g++-8 && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-ccl.sh "1.11.6" linuxx86 linuxx8664 lx86cl64

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-bionic AS production

WORKDIR /root

COPY --from=build /opt/ccl /opt/ccl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/ccl:${PATH}"

ENV CCL_DEFAULT_DIRECTORY=/opt/ccl

RUN cat install.lisp | ccl64 && rm quicklisp.lisp install.lisp
