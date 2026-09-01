#!/usr/bin/env bash
# Sincroniza presentation/prototype/ de un proyecto hacia una carpeta de este repo,
# lista para publicarse por GitHub Pages (branch main, path /).
#
# El prototype deja las figuras como referencia relativa a ../graphics/ (no las
# duplica, ver ~/.claude/workflows/presentaciones.md Paso 5). Al copiar el HTML a
# este repo pierde un nivel de profundidad (pasa de presentation/prototype/ a
# vivir directo en <dest-folder-name>/), así que este script reescribe esas rutas
# y copia junto a él solo los gráficos que el HTML realmente referencia.
#
# Uso:
#   ./sync-prototype.sh <ruta-a-presentation-del-proyecto> <carpeta-destino>
#
# Ejemplos (desde esta carpeta):
#   ./sync-prototype.sh "../../IEEE ProyectoHub/presentation" hub
#   ./sync-prototype.sh "../../IEEE EspiralArchimedesI/presentation" spiral

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Uso: $0 <ruta-a-presentation-del-proyecto> <carpeta-destino>" >&2
  exit 1
fi

SRC="$1"
DEST="$2"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROTO_HTML="$SRC/prototype/presentation.html"
PROTO_PDF="$SRC/prototype/presentation.pdf"
GRAPHICS_DIR="$SRC/graphics"

for f in "$PROTO_HTML" "$PROTO_PDF" "$GRAPHICS_DIR"; do
  [ -e "$f" ] || { echo "Falta: $f" >&2; exit 1; }
done

DEST_DIR="$REPO_ROOT/$DEST"
mkdir -p "$DEST_DIR/graphics"

sed 's#\.\./graphics/#graphics/#g' "$PROTO_HTML" > "$DEST_DIR/index.html"
cp "$PROTO_PDF" "$DEST_DIR/presentation.pdf"

referenced=$(grep -oE 'graphics/[A-Za-z0-9._-]+' "$DEST_DIR/index.html" | sed 's#graphics/##' | sort -u)

find "$DEST_DIR/graphics" -type f -delete
missing=0
while IFS= read -r img; do
  [ -z "$img" ] && continue
  if [ -f "$GRAPHICS_DIR/$img" ]; then
    cp "$GRAPHICS_DIR/$img" "$DEST_DIR/graphics/$img"
  else
    echo "ADVERTENCIA: referenciado en el HTML pero no existe en $GRAPHICS_DIR: $img" >&2
    missing=1
  fi
done <<< "$referenced"

count=$(find "$DEST_DIR/graphics" -type f | wc -l | tr -d ' ')
echo "Listo: $DEST_DIR (index.html, presentation.pdf, graphics/ con $count archivos)"

if [ "$missing" -ne 0 ]; then
  echo "Hubo referencias sin resolver, revisa las advertencias de arriba." >&2
  exit 2
fi

cat <<EOF

Siguiente paso manual:
  cd "$REPO_ROOT" && git add "$DEST" && git commit -m "Publicar $DEST" && git push
EOF
