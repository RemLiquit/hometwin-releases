# Hometwin

El gemelo digital de tu casa: el plano en 3D y tus dispositivos (luces, enchufes, clima, TV)
en un solo hub que corre en tu red. Funciona en la Wi-Fi de casa, sin nube propia.

Este repositorio distribuye solo binarios compilados. El codigo vive en un repositorio privado.

## Instalar

macOS y Linux:

```
curl -fsSL https://raw.githubusercontent.com/RemLiquit/hometwin-releases/main/install.sh | bash
```

Windows (PowerShell):

```
irm https://raw.githubusercontent.com/RemLiquit/hometwin-releases/main/install.ps1 | iex
```

Los scripts verifican el sha256 de la descarga y ejecutan `hometwin install`.

## Descarga manual

Siempre la ultima version (`<ver>` es el numero de version, p. ej. `0.1.0`; ver [Releases](https://github.com/RemLiquit/hometwin-releases/releases/latest)):

| Plataforma | Archivo |
| --- | --- |
| Mac Apple Silicon | [`hometwin-<ver>-macos-arm64.tar.gz`](https://github.com/RemLiquit/hometwin-releases/releases/latest) |
| Mac Intel | `hometwin-<ver>-macos-x64.tar.gz` |
| Linux x64 | `hometwin-<ver>-linux-x64.tar.gz` |
| Linux arm64 (Raspberry Pi) | `hometwin-<ver>-linux-arm64.tar.gz` |
| Windows x64 | `hometwin-<ver>-windows-x64.zip` |
| Android | `hometwin-<ver>-android.apk` |

Enlaces directos de la ultima release:
`https://github.com/RemLiquit/hometwin-releases/releases/latest/download/<archivo>`
(tambien `SHA256SUMS` y `latest.json`).

Descomprime y ejecuta `./hometwin install` (en Windows `.\hometwin.exe install`).
Desinstalar: `./hometwin uninstall`.

## Abrir

Desde cualquier dispositivo de la misma Wi-Fi: `http://hometwin.local:8420` o `http://<ip-del-equipo>:8420`.

## Actualizaciones

Hometwin comprueba este repositorio y verifica la firma Ed25519 de cada descarga antes de actualizarse.
