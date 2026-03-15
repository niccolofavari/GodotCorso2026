# Asset

---

## Cosa sono gli asset

Nel mondo dei videogiochi, **asset** è il termine che indica tutti i file di contenuto che compongono il gioco — tutto ciò che non è codice:

- 🖼️ **Immagini** — personaggi, nemici, tile, sfondi, effetti visivi
- 🔊 **Effetti sonori** — il suono del salto, della moneta raccolta, dell'esplosione
- 🎵 **Musica** — la colonna sonora
- 🔤 **Font** — i caratteri per testi, punteggi, menu
- 🎬 **Animazioni**, **video**, **modelli 3D**...

In un gioco professionale, la produzione degli asset è spesso la parte che richiede più tempo e più persone. Per il nostro corso, usiamo asset gratuiti già pronti.

---

## Sprite

Uno **sprite** è un'immagine 2D usata nel gioco — il personaggio, un nemico, una moneta, un albero. Il termine viene dai primi videogiochi, dove gli oggetti in movimento erano chiamati "sprites" (spiriti, fantasmi — perché si muovevano sopra lo sfondo senza farne parte).

In un gioco moderno in 2D, quasi tutto quello che vedi sullo schermo è uno sprite.

---

## Spritesheet

Uno **spritesheet** è una singola immagine che contiene **molti frame** disposti in una griglia. Invece di avere 20 file separati per 20 frame di un'animazione, hai un unico file con tutti i frame affiancati.

Nel nostro corso, `knight.png` è uno spritesheet:

```
┌────┬────┬────┬────┬────┬────┬────┬────┐
│ i1 │ i2 │ i3 │ i4 │    │    │    │    │  ← riga 1: idle (4 frame)
├────┼────┼────┼────┼────┼────┼────┼────┤
│ r1 │ r2 │ r3 │ r4 │ r5 │ r6 │    │    │  ← riga 2: corsa (6 frame)
├────┼────┼────┼────┼────┼────┼────┼────┤
│ j1 │ j2 │    │    │    │    │    │    │  ← riga 3: salto (2 frame)
├────┼────┼────┼────┼────┼────┼────┼────┤
│ ...│    │    │    │    │    │    │    │  ← altre animazioni...
└────┴────┴────┴────┴────┴────┴────┴────┘

Griglia: 8 colonne × 8 righe
Ogni frame: 32 × 32 pixel
Immagine totale: 256 × 256 pixel
```

Godot sa come **ritagliare** i singoli frame da uno spritesheet — basta dirgli le dimensioni della griglia (nel nostro caso 8×8) e selezionare i frame che ci servono.

> [!IMPORTANT]
> **Perché uno spritesheet e non file separati?** Tre motivi:
> 1. **Efficienza** — caricare un file è più veloce che caricarne 20
> 2. **Organizzazione** — tutte le animazioni di un personaggio in un unico file
> 3. **Performance** — la scheda grafica è più efficiente se le texture sono in un'unica immagine grande

---

## Come Godot gestisce gli asset

Quando metti un file nella cartella del progetto, Godot lo **importa automaticamente**. L'importazione converte il file in un formato ottimizzato per il motore di gioco.

Per ogni file importato, Godot crea un file `.import` accanto:

```
knight.png              ← il tuo file originale
knight.png.import       ← le impostazioni di importazione (generato da Godot)
```

> [!WARNING]
> **Non toccare i file `.import`** — li gestisce Godot. Non cancellarli, non modificarli, non rinominarli. Se cancelli un file `.import`, Godot lo ricrea automaticamente la prossima volta che apri il progetto.

### Reimportare con impostazioni diverse

A volte devi cambiare come Godot importa un file. Per esempio, di default le immagini vengono importate con il filtro Linear (sfumato) — per la pixel art vuoi Nearest.

Nel nostro progetto abbiamo già impostato il filtro **Nearest** come default globale (vedi → [Risoluzione e Viewport](risoluzione.md)), quindi tutte le immagini vengono importate correttamente. Ma se dovessi cambiarlo per un singolo file:

1. Seleziona il file nel FileSystem
2. Vai nella tab **Import** (accanto a Scene, in alto)
3. Cambia le impostazioni
4. Clicca **Reimport**

---

## Gli asset del nostro corso

### Sprites (`assets/sprites/`)

| File | Dimensione | Contenuto |
|---|---|---|
| `knight.png` | 256×256 (griglia 8×8, frame 32×32) | Tutte le animazioni del player: idle, corsa, salto, caduta, morte |
| `world_tileset.png` | Variabile | L'immagine con tutte le tile del livello |
| `world_tileset_resource.tres` | — | Risorsa TileSet (non è un'immagine, è un file di Godot che referenzia il tileset e definisce le tile) |
| `coin.png` | Spritesheet | Animazione della moneta che gira |
| `fruit.png` | Spritesheet | Frutti raccoglibili |
| `platforms.png` | Spritesheet | Piattaforme mobili (diverse varianti affiancate) |
| `slime_green.png` | Spritesheet | Animazioni del nemico slime verde |
| `slime_purple.png` | Spritesheet | Animazioni del nemico slime viola |

### Effetti sonori (`assets/sounds/`)

| File | Formato | Quando si sente |
|---|---|---|
| `jump.wav` | WAV | Il player salta |
| `coin.wav` | WAV | Si raccoglie una moneta |
| `hurt.wav` | WAV | Il player subisce danno |
| `explosion.wav` | WAV | Un nemico viene eliminato |
| `power_up.wav` | WAV | Si raccoglie un potenziamento |
| `tap.wav` | WAV | Suono generico di interfaccia |

### Musica (`assets/music/`)

| File | Formato | Uso |
|---|---|---|
| `time_for_adventure.mp3` | MP3 | Musica di sottofondo del gioco, in loop |

### Font (`assets/fonts/`)

| File | Uso |
|---|---|
| `PixelOperator8.ttf` | Font pixel art per testi normali |
| `PixelOperator8-Bold.ttf` | Versione bold per titoli e punteggi |

> [!NOTE]
> **WAV vs MP3**: gli effetti sonori sono in **WAV** (non compresso, qualità massima, file più grandi). La musica è in **MP3** (compresso, file più piccolo). La regola pratica: WAV per suoni brevi e frequenti, MP3 per musica lunga.

---

## Dove trovare asset gratuiti

Se vuoi cercare asset per un tuo gioco:

| Sito | Cosa trovi |
|---|---|
| [itch.io/game-assets](https://itch.io/game-assets/free) | Migliaia di asset gratuiti: sprite, tileset, suoni, musica. Il posto migliore da cui iniziare |
| [Kenney.nl](https://www.kenney.nl/assets) | Asset di altissima qualità, tutti gratuiti e con licenza libera (puoi usarli anche in giochi commerciali) |
| [OpenGameArt](https://opengameart.org/) | Grafica, suoni e musica open source |
| [Freesound](https://freesound.org/) | Enorme libreria di suoni caricati dalla community |

> [!TIP]
> Quando scarichi asset, controlla sempre la **licenza**. La maggior parte degli asset gratuiti richiede di citare l'autore (attribution). Alcuni sono completamente liberi (come quelli di Kenney). Leggi sempre il file LICENSE o la descrizione sulla pagina di download.
