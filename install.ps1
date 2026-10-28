# Instala Hometwin desde la ultima release de GitHub (Windows).
#   irm https://raw.githubusercontent.com/RemLiquit/hometwin-releases/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$base = 'https://github.com/RemLiquit/hometwin-releases/releases/latest/download'
$tmp = Join-Path $env:TEMP ('hometwin-' + [guid]::NewGuid())
New-Item -ItemType Directory -Force $tmp | Out-Null
try {
  Write-Host '> Buscando la ultima version...'
  $sums = Join-Path $tmp 'SHA256SUMS'
  Invoke-WebRequest "$base/SHA256SUMS" -OutFile $sums
  $line = Get-Content $sums | Where-Object { $_ -match 'hometwin-.*-windows-x64\.zip' } | Select-Object -First 1
  if (-not $line) { throw 'No hay build de Windows en la ultima release.' }
  $parts = $line -split '\s+', 2
  $expected = $parts[0].ToLower()
  $asset = $parts[1].TrimStart('*').Trim()

  Write-Host "> Descargando $asset..."
  $zip = Join-Path $tmp $asset
  Invoke-WebRequest "$base/$asset" -OutFile $zip

  Write-Host '> Verificando sha256...'
  $actual = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
  if ($actual -ne $expected) { throw 'El sha256 no coincide: descarga cancelada.' }

  Expand-Archive $zip -DestinationPath $tmp -Force
  $exe = Get-ChildItem $tmp -Recurse -Filter 'hometwin.exe' | Select-Object -First 1
  if (-not $exe) { throw 'El archivo no contiene hometwin.exe.' }

  Write-Host '> Instalando...'
  Push-Location $exe.DirectoryName
  try { & .\hometwin.exe install } finally { Pop-Location }
  Write-Host 'Listo. Si Windows pregunta por el firewall, pulsa Permitir acceso. Abre http://hometwin.local:8420'
} finally {
  Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
