FROM gcc:8.3.0 AS build

WORKDIR /build

COPY . /build

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip \
                       git m4 libz-dev autoconf autopoint libtool \
                       sbcl texinfo && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/build-sbcl.sh "master" "x86-64-linux"

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS production

WORKDIR /root

COPY --from=build /opt/sbcl /opt/sbcl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/sbcl/bin:${PATH}"

ENV SBCL_HOME="/opt/sbcl/lib/sbcl"

RUN cat install.lisp | sbcl && rm quicklisp.lisp install.lisp
