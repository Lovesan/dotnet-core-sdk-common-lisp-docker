FROM mcr.microsoft.com/windows/servercore:1903 as install

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /build

COPY . /build

RUN tools/Install-SBCL.ps1 '1.5.6'

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-nanoserver-1903 as production

WORKDIR /

COPY --from=install /sbcl /sbcl/

COPY --from=install /build/quicklisp.lisp /sbcl

COPY --from=install /build/install.lisp /sbcl

USER ContainerAdministrator

RUN setx /M PATH "C:/sbcl;%PATH%" && setx /M SBCL_HOME "C:/sbcl"

RUN cd sbcl && (type install.lisp | call sbcl /wait) && del /S /Q /F install.lisp quicklisp.lisp
