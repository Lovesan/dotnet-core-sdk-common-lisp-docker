FROM ubuntu:focal AS build

WORKDIR /build

COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       sbcl texinfo build-essential gcc-9 g++-9 libzstd-dev && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 800 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-sbcl.sh "sbcl-2.3.8"

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS production

WORKDIR /root

COPY --from=build /opt/sbcl /opt/sbcl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/sbcl/bin:${PATH}"

ENV SBCL_HOME="/opt/sbcl/lib/sbcl"

RUN cat install.lisp | sbcl && rm quicklisp.lisp install.lisp
