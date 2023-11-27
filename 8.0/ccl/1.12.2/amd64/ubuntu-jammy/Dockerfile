FROM ubuntu:jammy AS build

WORKDIR /build

COPY . /build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/download-ccl.sh "1.12.2" linuxx86 lx86cl64

FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS production

WORKDIR /root

COPY --from=build /opt/ccl /opt/ccl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/ccl:${PATH}"

ENV CCL_DEFAULT_DIRECTORY=/opt/ccl

RUN cat install.lisp | ccl64 && rm quicklisp.lisp install.lisp
