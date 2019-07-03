param([String]$Version)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$installerFile = "sbcl-${Version}-x86-64-windows-binary.msi"

$msiUrl = "https://static.lovesan.me/sbcl/${installerFile}"

Invoke-WebRequest -Uri $msiUrl -OutFile $installerFile -Verbose

Invoke-WebRequest -Uri "${msiUrl}.sig" -OutFile "${installerFile}.sig" -Verbose

Write-Host 'Verifying checksum'

$origHash = (Get-Content "${installerFile}.sig" -Encoding ASCII) -replace '\s+.*$',''
$fileHash = (Get-FileHash $installerFile -Algorithm SHA256).Hash.ToLowerInvariant()

if ( $origHash -ne $fileHash ) {
    Write-Error 'Checksums do not match'
    exit 1
}

$install = Start-Process msiexec.exe -Wait -ArgumentList "/i ${installerFile} /qn INSTALLDIR=C:\sbcl" -PassThru

$install.WaitForExit()

if ( $install.ExitCode -ne 0) {
    Write-Error 'Installer failed'
}

# Download quicklisp
Invoke-WebRequest -Uri 'https://beta.quicklisp.org/quicklisp.lisp' -OutFile 'quicklisp.lisp' -Verbose
