@echo off
chcp 65001 >nul
title ChocoTentacion - Preparar la caja
echo.
echo  ==========================================================
echo     ChocoTentacion - Preparar la computadora de la caja
echo  ==========================================================
echo.
echo  Este programa hace 2 cosas:
echo   1. Pone la tiquera como impresora principal.
echo   2. Crea en el escritorio el acceso "ChocoTentacion Caja",
echo      que abre el sistema e imprime el ticket DIRECTO,
echo      sin la ventana de imprimir.
echo.
pause
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$url='https://edwinalejandro0824-web.github.io/chocotentacion-tiendas/';" ^
 "Write-Host ''; Write-Host ' Impresoras instaladas en esta computadora:' -ForegroundColor Cyan;" ^
 "$imps = @(Get-CimInstance Win32_Printer | Sort-Object Name);" ^
 "for ($i=0; $i -lt $imps.Count; $i++) { $m = if ($imps[$i].Name -match 'roccia|rc-?80|80mm|pos-?80|pos80|thermal|termica|ticket|receipt') {'   <-- parece la tiquera'} else {''}; Write-Host ('   ' + ($i+1) + '. ' + $imps[$i].Name + $m) };" ^
 "Write-Host ''; $n = Read-Host ' Escribe el NUMERO de la tiquera y presiona Enter';" ^
 "$imp = $imps[[int]$n - 1]; if (-not $imp) { throw 'Numero no valido' };" ^
 "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows' -Name LegacyDefaultPrinterMode -Value 1 -Type DWord;" ^
 "Invoke-CimMethod -InputObject $imp -MethodName SetDefaultPrinter | Out-Null;" ^
 "Write-Host (' Listo: ' + $imp.Name + ' es la impresora principal.') -ForegroundColor Green;" ^
 "$nav = @(\"$env:ProgramFiles\Google\Chrome\Application\chrome.exe\", \"${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe\", \"$env:LocalAppData\Google\Chrome\Application\chrome.exe\", \"${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe\", \"$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe\") | Where-Object { Test-Path $_ } | Select-Object -First 1;" ^
 "if (-not $nav) { throw 'No encontre Google Chrome ni Microsoft Edge. Instala Google Chrome y vuelve a abrir este archivo.' };" ^
 "$perfil = Join-Path $env:LocalAppData 'ChocoTentacionCaja';" ^
 "$ws = New-Object -ComObject WScript.Shell;" ^
 "$acc = $ws.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'ChocoTentacion Caja.lnk'));" ^
 "$acc.TargetPath = $nav;" ^
 "$acc.Arguments = '--kiosk-printing --app=' + $url + ' --user-data-dir=\"' + $perfil + '\"';" ^
 "$acc.Description = 'Sistema de tiendas ChocoTentacion';" ^
 "$acc.IconLocation = $nav + ',0';" ^
 "$acc.Save();" ^
 "Write-Host ' Listo: en el escritorio esta el acceso \"ChocoTentacion Caja\".' -ForegroundColor Green"
if errorlevel 1 (
  echo.
  echo  Algo fallo. Toma una foto de esta pantalla y mandasela a Edwin.
  pause
  exit /b 1
)
echo.
echo  ==========================================================
echo   TODO LISTO. De ahora en adelante abre el sistema SIEMPRE
echo   con el acceso "ChocoTentacion Caja" del escritorio.
echo   La primera vez entra con tu usuario y tu clave.
echo  ==========================================================
echo.
pause
