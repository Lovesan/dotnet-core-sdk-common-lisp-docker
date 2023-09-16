FROM ubuntu:jammy AS build

WORKDIR /build

COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       sbcl texinfo build-essential gcc-12 g++-12 libzstd-dev && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 800 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-12 && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-sbcl.sh "sbcl-2.3.8"

FROM mcr.microsoft.com/dotnet/sdk:7.0-jammy AS production

WORKDIR /root

COPY --from=build /opt/sbcl /opt/sbcl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/sbcl/bin:${PATH}"

ENV SBCL_HOME="/opt/sbcl/lib/sbcl"

RUN cat install.lisp | sbcl && rm quicklisp.lisp install.lisp
