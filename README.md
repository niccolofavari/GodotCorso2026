# Godot Corso 2026

Materiale del corso di sviluppo videogiochi con **Godot 4**, pensato per studenti di terza liceo artistico — nessuna esperienza di programmazione richiesta.

In **5 lezioni da 2 ore** costruiamo insieme un **platform game 2D in pixel art** partendo da zero: un personaggio che si muove e salta, un livello fatto con le tile, piattaforme mobili, nemici, monete e un punteggio. Ogni lezione aggiunge un pezzo al gioco, e alla fine della settimana hai un gioco completo che funziona.

<!-- 📸 SCREENSHOT: il gioco finito in esecuzione — player sul livello con monete, nemici, punteggio visibile -->

---

## Come funziona

Ogni lezione ha la sua **cartella** con un progetto Godot completo. Il progetto dentro la cartella è il **punto di partenza** della lezione — il README ti guida passo per passo fino al risultato, che trovi nella cartella della lezione successiva.

```
lezione-01/  →  apri questo progetto, segui il README  →  arrivi allo stato di lezione-02/
lezione-02/  →  apri questo progetto, segui il README  →  arrivi allo stato di lezione-03/
lezione-03/  →  apri questo progetto, segui il README  →  arrivi allo stato di lezione-04/
...e così via
```

Se ti perdi o qualcosa non funziona, puoi sempre **aprire la cartella della lezione successiva** per vedere il risultato finito e confrontarlo con il tuo.

### Per iniziare

1. **Scarica Godot 4** da [godotengine.org](https://godotengine.org/) (versione normale, non .NET)
2. **Scarica questo repository**: bottone verde **Code** → **Download ZIP** in alto a destra
3. Decomprimi lo ZIP e apri la cartella `lezione-01` in Godot
4. Leggi il README della lezione e segui i passaggi

---

## Lezioni

| # | Lezione | Cosa costruiamo |
|---|---|---|
| 01 | [Il primo livello e il primo personaggio](lezione-01/README.md) | Installiamo Godot, costruiamo il livello con le tile, creiamo il player con animazione e collisione, scriviamo il primo script di movimento |
| 02 | [Camera, velocità e piattaforme mobili](lezione-02/README.md) | Rallentiamo il player, aggiungiamo la Camera2D con limiti, creiamo piattaforme mobili con AnimationPlayer |
| 03 | [Animazioni e macchina a stati](lezione-03/README.md) | Aggiungiamo le animazioni di corsa, salto e capriola, riscriviamo lo script di movimento con una macchina a stati |
| 04 | [Nemici, monete e killzone](lezione-04/README.md) | Creiamo le monete da raccogliere, i nemici che pattugliano e le zone mortali con effetto slow-motion |
| 05 | Suoni, musica, punteggio e rifinitura | *In arrivo* |

> [!NOTE]
> Le lezioni vengono pubblicate progressivamente durante l'anno. Se una lezione non è ancora cliccabile, sarà disponibile a breve.

---

## Approfondimenti

Nella cartella **[appendice/](appendice/README.md)** trovi le spiegazioni approfondite dei concetti tecnici che incontriamo durante il corso. Sono linkate direttamente dai README delle lezioni quando servono, ma puoi leggerle anche per conto tuo.

| Approfondimento | Descrizione |
|---|---|
| [Creare il progetto da zero](appendice/progetto-da-zero.md) | Tutti i passaggi per creare un progetto Godot da zero e arrivare allo stato della lezione 01 |
| [Risoluzione, Viewport e Finestra](appendice/risoluzione.md) | Perché il gioco è 432×240, come viene ingrandito, Stretch Mode e filtro Nearest |
| [Layer di collisione](appendice/layer-di-collisione.md) | Come Godot decide chi collide con chi, con la tabella completa del nostro gioco |
| [Asset](appendice/asset.md) | Cosa sono sprite, spritesheet, suoni, come Godot li importa, e dove trovarne di gratuiti |

---

## Risorse utili

Una raccolta di strumenti e materiali gratuiti per fare giochi — da esplorare anche fuori dal corso.

### 🎮 Imparare Godot

| Risorsa | Descrizione |
|---|---|
| [Documentazione ufficiale Godot 4](https://docs.godotengine.org/en/stable/) | Il manuale completo. Cerca qui prima di tutto |
| [Tutorial Godot di Brackeys](https://www.youtube.com/watch?v=LOhfqjmasi0) | Il tutorial più famoso per iniziare con Godot 4 — in inglese ma molto chiaro |

### 🖼️ Grafica e sprite

| Risorsa | Descrizione |
|---|---|
| [itch.io – Free Game Assets](https://itch.io/game-assets/free) | Migliaia di asset gratuiti: sprite, tileset, font, animazioni |
| [Kenney.nl](https://www.kenney.nl/assets) | Asset di altissima qualità, tutti gratuiti con licenza libera |
| [OpenGameArt](https://opengameart.org/) | Grafica, suoni e musica open source |

### 🔊 Effetti sonori

| Risorsa | Descrizione |
|---|---|
| [Bfxr](https://www.bfxr.net/) | Genera effetti sonori retrò nel browser (salti, esplosioni, power-up...) |
| [sfxr](https://sfxr.me/) | Simile a Bfxr, semplicissimo da usare |
| [Freesound](https://freesound.org/) | Enorme libreria di suoni gratuiti |
| [Kenney – Audio](https://www.kenney.nl/assets?q=audio) | Pacchetti di effetti sonori pronti all'uso |

### 🎵 Musica

| Risorsa | Descrizione |
|---|---|
| [BeepBox](https://www.beepbox.co/) | Crea musica chiptune (8-bit) nel browser, zero installazioni |

### ✏️ Pixel art

| Risorsa | Descrizione |
|---|---|
| [Aseprite](https://www.aseprite.org/) | Il miglior editor di pixel art (a pagamento, oppure compilabile gratis dal sorgente) |
| [Libresprite](https://libresprite.github.io/) | Fork gratuito e open source di Aseprite |
| [Piskel](https://www.piskelapp.com/) | Editor di pixel art online, perfetto per iniziare |

### 📚 Altro

| Risorsa | Descrizione |
|---|---|
| [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) | Guida completa al linguaggio GDScript |
| [Game Maker's Toolkit](https://www.youtube.com/@GMTK) | Canale YouTube sul game design: perché i giochi funzionano come funzionano |
