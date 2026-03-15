# Creare il progetto da zero

Nel corso partiamo da un progetto già preparato (la cartella `lezione-01`). Questo approfondimento spiega **tutti i passaggi** che abbiamo fatto per arrivare a quel punto di partenza — così se vuoi creare un nuovo gioco da solo, sai come fare.

---

## 1. Creare un nuovo progetto

1. Apri Godot — si apre il **Project Manager**
2. Clicca **New Project**
3. Scegli un nome (es. `il-mio-gioco`) e una cartella dove salvarlo
4. **Renderer**: lascia **Forward+** (è il default, va bene per il 2D)
5. Clicca **Create & Edit**

Godot crea la cartella del progetto con dentro un file `project.godot` — è il file che identifica un progetto Godot.

<!-- 📸 SCREENSHOT: finestra "Create New Project" con nome e percorso compilati -->

---

## 2. Configurare la risoluzione per la pixel art

Un progetto Godot nuovo ha una risoluzione di **1152×648 pixel** — adatta per giochi HD, ma enorme per la pixel art. Noi vogliamo una risoluzione **molto più piccola** dove ogni pixel conta.

### Impostare il viewport

1. Vai nel menu **Project** → **Project Settings...**
2. Nella barra di ricerca in alto, scrivi `viewport`
3. Trova **Display → Window → Size**:
   - **Viewport Width**: `432`
   - **Viewport Height**: `240`

<!-- 📸 SCREENSHOT: Project Settings con Viewport Width e Height impostati a 432×240 -->

> [!IMPORTANT]
> **Perché 432×240?** È un rapporto 16:9 (come i monitor moderni) ma in miniatura. Con tile da 16×16 pixel, abbiamo **27 tile in orizzontale** e **15 in verticale** — abbastanza spazio per un platform game senza che le tile diventino microscopiche. È una risoluzione molto usata nei giochi indie in pixel art.

### Ingrandire la finestra

Se lanciassi il gioco ora, la finestra sarebbe minuscola (432×240 pixel reali sullo schermo — meno di mezzo pollice!). Dobbiamo dire a Godot di **ingrandire** la finestra.

Sempre in **Project Settings → Display → Window → Size**:

- **Window Width Override**: `1296`
- **Window Height Override**: `720`

Questi sono esattamente 432×3 e 240×3 — la finestra è **3 volte più grande** del viewport.

> [!NOTE]
> L'**override** cambia solo la dimensione della finestra sullo schermo, non la risoluzione interna del gioco. Il gioco continua a "pensare" in 432×240 pixel, ma li mostra ingranditi 3 volte.

### Stretch Mode: Viewport

Questo è il passaggio cruciale per la pixel art:

1. Sempre in **Project Settings**, cerca `stretch`
2. Trova **Display → Window → Stretch → Mode**
3. Cambia da `disabled` a **`viewport`**

<!-- 📸 SCREENSHOT: Project Settings con Stretch Mode impostato su "viewport" -->

> [!IMPORTANT]
> **Cosa cambia?** Con Stretch Mode `disabled`, Godot renderizza il gioco alla risoluzione della finestra (1296×720) e i pixel della pixel art vengono interpolati — tutto diventa sfumato. Con `viewport`, il gioco viene renderizzato alla risoluzione piccola (432×240) e poi l'immagine viene ingrandita alla dimensione della finestra. Ogni pixel resta un quadratino netto.

### Filtro texture: Nearest

L'ultimo passaggio per la pixel art perfetta:

1. In **Project Settings**, cerca `filter`
2. Trova **Rendering → Textures → Canvas Textures → Default Texture Filter**
3. Cambia da `Linear` a **`Nearest`**

<!-- 📸 SCREENSHOT: Project Settings con Default Texture Filter impostato su Nearest -->

> [!IMPORTANT]
> **Linear vs Nearest:** quando Godot ingrandisce un'immagine, deve decidere come calcolare i pixel intermedi.
> - **Linear** media i colori dei pixel vicini → l'immagine diventa **sfumata** e morbida
> - **Nearest** prende il pixel più vicino senza mediare → l'immagine resta **nitida** con quadratini netti
>
> Per la pixel art vuoi sempre Nearest. Per un gioco con grafica HD vorresti Linear.

### Riepilogo

```
Viewport:              432 × 240 pixel
Finestra:             1296 × 720 pixel (3×)
Stretch Mode:         viewport
Default Texture Filter: Nearest
```

---

## 3. Nominare i layer di collisione

In un gioco ci sono oggetti diversi che devono interagire in modi diversi: il player cammina sul pavimento ma non sulle monete, i nemici non raccolgono le monete, ecc. Godot gestisce questo con i **physics layer** (→ [approfondimento sui layer di collisione](layer-di-collisione.md)).

Conviene nominarli **subito**, prima di creare qualsiasi scena, così ogni nodo fisico che aggiungiamo saprà già a quale layer appartiene.

1. Vai in **Project** → **Project Settings...**
2. Nella barra di ricerca, scrivi `layer names`
3. Trova la sezione **Layer Names → 2D Physics**
4. Nomina i primi 5 layer:

| Layer | Nome |
|---|---|
| 1 | `Player` |
| 2 | `Moving Platforms` |
| 3 | `Pickups` |
| 4 | `Tiles` |
| 5 | `Killzone` |

<!-- 📸 SCREENSHOT: Project Settings con i 5 physics layer nominati -->

> [!TIP]
> I nomi non cambiano il funzionamento — servono solo per **ricordarti** cosa rappresenta ogni layer. Quando più avanti vedrai un nodo con Collision Layer = 4, saprai che è una "Tile" invece di dover ricordare a memoria il numero.

---

## 4. Creare la struttura delle cartelle

Un progetto Godot mette tutti i file in una sola cartella. Senza organizzazione, dopo poche lezioni avrai decine di file tutti insieme. Meglio creare subito una struttura ordinata.

1. Nel pannello **FileSystem**, fai **click destro** → **New Folder...**
2. Crea queste cartelle:

```
res://
├── assets/
│   ├── fonts/
│   ├── music/
│   ├── sounds/
│   └── sprites/
├── scenes/
└── scripts/
```

| Cartella | Cosa ci metti |
|---|---|
| `assets/sprites/` | Immagini: personaggi, nemici, tile, monete |
| `assets/fonts/` | Font per testi e punteggi |
| `assets/sounds/` | Effetti sonori (salto, moneta, esplosione...) |
| `assets/music/` | Musica di sottofondo |
| `scenes/` | Le scene del gioco (file `.tscn`) |
| `scripts/` | Gli script GDScript (file `.gd`) |

> [!IMPORTANT]
> **Perché separare scene e script?** Potresti salvare tutto nella stessa cartella — Godot funziona lo stesso. Ma quando il progetto cresce e hai 15 scene e 15 script tutti insieme, trovare il file giusto diventa frustrante. Separare per tipo è un'abitudine che ti risparmia tempo.

---

## 5. Importare gli asset

Gli asset sono tutti i file di contenuto: immagini, suoni, musica, font. Puoi scaricarli da siti come [itch.io](https://itch.io/game-assets/free), [Kenney.nl](https://www.kenney.nl/assets) o [OpenGameArt](https://opengameart.org/).

Per importarli in Godot:

1. **Trascina** i file dal tuo computer direttamente nel pannello **FileSystem** di Godot, nella cartella giusta
2. Oppure **copia** i file nella cartella del progetto usando Esplora File / Finder — Godot li rileva automaticamente

<!-- 📸 SCREENSHOT: pannello FileSystem con i file trascinati nella cartella assets/sprites -->

Quando Godot rileva un nuovo file, lo **importa** automaticamente: crea un file `.import` accanto ad esso. Questi file `.import` non vanno toccati — li gestisce Godot internamente.

### Gli asset del nostro corso

Ecco i file che abbiamo messo nella cartella `assets/` per il corso:

**Sprites** (`assets/sprites/`):

| File | Cosa contiene |
|---|---|
| `knight.png` | Spritesheet del player — griglia 8×8, frame da 32×32 pixel. Contiene tutte le animazioni: idle, corsa, salto, caduta, morte |
| `world_tileset.png` | L'immagine con tutte le tile del livello (erba, terra, pietre, piattaforme...) |
| `world_tileset_resource.tres` | La risorsa TileSet che referenzia `world_tileset.png` e definisce la griglia di tile |
| `coin.png` | Spritesheet dell'animazione della moneta |
| `fruit.png` | Spritesheet dei frutti raccoglibili |
| `platforms.png` | Immagine con le piattaforme mobili |
| `slime_green.png` | Spritesheet del nemico slime verde |
| `slime_purple.png` | Spritesheet del nemico slime viola |

**Suoni** (`assets/sounds/`):

| File | Quando si sente |
|---|---|
| `jump.wav` | Il player salta |
| `coin.wav` | Si raccoglie una moneta |
| `hurt.wav` | Il player viene colpito |
| `explosion.wav` | Un nemico viene eliminato |
| `power_up.wav` | Si raccoglie un potenziamento |
| `tap.wav` | Suono generico di interfaccia |

**Musica** (`assets/music/`):

| File | Uso |
|---|---|
| `time_for_adventure.mp3` | Musica di sottofondo del gioco |

**Font** (`assets/fonts/`):

| File | Uso |
|---|---|
| `PixelOperator8.ttf` | Font pixel art per testi normali |
| `PixelOperator8-Bold.ttf` | Versione bold per titoli e punteggi |

---

## 6. Creare il TileSet

Il TileSet è la risorsa che dice a Godot come tagliare l'immagine delle tile e quali proprietà ha ciascuna tile (collisione, animazione, ecc.).

Nel nostro progetto il TileSet è già salvato come file (`world_tileset_resource.tres`). Ecco come crearlo da zero:

1. Apri la scena che contiene un TileMapLayer (o creane uno temporaneo)
2. Seleziona il TileMapLayer, nell'Inspector clicca su **Tile Set** → **New TileSet**
3. Si apre il pannello **TileSet** in basso
4. Trascina l'immagine `world_tileset.png` dal FileSystem nel pannello TileSet
5. Godot chiede come dividere l'immagine — seleziona **Atlas** e conferma
6. L'immagine viene divisa automaticamente in tile (nel nostro caso 16×16 pixel, la dimensione di default del TileSet)

<!-- 📸 SCREENSHOT: pannello TileSet con l'immagine world_tileset.png importata e divisa in tile -->

### Aggiungere le collisioni alle tile

Le tile del pavimento hanno bisogno di **collisioni** — altrimenti il player le attraversa.

1. Nel pannello TileSet, clicca su **TileSet** (in alto) → **Physics Layers** → **Add Element**
2. Questo aggiunge un layer di fisica al TileSet
3. Ora seleziona una tile nel pannello e nella sezione **Physics** puoi disegnarci sopra una forma di collisione (di default un rettangolo che copre tutta la tile)

<!-- 📸 SCREENSHOT: pannello TileSet con una tile selezionata e la collisione disegnata sopra -->

> [!IMPORTANT]
> **Non tutte le tile hanno bisogno di collisione.** Le tile dello sfondo (cielo, decorazioni) non devono averla — il player non ci cammina sopra. Solo le tile delle piattaforme e del pavimento hanno bisogno della forma di collisione.

### Salvare il TileSet come file separato

Se hai più TileMapLayer che usano lo stesso TileSet (come nel nostro caso — background, platforms e foreground usano tutti `world_tileset_resource.tres`), conviene salvarlo come **file separato**:

1. Nell'Inspector del TileMapLayer, clicca sulla risorsa TileSet
2. Clicca sull'icona **💾** (Save) → **Save As...**
3. Salva come `res://assets/sprites/world_tileset_resource.tres`

Ora puoi assegnare lo stesso file TileSet a tutti i TileMapLayer senza duplicarlo.

---

## 7. Creare la scena principale

L'ultimo passaggio è creare la scena principale — il contenitore di tutto il gioco:

1. **Scene** → **New Scene**
2. Scegli **Node2D** come nodo radice
3. Rinominalo in `Game`
4. Salva come `res://scenes/game.tscn`
5. Imposta questa scena come **scena principale**: menu **Project** → **Project Settings** → **General** → **Application** → **Run** → **Main Scene** → seleziona `game.tscn`

A questo punto il progetto è esattamente nello stato della cartella `lezione-01` del corso: un progetto configurato, con gli asset pronti e una scena vuota pronta per essere riempita.

---

## Riepilogo

Ecco tutto quello che abbiamo fatto:

| Passo | Cosa |
|---|---|
| 1 | Creato un nuovo progetto Godot |
| 2 | Configurato viewport (432×240), finestra (1296×720), stretch mode (viewport), filtro (nearest) |
| 3 | Nominato i 5 physics layer |
| 4 | Creato la struttura delle cartelle (assets, scenes, scripts) |
| 5 | Importato tutti gli asset (sprites, suoni, musica, font) |
| 6 | Creato il TileSet con le collisioni |
| 7 | Creato la scena principale `game.tscn` |

Se vuoi creare un gioco tuo da zero, questi sono i passaggi da seguire ogni volta. I numeri specifici (risoluzione, nomi dei layer, ecc.) cambieranno in base al gioco che vuoi fare, ma la procedura è sempre questa.
