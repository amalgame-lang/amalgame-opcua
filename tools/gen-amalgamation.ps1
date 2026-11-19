# Generates runtime/open62541.c and runtime/open62541.h : the open62541
# v1.4.22 amalgamation built with the upstream tooling (CMake + Python),
# architecture-independent (POSIX or Win32 chosen at compile time),
# encryption with OpenSSL, without PubSub. See NOTICE.md.
#
#   git clone --depth 1 --branch v1.4.22 --recurse-submodules --shallow-submodules `
#       https://github.com/open62541/open62541.git <dir>\src
#   $env:OPEN62541_SRC = '<dir>'      # default D:\DEV\src-open62541
#   powershell -ExecutionPolicy Bypass -File tools\gen-amalgamation.ps1
#
# Needs CMake (a real one : the cmake.exe and ninja.exe shipped in the
# Amalgame toolchain's gcc\bin do not start), Python 3, and the
# toolchain's gcc and mingw32-make.
$ErrorActionPreference = 'Stop'
$pkg   = Split-Path -Parent $PSScriptRoot
$gcc   = if ($env:AMALGAME_GCC) { $env:AMALGAME_GCC } else { (Join-Path $env:LOCALAPPDATA 'Amalgame\gcc') }
$cmake = if ($env:CMAKE) { $env:CMAKE } else { 'C:\Tools\cmake-3.31.6-windows-x86_64\bin\cmake.exe' }
$src   = if ($env:OPEN62541_SRC) { $env:OPEN62541_SRC } else { 'D:\DEV\src-open62541' }
$env:Path = "$gcc\bin;" + $env:Path
Set-Location $src
if (Test-Path build) { Remove-Item build -Recurse -Force }
& $cmake -S src -B build -G 'MinGW Makefiles' `
  "-DCMAKE_MAKE_PROGRAM=$gcc/bin/mingw32-make.exe" -DCMAKE_C_COMPILER=gcc -DCMAKE_BUILD_TYPE=Release `
  -DUA_ENABLE_AMALGAMATION=ON -DUA_AMALGAMATION_MULTIARCH=ON `
  -DUA_ENABLE_ENCRYPTION=OPENSSL "-DOPENSSL_ROOT_DIR=$gcc" `
  -DUA_ENABLE_PUBSUB=OFF -DUA_ENABLE_PUBSUB_INFORMATIONMODEL=OFF `
  -DUA_ENABLE_DA=ON -DUA_ENABLE_DIAGNOSTICS=ON -DUA_ENABLE_HISTORIZING=ON -DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON `
  -DUA_ENABLE_JSON_ENCODING=ON -DUA_ENABLE_DISCOVERY=ON -DUA_NAMESPACE_ZERO=FULL -DUA_MULTITHREADING=100 `
  -DUA_BUILD_EXAMPLES=OFF
if ($LASTEXITCODE -ne 0) { throw "cmake configure failed ($LASTEXITCODE)" }
& $cmake --build build -j 8 --target open62541-amalgamation-source open62541-amalgamation-header
if ($LASTEXITCODE -ne 0) { throw "amalgamation build failed ($LASTEXITCODE)" }
Copy-Item build\open62541.c, build\open62541.h (Join-Path $pkg 'runtime') -Force

# open62541 1.4.22 bug : ua_client_connect.c and ua_pki_openssl.c both define a
# static openssl_PEM_PRE, which clashes once amalgamated with OpenSSL. Rename
# the client one (the code is gone from the 1.5 branch).
$c = Join-Path $pkg 'runtime\open62541.c'
$t = [IO.File]::ReadAllText($c)
$t = $t.Replace('static const unsigned char openssl_PEM_PRE[26] = "-----END CERTIFICATE-----";', 'static const unsigned char openssl_PEM_END_client[26] = "-----END CERTIFICATE-----";  /* amalgame-opcua : renamed, clashes with ua_pki_openssl.c in the amalgamation (see NOTICE.md) */')
$t = $t.Replace('UA_BstrstrClient(rc.data, rc.length, openssl_PEM_PRE, 25);', 'UA_BstrstrClient(rc.data, rc.length, openssl_PEM_END_client, 25);')
[IO.File]::WriteAllText($c, $t)
Get-Item (Join-Path $pkg 'runtime\open62541.*') | Format-Table Name, Length, LastWriteTime
Write-Host 'OK : runtime/open62541.c and .h generated'
