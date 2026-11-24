@echo off
chcp 65001 >nul
title ChocoTentacion - Preparar la caja
echo.
echo  ==========================================================
echo     ChocoTentacion - Preparar la computadora de la caja
echo  ==========================================================
echo.
echo  Este programa hace 3 cosas:
echo   1. Pone la tiquera como impresora principal.
echo   2. Crea en el escritorio el icono verde "ChocoTentacion Caja",
echo      que abre el sistema para VENDER e imprime el ticket DIRECTO,
echo      sin la ventana de imprimir.
echo   3. Crea el icono azul "ChocoTentacion Administracion"
echo      (inventario, compras, reportes...).
echo.
pause
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$url='https://edwinalejandro0824-web.github.io/chocotentacion-tiendas/';" ^
 "Write-Host ''; Write-Host ' Impresoras instaladas en esta computadora:' -ForegroundColor Cyan;" ^
 "$imps = @(Get-CimInstance Win32_Printer | Sort-Object Name);" ^
 "for ($i=0; $i -lt $imps.Count; $i++) { $m = if ($imps[$i].Name -match 'roccia|rc-?80|rc-?58|80mm|58mm|pos-?80|pos80|pos-?58|pos58|thermal|termica|ticket|receipt') {'   <-- parece la tiquera'} else {''}; Write-Host ('   ' + ($i+1) + '. ' + $imps[$i].Name + $m) };" ^
 "Write-Host ''; $n = Read-Host ' Escribe el NUMERO de la tiquera y presiona Enter';" ^
 "$imp = $imps[[int]$n - 1]; if (-not $imp) { throw 'Numero no valido' };" ^
 "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows' -Name LegacyDefaultPrinterMode -Value 1 -Type DWord;" ^
 "Invoke-CimMethod -InputObject $imp -MethodName SetDefaultPrinter | Out-Null;" ^
 "Write-Host (' Listo: ' + $imp.Name + ' es la impresora principal.') -ForegroundColor Green;" ^
 "$nav = @(\"$env:ProgramFiles\Google\Chrome\Application\chrome.exe\", \"${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe\", \"$env:LocalAppData\Google\Chrome\Application\chrome.exe\", \"${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe\", \"$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe\") | Where-Object { Test-Path $_ } | Select-Object -First 1;" ^
 "if (-not $nav) { throw 'No encontre Google Chrome ni Microsoft Edge. Instala Google Chrome y vuelve a abrir este archivo.' };" ^
 "$perfil = Join-Path $env:LocalAppData 'ChocoTentacionCaja2';" ^
 "New-Item -ItemType Directory -Force -Path $perfil | Out-Null;" ^
 "$icoCaja = Join-Path $perfil 'icono-caja.ico'; $icoAdm = Join-Path $perfil 'icono-admin.ico';" ^
 "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest ($url + 'icono-caja.ico') -OutFile $icoCaja -UseBasicParsing; Invoke-WebRequest ($url + 'icono-admin.ico') -OutFile $icoAdm -UseBasicParsing } catch { $icoCaja = $nav; $icoAdm = $nav };" ^
 "$ws = New-Object -ComObject WScript.Shell;" ^
 "$acc = $ws.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'ChocoTentacion Caja.lnk'));" ^
 "$acc.TargetPath = $nav;" ^
 "$acc.Arguments = '--kiosk-printing --app=' + $url + ' --user-data-dir=\"' + $perfil + '\"';" ^
 "$acc.Description = 'Sistema de tiendas ChocoTentacion';" ^
 "$acc.IconLocation = $icoCaja + ',0';" ^
 "$acc.Save();" ^
 "$adm = $ws.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'ChocoTentacion Administracion.lnk'));" ^
 "$adm.TargetPath = $nav;" ^
 "$adm.Arguments = '--app=' + $url + 'admin.html';" ^
 "$adm.Description = 'Administracion de las tiendas ChocoTentacion';" ^
 "$adm.IconLocation = $icoAdm + ',0';" ^
 "$adm.Save();" ^
 "Write-Host ' Listo: en el escritorio estan los iconos \"ChocoTentacion Caja\" (verde) y \"ChocoTentacion Administracion\" (azul).' -ForegroundColor Green"
if errorlevel 1 (
  echo.
  echo  Algo fallo. Toma una foto de esta pantalla y mandasela a Edwin.
  pause
  exit /b 1
)
echo.
echo  ==========================================================
echo   TODO LISTO. Para VENDER abre SIEMPRE el icono verde
echo   "ChocoTentacion Caja" del escritorio (imprime directo).
echo   Para administrar usa el azul "ChocoTentacion Administracion".
echo   La primera vez: tu usuario y tu clave, y si dice que el
echo   equipo no esta autorizado, la clave de administrador.
echo  ==========================================================
echo.
pause
