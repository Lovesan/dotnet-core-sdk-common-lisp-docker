FROM ubuntu:bionic AS build

WORKDIR /build

COPY . /build

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       sbcl texinfo build-essential gcc-8 g++-8 && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-sbcl.sh "sbcl-1.5.7"

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-bionic AS production

WORKDIR /root

COPY --from=build /opt/sbcl /opt/sbcl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/sbcl/bin:${PATH}"

ENV SBCL_HOME="/opt/sbcl/lib/sbcl"

RUN cat install.lisp | sbcl && rm quicklisp.lisp install.lisp
