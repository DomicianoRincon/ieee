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
  el 2026-09-03 con **decktape** (la herramienta documentada en
  `Divulgacion/skills/slides-skill/.agents/skills/implement-slides/SKILL.md`,
  paso "4.2: Export PDF File via Decktape" — es el mismo framework `icesi.*`
  que arma este deck, así que su convención de export aplica igual acá).
  Comando usado (agregar `--chrome-path` porque el entorno no tiene Chromium
  descargado por Puppeteer, solo el Chrome del sistema):
  ```
  PUPPETEER_SKIP_DOWNLOAD=true npx -y decktape reveal \
    --chrome-path "C:\Program Files\Google\Chrome\Application\chrome.exe" \
    --size 1280x720 \
    --pdf-title "An Application Hub for Offline Clinical Data Collection in Neurological Field Brigades" \
    --pdf-author "Domiciano Rincon Nino, Esteban Gaviria Zambrano, Juan David Colonia, Juan Manuel Diaz, Miguel Angel Gonzalez, Patricia Madrinan, Andres Navarro" \
    "file:///C:/Users/domic/Documents/ieee/Divulgacion/ieee/hub/index.html" \
    "presentation_en.pdf"
  ```
  Decktape apaga los controles nativos de Reveal.js vía
  `Reveal.configure({controls:false, transition:'none', ...})`, pero el
  botón `#fullscreen-btn` y el `.icesi-slide-number` son propios de esta
  plantilla (no de Reveal), así que decktape no los oculta solo. Por eso
  `index.html` tiene un hook (`Reveal.on('ready', ...)` cerca del final del
  `<script>` principal) que detecta `Reveal.getConfig().controls === false`
  y agrega `body.exporting-pdf` para ocultarlos **solo durante el export**
  — la vista en vivo (controls:true) no se toca. Si se agrega otro elemento
  de UI custom al template, hay que sumarlo a esa misma regla
  `body.exporting-pdf` en el `@media print` block, no a uno nuevo.
  El modo `?print-pdf` nativo de reveal.js 5.x + `chrome --print-to-pdf`
  headless **no funciona** en este deck (el `PrintContext.activate()` de
  reveal.js es async vía `requestAnimationFrame` y no reflowa a tiempo antes
  de que `Page.printToPDF` capture, dando 1 sola página) — decktape lo evita
  navegando cada slide por `#/N` vía la API de Reveal.js y capturando cada
  una por separado, que es lo que hay que seguir usando.

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
