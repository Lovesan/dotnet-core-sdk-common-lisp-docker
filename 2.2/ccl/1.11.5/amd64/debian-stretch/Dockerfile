FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build

WORKDIR /build

COPY . /build

RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install bash wget gzip && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    chmod 755 ./tools/*.sh && \
    bash ./tools/download-ccl.sh "1.11.5" linuxx86 lx86cl64

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS production

WORKDIR /root

COPY --from=build /opt/ccl /opt/ccl/

COPY --from=build /build/quicklisp.lisp /root

COPY --from=build /build/install.lisp /root

ENV PATH="/opt/ccl:${PATH}"

ENV CCL_DEFAULT_DIRECTORY=/opt/ccl

RUN cat install.lisp | ccl64 && rm quicklisp.lisp install.lisp