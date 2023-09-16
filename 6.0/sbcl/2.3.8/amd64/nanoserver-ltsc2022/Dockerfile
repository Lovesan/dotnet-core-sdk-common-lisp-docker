FROM mcr.microsoft.com/windows/servercore:ltsc2022 as install

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /build

COPY . /build

RUN tools/Install-SBCL.ps1 '2.3.8'

FROM mcr.microsoft.com/dotnet/sdk:6.0-nanoserver-ltsc2022 as production

WORKDIR /

COPY --from=install /sbcl /sbcl/

COPY --from=install /build/quicklisp.lisp /sbcl

COPY --from=install /build/install.lisp /sbcl

USER ContainerAdministrator

RUN setx /M PATH "C:/sbcl;%PATH%" && setx /M SBCL_HOME "C:/sbcl"

RUN cd sbcl && (type install.lisp | call sbcl /wait) && del /S /Q /F install.lisp quicklisp.lisp
