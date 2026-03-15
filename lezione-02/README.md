# Lezione 02 – Scena, Player e TileMap

In questa lezione partiamo da zero e costruiamo la struttura base del gioco: la scena principale, il personaggio giocabile e il livello fatto con le tile.

---

## Cosa costruiamo oggi

- La **scena principale** (`game.tscn`) — il contenitore di tutto il gioco
- La **scena Player** (`player.tscn`) — il personaggio che controlliamo
- Il **TileMap** — il livello disegnato con le tile
- Il primo script di **movimento**

<!-- SCREENSHOT: risultato finale della lezione — player che cammina sul livello -->

---

## 1. La scena principale

In Godot, ogni gioco è fatto di **scene**. Una scena è un albero di **nodi**, ognuno con uno scopo preciso.

<!-- SCREENSHOT: albero della scena Game con i tre TileMapLayer visibili nel pannello Scene -->

Crea una nuova scena con un nodo radice **Node2D** e salvala come `game.tscn` nella cartella `scenes/`.

Dentro `Game` aggiungi tre nodi **TileMapLayer**, uno per ogni piano del livello:

| Layer | Scopo |
|---|---|
| `TileMapLayer background` | Sfondo decorativo (non solido) |
| `TileMapLayer platforms` | Piattaforme su cui il player cammina (con collisione) |
| `TileMapLayer foreground` | Elementi davanti al player (decorativi) |

Tutti e tre usano lo stesso TileSet (`world_tileset_resource.tres`), che trovi già pronto in `assets/sprites/`.

> [!TIP]
> → [Cosa sono gli asset e come Godot li importa?](../appendice/asset.md)

---

## 2. Il Player

Il player è una scena separata (`player.tscn`). Separare il player dalla scena principale ci permette di riutilizzarlo facilmente in livelli diversi.

La struttura della scena è:

```
CharacterBody2D        ← root: gestisce la fisica
├── AnimatedSprite2D   ← l'immagine animata del personaggio
└── CollisionShape2D   ← la forma usata per le collisioni
```

### CharacterBody2D

È il tipo di nodo pensato per i personaggi controllati dal codice. Gestisce automaticamente la gravità, il pavimento e le collisioni con l'ambiente.

> [!NOTE]
> → [Approfondimento sui tipi di corpo fisico](../appendice/layer-di-collisione.md)

### AnimatedSprite2D

Mostra l'animazione del personaggio. Usa un **SpriteFrames** — una raccolta di frame ritagliati dallo spritesheet `knight.png`.

<!-- SCREENSHOT: pannello SpriteFrames con l'animazione idle aperta e i 4 frame visibili -->

Per creare l'animazione `idle`:
1. Seleziona `AnimatedSprite2D` → Inspector → **Sprite Frames** → **New SpriteFrames**
2. In basso si apre il pannello SpriteFrames — rinomina l'animazione `default` in `idle`
3. Clicca sul bottone **Add Frames from Sprite Sheet** (l'icona con la griglia)
4. Seleziona `assets/sprites/knight.png`, imposta griglia **8×8**, frame size **32×32**
5. Seleziona i 4 frame della riga `IDLE` e clicca **Add 4 Frame(s)**

<!-- SCREENSHOT: dialog "Select Frames" con i 4 frame IDLE selezionati -->

Imposta **Autoplay** su `idle` così l'animazione parte subito.

### CollisionShape2D

Definisce la forma fisica del player — quella che "tocca" davvero il mondo.

Usa una **CircleShape2D** con raggio 5px, centrata ai piedi del personaggio (`position Y = -5`).

<!-- SCREENSHOT: player nel viewport con la forma di collisione cerchio visibile in verde -->

---

## 3. Script di movimento

Seleziona il nodo `CharacterBody2D` e aggiungi uno script. Scegli il template **CharacterBody2D: Basic Movement** — Godot genera già lo scheletro giusto per un platform game.

<!-- SCREENSHOT: dialog "Attach Node Script" con il template Basic Movement selezionato -->

Salva lo script in `scripts/player.gd`. Il codice finale:

```gdscript
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -270.0

func _physics_process(delta: float) -> void:
    # Gravità: se siamo in aria, acceleriamo verso il basso
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Salto: solo se siamo a terra
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Movimento orizzontale
    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
```

**Concetti chiave:**

| Funzione | Cosa fa |
|---|---|
| `_physics_process(delta)` | Viene chiamata 60 volte al secondo (ogni frame fisico) |
| `get_gravity()` | Legge la gravità dai Project Settings |
| `is_on_floor()` | Vale `true` se il player è appoggiato su una superficie |
| `move_toward(x, 0, SPEED)` | Decelera gradualmente fino a fermarsi |
| `move_and_slide()` | Muove il corpo gestendo le collisioni automaticamente |

> [!NOTE]
> `delta` è il tempo trascorso dall'ultimo frame in secondi. Moltiplicare per `delta` rende il movimento indipendente dalla velocità del computer.

### Controlli

| Tasto | Azione |
|---|---|
| ← → (frecce) | Movimento orizzontale |
| Spazio / Enter | Salto |
| Esc | Esci dal gioco |

---

## 4. Istanzia il Player nella scena principale

Per mettere il player nel livello:

1. Apri `game.tscn`
2. Clicca sul bottone **Link** (istanzia scena figlia) nel pannello Scene
3. Seleziona `player.tscn`

<!-- SCREENSHOT: scena game.tscn con il player istanziato, visibile nel viewport sul livello -->

Premi **▶** per provare. Il player dovrebbe muoversi e saltare!

---

## Concetti Godot introdotti

- **Scene e nodi**: ogni scena è un albero di nodi; ogni nodo ha uno scopo preciso
- **Istanze**: il player è una scena separata "incollata" dentro `game.tscn`
- **CharacterBody2D**: corpo fisico per personaggi controllati da codice
- **TileMapLayer**: sistema per costruire livelli con tile ripetute
- **SpriteFrames**: raccolta di frame per le animazioni
- **AtlasTexture**: ritaglio di una singola immagine da uno spritesheet
