FROM ubuntu:noble AS build

WORKDIR /build

COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       sbcl texinfo build-essential gcc g++ libzstd-dev && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-sbcl.sh "sbcl-2.5.0"

FROM mcr.microsoft.com/dotnet/sdk:9.0-noble AS production

WORKDIR /root

COPY --from=build /opt/sbcl /opt/sbcl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/sbcl/bin:${PATH}"

ENV SBCL_HOME="/opt/sbcl/lib/sbcl"

RUN cat install.lisp | sbcl && rm quicklisp.lisp install.lisp
