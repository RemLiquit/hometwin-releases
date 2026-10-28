#!/usr/bin/env bash
# Instala Hometwin desde la ultima release de GitHub (macOS y Linux).
#
#   curl -fsSL https://raw.githubusercontent.com/RemLiquit/hometwin-releases/main/install.sh | bash
#
# Descarga el .tar.gz de tu plataforma, verifica su sha256 con SHA256SUMS y ejecuta
# "./hometwin install" (deja el hub como servicio de usuario).
set -euo pipefail

BASE="https://github.com/RemLiquit/hometwin-releases/releases/latest/download"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

case "$(uname -s)-$(uname -m)" in
  Darwin-arm64) plat=macos-arm64 ;;
  Darwin-x86_64) plat=macos-x64 ;;
  Linux-x86_64) plat=linux-x64 ;;
  Linux-aarch64|Linux-arm64) plat=linux-arm64 ;;
  *) echo "Plataforma no soportada: $(uname -s) $(uname -m). En Windows usa install.ps1." >&2; exit 1 ;;
esac

echo "> Buscando la ultima version..."
curl -fsSL "$BASE/SHA256SUMS" -o "$tmp/SHA256SUMS"
asset="$(awk -v p="-$plat.tar.gz" '{f=$2; sub(/^\*/,"",f); if (index(f,p) && f ~ /^hometwin-/) print f}' "$tmp/SHA256SUMS" | head -n1)"
[ -n "$asset" ] || { echo "No hay build para $plat en la ultima release." >&2; exit 1; }

echo "> Descargando $asset..."
curl -fsSL "$BASE/$asset" -o "$tmp/$asset"

echo "> Verificando sha256..."
expected="$(awk -v a="$asset" '{f=$2; sub(/^\*/,"",f); if (f==a) print $1}' "$tmp/SHA256SUMS")"
if command -v sha256sum >/dev/null 2>&1; then actual="$(sha256sum "$tmp/$asset" | awk '{print $1}')"
else actual="$(shasum -a 256 "$tmp/$asset" | awk '{print $1}')"; fi
[ -n "$expected" ] && [ "$expected" = "$actual" ] || { echo "El sha256 no coincide: descarga cancelada." >&2; exit 1; }

tar -xzf "$tmp/$asset" -C "$tmp"
dir="$tmp/${asset%.tar.gz}"
[ -x "$dir/hometwin" ] || { echo "El archivo no contiene hometwin." >&2; exit 1; }
if [ "$(uname -s)" = Darwin ]; then xattr -d com.apple.quarantine "$dir/hometwin" 2>/dev/null || true; fi

echo "> Instalando..."
(cd "$dir" && ./hometwin install)
if [ "$(uname -s)" = Linux ]; then
  echo "Para que arranque sin sesion abierta: loginctl enable-linger \"\$USER\""
fi
echo "Listo. Abre http://hometwin.local:8420 o http://<ip-del-equipo>:8420"
