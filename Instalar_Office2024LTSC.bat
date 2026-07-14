@echo off
:: =====================================================================
::   Instalador de Office LTSC 2024 Professional Plus (licencia volumen)
::   Metodo oficial: Office Deployment Tool (ODT) de Microsoft
::
::   by thealejandro - XACode
::
::   Uso: doble clic (se autoeleva a administrador)
::   Requisitos: Windows 10/11 con internet. Descarga ~3-4 GB.
::
::   IMPORTANTE si editas este archivo: guardalo SIEMPRE en codificacion
::   ANSI/OEM (nunca UTF-8), o los marcos y acentos se romperan.
:: =====================================================================
setlocal EnableDelayedExpansion
chcp 850 >nul
title Office LTSC 2024 ๚ XACode
color 0B

:: --- Autoelevaciขn a administrador ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo   Solicitando permisos de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

call :BANNER

:: =====================================================================
::  DETECCION DE OFFICE EXISTENTE
:: =====================================================================
echo   ฺฤ Buscando versiones de Office instaladas...
set OFFICEFOUND=0
for /f "delims=" %%D in ('powershell -NoProfile -Command "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Office|Microsoft 365' -and $_.DisplayName -notmatch 'Component|Add-in|Runtime|Tools|MUI|Proof|Localization|Extensibility' } | ForEach-Object { $_.DisplayName }"') do (
    echo   ณ    ฏ %%D
    set OFFICEFOUND=1
)
if !OFFICEFOUND!==0 (
    echo   ณ    V No se detectข ningฃn Office instalado.
) else (
    echo   ณ
    echo   ณ    [AVISO] ATENCION: Office LTSC 2024 NO convive con Microsoft 365
    echo   ณ           ni con otras versiones Click-to-Run. Se recomienda quitarlas.
)
echo   ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
echo.

:: =====================================================================
::  OPCIONES
:: =====================================================================
echo   ฺฤ [1/4] Idioma de Office
echo   ณ    [1] Espaคol (Mxico)   es-mx
echo   ณ    [2] Espaคol (Espaคa)   es-es
echo   ณ    [3] Ingls (EE.UU.)    en-us
choice /c 123 /n /m "  ภฤ   Opciขn: "
if errorlevel 3 (set OFFLANG=en-us) else if errorlevel 2 (set OFFLANG=es-es) else set OFFLANG=es-mx
echo        -^> Idioma: !OFFLANG!
echo.

echo   ฺฤ [2/4] Arquitectura (usa 64 salvo equipos muy viejos o
echo   ณ        complementos que exijan 32 bits)
echo   ณ    [1] 64 bits  (recomendado)
echo   ณ    [2] 32 bits
choice /c 12 /n /m "  ภฤ   Opciขn: "
if errorlevel 2 (set ARCH=32) else set ARCH=64
echo        -^> Arquitectura: !ARCH! bits
echo.

echo   ฺฤ [3/4] Clave de producto (25 caracteres). Puedes dejarla vacกa
echo   ณ        y activar despus.
set "PIDKEY="
set /p PIDKEY=  ภฤ   Clave (Enter para omitir):
set "PIDATTR="
set "KEYMSG=(sin clave, activar despus)"
if defined PIDKEY (
    set PIDATTR= PIDKEY="%PIDKEY%"
    set "KEYMSG=%PIDKEY:~0,5%-*****-*****-*****-*****"
)
echo.

set REMOVEOLD=0
echo   ฺฤ [4/4] Desinstalaciขn previa
if !OFFICEFOUND!==1 (
    choice /m "  ภฤ   จQuitar TODO el Office existente antes de instalar? (recomendado: S)"
) else (
    choice /m "  ภฤ   จEjecutar limpieza de Office por si acaso? (recomendado: N)"
)
if errorlevel 2 (set REMOVEOLD=0) else set REMOVEOLD=1
echo.

:: =====================================================================
::  RESUMEN
:: =====================================================================
echo   ษอออออออออออออออออออ RESUMEN อออออออออออออออออออป
echo   บ  Producto : Office LTSC 2024 Pro Plus (volumen)
echo   บ  Idioma   : !OFFLANG!
echo   บ  Arquit.  : !ARCH! bits
echo   บ  Clave    : !KEYMSG!
if !REMOVEOLD!==1 (echo   บ  Limpieza : Sก - se quitar  el Office existente) else echo   บ  Limpieza : No
echo   ศออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
choice /m "  จComenzar la instalaciขn?"
if errorlevel 2 goto CANCELADO
echo.

:: =====================================================================
::  PASO 1 ๚ DESCARGAR OFFICE DEPLOYMENT TOOL
:: =====================================================================
echo   ฺฤ Paso 1 de 4 ๚ Descargando Office Deployment Tool...
curl -L -# -o setup.exe https://officecdn.microsoft.com/pr/wsus/setup.exe
if not exist setup.exe goto ERRDESCARGA
echo   ภฤ V Herramienta descargada.
echo.

:: =====================================================================
::  PASO 2 ๚ QUITAR OFFICE PREVIO (si se eligio)
:: =====================================================================
if !REMOVEOLD!==1 (
    echo   ฺฤ Paso 2 de 4 ๚ Quitando Office existente ^(puede tardar varios minutos^)...
    (
        echo ^<Configuration^>
        echo   ^<Remove All="TRUE" /^>
        echo   ^<Display Level="None" AcceptEULA="TRUE" /^>
        echo ^</Configuration^>
    ) > quitar.xml
    setup.exe /configure quitar.xml
    echo   ภฤ V Desinstalaciขn previa completada.
) else (
    echo   ฤฤ Paso 2 de 4 ๚ Omitido ^(sin limpieza previa^).
)
echo.

:: =====================================================================
::  PASO 3 ๚ GENERAR CONFIGURACION
:: =====================================================================
echo   ฺฤ Paso 3 de 4 ๚ Generando configuration.xml...
(
    echo ^<Configuration^>
    echo   ^<Add OfficeClientEdition="%ARCH%" Channel="PerpetualVL2024"^>
    echo     ^<Product ID="ProPlus2024Volume"%PIDATTR%^>
    echo       ^<Language ID="%OFFLANG%" /^>
    echo       ^<ExcludeApp ID="Lync" /^>
    echo     ^</Product^>
    echo   ^</Add^>
    echo   ^<Updates Enabled="TRUE" /^>
    echo   ^<RemoveMSI /^>
    echo   ^<Property Name="AUTOACTIVATE" Value="1" /^>
    echo   ^<Display Level="Full" AcceptEULA="TRUE" /^>
    echo ^</Configuration^>
) > configuration.xml
echo   ภฤ V Configuraciขn lista.
echo.

:: =====================================================================
::  PASO 4 ๚ INSTALAR
:: =====================================================================
echo   ฺฤ Paso 4 de 4 ๚ Descargando e instalando Office LTSC 2024
echo   ณ  (3-4 GB segฃn idioma; el instalador de Microsoft mostrar 
echo   ณ   su propia ventana de progreso - paciencia)...
setup.exe /configure configuration.xml
if %errorlevel% neq 0 goto ERRINSTALL
echo   ภฤ V Instalaciขn completada.
echo.

:: =====================================================================
::  ACTIVACION
:: =====================================================================
set "OSPP=%ProgramFiles%\Microsoft Office\Office16\ospp.vbs"
if not exist "%OSPP%" set "OSPP=%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs"

if defined PIDKEY (
    echo   ฺฤ Activando con la clave introducida...
    cscript //nologo "%OSPP%" /inpkey:%PIDKEY%
    cscript //nologo "%OSPP%" /act
    echo   ภฤ Estado de licencia:
    cscript //nologo "%OSPP%" /dstatus | findstr /i "LICENSE NAME ERROR"
) else (
    echo   ฤฤ No se introdujo clave. Para activar despus, en CMD como admin:
    echo        cscript "%OSPP%" /inpkey:TU-CLAVE-AQUI
    echo        cscript "%OSPP%" /act
)
echo.

color 0A
echo   ษออออออออออออออออออออออออออออออออออออออออออออออออป
echo   บ        V  INSTALACION FINALIZADA  V            บ
echo   บ                                                บ
echo   บ          thealejandro  ๚  XACode               บ
echo   ศออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
pause
exit /b 0

:: =====================================================================
::  RUTINAS
:: =====================================================================
:BANNER
cls
echo.
echo   ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo   บ                                                          บ
echo   บ        ÛÛ  ÛÛ   ÛÛÛÛ    ÛÛÛÛ    ÛÛÛ    ÛÛÛÛ    ÛÛÛÛÛÛ    บ
echo   บ         ÛÛÛÛ   ÛÛ  ÛÛ  ÛÛ      ÛÛ  ÛÛ  ÛÛ  ÛÛ  ÛÛ        บ
echo   บ          ÛÛ    ÛÛÛÛÛÛ  ÛÛ      ÛÛ  ÛÛ  ÛÛ  ÛÛ  ÛÛÛÛ      บ
echo   บ         ÛÛÛÛ   ÛÛ  ÛÛ  ÛÛ      ÛÛ  ÛÛ  ÛÛ  ÛÛ  ÛÛ        บ
echo   บ        ÛÛ  ÛÛ  ÛÛ  ÛÛ   ÛÛÛÛ    ÛÛÛÛ   ÛÛÛÛ    ÛÛÛÛÛÛ    บ
echo   บ                                                          บ
echo   บ        INSTALADOR ๚ OFFICE LTSC 2024 PRO PLUS            บ
echo   บ              by thealejandro ๚ XACode                    บ
echo   ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
exit /b

:CANCELADO
color 0E
echo.
echo   ฤฤ Instalaciขn cancelada por el usuario. No se hizo ningฃn cambio.
pause
exit /b 0

:ERRDESCARGA
color 0C
echo.
echo   [X] ERROR: no se pudo descargar setup.exe.
echo       Revisa la conexiขn a internet o el antivirus y vuelve a intentar.
pause
exit /b 1

:ERRINSTALL
color 0C
echo.
echo   [X] ERROR: la instalaciขn devolviข el cขdigo %errorlevel%.
echo       Revisa espacio en disco, conexiขn, o ejecuta de nuevo con limpieza previa.
pause
exit /b %errorlevel%
