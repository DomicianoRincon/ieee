# CLAUDE.md — `Divulgacion/ieee/hub/`

## Qué hay en esta carpeta

Página publicada (GitHub Pages, repo `Divulgacion/ieee/`) de la ponencia **IEEE
COLCOM 2026**: *"An Application Hub for Offline Clinical Data Collection in
Neurological Field Brigades"*.

- **`index.html`** — versión en **inglés**. Es la publicada (URL pública
  `https://domicianorincon.github.io/ieee/hub/`) y la que se edita cuando el
  usuario pide cambios sobre "la presentación en inglés".
- **`index_es.html`** — versión en **español**, el original tal cual salió
  del proyecto fuente (ver abajo). Se guardó como respaldo el 2026-09-02 al
  traducir `index.html` al inglés. No se publica como página propia (no hay
  link a ella desde ningún lado), es solo referencia/backup.
- **`graphics/`** — solo las imágenes que el HTML publicado realmente
  referencia, copiadas desde el proyecto fuente por `sync-prototype.sh` (ver
  `Divulgacion/ieee/CLAUDE.md`).
- **`presentation.pdf`** — export a PDF de la versión en español (la que
  generó el prototype original).
- **`presentation_en.pdf`** — export a PDF de `index.html` (inglés), generado
  el 2026-09-03. El modo `?print-pdf` nativo de reveal.js 5.x **no funciona**
  headless en este deck (su `PrintContext.activate()` es async vía
  `requestAnimationFrame` y no reflowa a tiempo antes de que
  `Page.printToPDF` capture, dando 1 sola página) — no perder tiempo
  reintentándolo. Lo que sí funciona: un script Node con `puppeteer-core`
  (apuntado al Chrome del sistema, sin descargar Chromium aparte) que navega
  el deck en modo normal, recorre cada slide con `Reveal.slide(i, 0)`,
  captura cada una como PDF de 1 página a tamaño nativo (`1280x720`, mismo
  que `Reveal.initialize`), y las concatena con `pdf-lib`. Para regenerarlo
  tras un cambio de contenido, repetir ese mismo proceso.

## Fuente de toda la información técnica: `IEEE ProyectoHub/`

Todo el contenido de esta ponencia (arquitectura, resultados, cifras,
terminología) viene del proyecto **`IEEE ProyectoHub/`** (carpeta hermana
dentro de `Investigación/`). Si el usuario pide un cambio de contenido —no
solo de redacción/traducción— sobre la presentación en inglés, esa carpeta es
la referencia para verificar hechos, cifras o terminología, en particular:

- `IEEE ProyectoHub/presentation/prototype/presentation.html` — el
  **prototype fuente en español**, la ponencia original de la que salió el
  `index_es.html` de acá (vía `sync-prototype.sh`, con `../graphics/`
  reescrito a `graphics/`). Es el HTML "vivo" del proyecto; esta carpeta
  (`Divulgacion/ieee/hub/`) es una publicación derivada de él, no al revés.
- `IEEE ProyectoHub/presentation/graphics/` — el set completo de gráficos
  fuente (incluye variantes `.svg` y `.light.png` no usadas en el prototype
  final, que `sync-prototype.sh` filtra a propósito).
- `IEEE ProyectoHub/presentation/plan.md` — plan/guion de la ponencia.
- `IEEE ProyectoHub/hubarch.md` — arquitectura del hub en detalle.
- `IEEE ProyectoHub/incognitus_endpoints_summary.md` — detalle de los
  endpoints de una de las tres apps clientes (Incognitus).
- `IEEE ProyectoHub/repos.md` — referencia de los repos involucrados.
- `IEEE ProyectoHub/CLAUDE.md` — instrucciones propias de ese proyecto; leer
  antes de tocar algo ahí.

## Importante al pedir cambios sobre la versión en inglés

`index.html` (inglés) es una **traducción manual hecha directamente en esta
carpeta**, no generada por `sync-prototype.sh` — ese script solo sabe copiar
el prototype en español. Por eso:

- **Los cambios de contenido/redacción en inglés se aplican directamente a
  `Divulgacion/ieee/hub/index.html`**, no al prototype del proyecto fuente.
- **Nunca volver a correr `sync-prototype.sh hub`** sobre esta carpeta sin
  avisar: sobreescribiría `index.html` con una copia fresca del prototype en
  **español**, perdiendo la traducción al inglés.
- Si el contenido en español cambia en el proyecto fuente (`IEEE
  ProyectoHub/presentation/prototype/presentation.html`) y hay que reflejarlo
  acá, hay que decidir caso a caso si se re-sincroniza `index_es.html` y se
  vuelve a traducir a mano la parte que cambió en `index.html`, o si el
  cambio se aplica en paralelo a ambos archivos.
- Si un cambio requiere una imagen nueva o distinta, sacarla de `IEEE
  ProyectoHub/presentation/graphics/` y copiarla a `graphics/` acá (mismo
  nombre de archivo que usa el `src="graphics/...">` del HTML).

Ver `Divulgacion/ieee/CLAUDE.md` (raíz del repo) para el flujo de publicación
general (`sync-prototype.sh`, push con el PAT de `DomicianoRincon`, troubleshooting
de GitHub Pages).
