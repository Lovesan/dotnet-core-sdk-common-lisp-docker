FROM ubuntu:focal AS build

WORKDIR /build

COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       texinfo build-essential gcc-9 g++-9 && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 800 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/download-ccl.sh "1.12.1" linuxx86 lx86cl64

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-focal AS production

WORKDIR /root

COPY --from=build /opt/ccl /opt/ccl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/ccl:${PATH}"

ENV CCL_DEFAULT_DIRECTORY=/opt/ccl

RUN cat install.lisp | ccl64 && rm quicklisp.lisp install.lisp
