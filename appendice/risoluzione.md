# Risoluzione, Viewport e Finestra

---

## La risoluzione

La **risoluzione** è il numero di pixel che compongono l'immagine del gioco. Si esprime come **larghezza × altezza**: ad esempio, 1920×1080 significa 1920 pixel in orizzontale e 1080 in verticale.

Più alta è la risoluzione, più dettaglio puoi mostrare. Ma per un gioco in **pixel art**, una risoluzione alta è un problema: i singoli pixel diventano così piccoli che non si vedono, e il punto della pixel art è proprio che ogni pixel sia visibile e deliberato.

### La risoluzione del nostro gioco: 432×240

Nel nostro gioco usiamo una risoluzione di **432×240 pixel**. Sembra piccolissima — e lo è, intenzionalmente. Ecco i motivi:

- Con tile da **16×16 pixel**, abbiamo **27 tile in orizzontale** e **15 in verticale**. È abbastanza spazio per un livello di un platform game
- Il rapporto è **16:9** (lo stesso dei monitor moderni), quindi non ci sono bande nere ai lati
- È un multiplo comodo: 432 = 16 × 27, 240 = 16 × 15. Nessuna tile viene tagliata a metà ai bordi dello schermo

> [!NOTE]
> Non esiste una risoluzione "giusta" per la pixel art — dipende dal gioco. Celeste usa 320×180, Undertale usa 640×480, Shovel Knight usa 400×240. La cosa importante è scegliere una risoluzione che sia un **multiplo intero** della dimensione delle tile, e che il rapporto sia 16:9 (o 4:3) per adattarsi ai monitor.

---

## Il Viewport

Il **viewport** è il rettangolo che il giocatore vede — l'inquadratura del gioco. Nel nostro caso, il viewport misura **432×240 pixel**: è esattamente la risoluzione interna del gioco.

Tutto quello che succede nel gioco (il player che si muove, le tile, i nemici) viene **disegnato dentro il viewport** a questa risoluzione. Pensa al viewport come al "foglio" su cui Godot disegna ogni frame del gioco.

In Godot, la dimensione del viewport si imposta in:

**Project** → **Project Settings** → **Display** → **Window** → **Size** → **Viewport Width / Viewport Height**

---

## La finestra

432×240 pixel su un monitor moderno sarebbero **minuscoli** — una finestrella microscopica. Quindi Godot **ingrandisce** il viewport per riempire la finestra.

Noi impostiamo la finestra a **1296×720 pixel** — esattamente **3 volte** la dimensione del viewport:

```
432 × 3 = 1296
240 × 3 = 720
```

Questo moltiplicatore intero (3×) è fondamentale per la pixel art: ogni pixel del gioco diventa un **quadrato di 3×3 pixel** sullo schermo. Se il moltiplicatore non fosse intero (es. 2.5×), alcuni pixel sarebbero più grandi di altri e l'immagine risulterebbe **irregolare e sfocata**.

In Godot, la dimensione della finestra si imposta in:

**Project** → **Project Settings** → **Display** → **Window** → **Size** → **Window Width Override / Window Height Override**

---

## Stretch Mode

Lo **Stretch Mode** dice a Godot **come** adattare il contenuto del viewport alla finestra. Ci sono diverse opzioni, ma per la pixel art ne conta una sola: **`viewport`**.

| Stretch Mode | Cosa fa | Quando usarla |
|---|---|---|
| `disabled` | Il viewport non viene scalato — resta piccolo nella finestra grande | Mai per pixel art |
| `canvas_items` | Ridisegna tutto alla risoluzione della finestra | Giochi HD, interfacce scalabili |
| **`viewport`** | **Renderizza alla risoluzione del viewport, poi ingrandisce l'immagine** | **Pixel art** |

Con `viewport`, Godot:
1. Disegna tutto a 432×240 pixel (il viewport)
2. Prende l'immagine risultante e la ingrandisce a 1296×720 (la finestra)

Il risultato: pixel **netti e squadrati**, esattamente quello che vogliamo.

In Godot si imposta in:

**Project** → **Project Settings** → **Display** → **Window** → **Stretch** → **Mode**

---

## Filtro Texture: Nearest vs Linear

Quando Godot ingrandisce un'immagine (sia per lo stretch che per gli sprite nel viewport), deve decidere **come calcolare i pixel intermedi**. Questo si chiama **filtro texture**.

### Linear (il default)

Il filtro **Linear** calcola la **media** dei colori dei pixel vicini. Il risultato è un'immagine **morbida e sfumata** — ottima per grafica HD, pessima per pixel art. I bordi netti dei pixel diventano sfumature.

### Nearest (quello che usiamo noi)

Il filtro **Nearest** (nearest neighbor) prende il colore del pixel **più vicino**, senza calcolare medie. Il risultato è un'immagine **nitida con bordi netti** — ogni pixel originale diventa un quadratino perfetto.

> [!IMPORTANT]
> Per la pixel art, usa **sempre** Nearest. È la differenza tra un gioco che sembra retrò intenzionalmente e uno che sembra semplicemente sfocato.

In Godot si imposta in:

**Project** → **Project Settings** → **Rendering** → **Textures** → **Canvas Textures** → **Default Texture Filter** → `Nearest`

---

## Riepilogo della nostra configurazione

| Impostazione | Valore | Perché |
|---|---|---|
| Viewport | 432 × 240 | Risoluzione pixel art, 27×15 tile da 16px |
| Finestra | 1296 × 720 | Viewport × 3 — moltiplicatore intero |
| Stretch Mode | `viewport` | Renderizza piccolo, ingrandisce dopo |
| Texture Filter | `Nearest` | Pixel netti, nessuna sfumatura |

Per i passaggi pratici su come impostare tutto questo, vedi → [Creare il progetto da zero](progetto-da-zero.md).
