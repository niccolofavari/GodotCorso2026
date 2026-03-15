# Lezione 05 – Animazioni, Suoni, Musica e Score

In questa lezione finiamo il gioco: il player si anima in base a quello che fa, i suoni danno feedback alle azioni, la musica non si interrompe quando il gioco ricomincia, e un contatore mostra il punteggio sullo schermo.

---

## Cosa costruiamo oggi

- Animazioni **run**, **jump** e **idle** collegate al movimento del player
- Effetti sonori per salto e raccolta monete
- Musica di sottofondo **persistente** tra un riavvio e l'altro (Autoload)
- Testo **score** fisso in alto a sinistra

<!-- SCREENSHOT: gioco finito in esecuzione con HUD score visibile e player che corre -->

---

## 1. Animazioni del Player

Finora il player aveva solo l'animazione `idle`. Aggiungiamo `run` e `jump` dallo stesso spritesheet `knight.png`.

### Aggiungere le animazioni

Apri `player.tscn`, seleziona `AnimatedSprite2D` e apri il pannello **SpriteFrames**. Per ogni nuova animazione:

1. Clicca **+** per aggiungere una nuova animazione e rinominala
2. Clicca **Add Frames from Sprite Sheet**
3. Seleziona i frame corrispondenti dalla griglia 8×8 del knight

| Animazione | Riga nello sheet | Frame | FPS |
|---|---|---|---|
| `idle` | `IDLE` | 0→3 | 8 |
| `run` | `RUN` | prima riga | 8 |
| `jump` | una delle righe di salto | 0→3 | 8 |

<!-- SCREENSHOT: pannello SpriteFrames con le tre animazioni idle/run/jump -->
<!-- ??? Quali righe esatte dello sheet knight.png usi per run e jump? Confermami così metto i numeri giusti -->

### Script aggiornato (`player.gd`)

Il codice del movimento rimane uguale — aggiungiamo solo la logica per cambiare animazione:

```gdscript
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -270.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta

    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
        animated_sprite_2d.flip_h = direction < 0
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    _update_animation()

func _update_animation() -> void:
    if not is_on_floor():
        animated_sprite_2d.play("jump")
    elif velocity.x != 0:
        animated_sprite_2d.play("run")
    else:
        animated_sprite_2d.play("idle")
```

**Cosa è cambiato:**

| Aggiunta | Scopo |
|---|---|
| `@onready var animated_sprite_2d` | Riferimento diretto allo sprite per non cercarlo ogni frame |
| `flip_h = direction < 0` | Specchia lo sprite quando si va a sinistra |
| `_update_animation()` | Funzione separata che sceglie l'animazione giusta ogni frame |

> [!NOTE]
> Separare la logica di animazione in una funzione dedicata (`_update_animation`) tiene il codice leggibile — ogni funzione fa una cosa sola.

---

## 2. Effetti sonori

Gli effetti sonori vengono riprodotti tramite nodi **AudioStreamPlayer2D** dentro le scene che li usano.

### Suono del salto

Nel player, aggiungi un nodo figlio `AudioStreamPlayer2D`, chiamalo `JumpSound`, e trascinaci dentro `assets/sounds/jump.wav`.

Poi nello script, riproducilo quando il player salta:

```gdscript
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

# dentro _physics_process, dove gestiamo il salto:
if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY
    jump_sound.play()
```

### Suono della moneta

Nella scena `coin.tscn`, aggiungi un `AudioStreamPlayer2D` con `assets/sounds/coin.wav`. Il problema: se chiamiamo `queue_free()` sulla moneta, il suono viene distrutto prima di finire.

La soluzione è spostare la riproduzione del suono **prima** di distruggere la moneta, o riprodurlo da un nodo che sopravvive:

```gdscript
extends Area2D

@onready var coin_sound: AudioStreamPlayer2D = $CoinSound

func _on_body_entered(body: Node2D) -> void:
    coin_sound.play()
    await coin_sound.finished
    queue_free()
```

> [!NOTE]
> `await` mette in pausa l'esecuzione di quella funzione finché il segnale `finished` non viene emesso — nel frattempo il resto del gioco continua normalmente.

<!-- SCREENSHOT: scena coin.tscn con il nodo CoinSound visibile nell'albero -->

---

## 3. Musica persistente con Autoload

Il problema: ogni volta che il player muore, `reload_current_scene()` distrugge e ricrea tutto — incluso l'eventuale nodo musicale. La musica si interrompe di botto.

La soluzione è l'**Autoload**: un nodo che Godot carica una volta sola all'avvio e mantiene vivo per tutta la durata del gioco, indipendentemente da quale scena è aperta.

### Creare lo script della musica

Crea un nuovo script `scripts/music.gd`:

```gdscript
extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
    player.play()
```

Crea una scena minimale `scenes/music.tscn` con un nodo radice `Node` + uno script `music.gd` + un figlio `AudioStreamPlayer` con `assets/music/time_for_adventure.mp3` e **Autoplay** disabilitato (lo avviamo noi da `_ready`).

### Registrare l'Autoload

Vai in **Project → Project Settings → Autoload**, clicca su **+** e seleziona `scenes/music.tscn`. Dagli il nome `Music`.

<!-- SCREENSHOT: pannello Autoload in Project Settings con Music registrato -->

Da quel momento `Music` è accessibile da qualsiasi script del progetto come se fosse un singleton:

```gdscript
Music.player.stop()   # per fermare la musica se serve
```

> [!NOTE]
> → [Approfondimento sull'Autoload e i singleton in Godot](../appendice/layer-di-collisione.md)
> <!-- ??? Vuoi che aggiunga una pagina appendice/autoload.md? Sarebbe il posto giusto per spiegarlo in dettaglio -->

---

## 4. Score

Lo score è un elemento dell'**interfaccia** (HUD), non del mondo di gioco — deve restare fisso sullo schermo anche quando la camera si muove.

### Struttura della scena

Aggiungi alla scena `game.tscn` un nodo **CanvasLayer** con un figlio **Label**:

```
Game (Node2D)
├── ...
└── HUD (CanvasLayer)       ← si disegna sopra tutto, fisso sullo schermo
    └── ScoreLabel (Label)  ← il testo del punteggio
```

`CanvasLayer` è un layer di disegno separato che non viene influenzato dalla camera — perfetto per l'interfaccia.

<!-- SCREENSHOT: scena game.tscn con il CanvasLayer/HUD nell'albero dei nodi -->

### Configurare la Label

Nell'Inspector della `Label`:
- **Text**: `Score: 0`
- **Font**: `assets/fonts/PixelOperator8-Bold.ttf`
- **Position**: `(8, 8)` — piccolo margine dall'angolo in alto a sinistra

<!-- SCREENSHOT: gioco in esecuzione con la label score visibile in alto a sinistra -->

### Aggiornare lo score quando si raccoglie una moneta

Lo score vive nel nodo `Game`. Quando una moneta viene raccolta, deve comunicarlo alla scena padre.

Un modo semplice è usare un **gruppo**: il nodo `Game` si aggiunge al gruppo `game`, e la moneta lo trova tramite quello:

```gdscript
# in game.gd
extends Node2D

var score: int = 0

@onready var score_label: Label = $HUD/ScoreLabel

func _ready() -> void:
    add_to_group("game")

func add_score(points: int) -> void:
    score += points
    score_label.text = "Score: " + str(score)
```

```gdscript
# in coin.gd
func _on_body_entered(body: Node2D) -> void:
    var game = get_tree().get_first_node_in_group("game")
    if game:
        game.add_score(1)
    coin_sound.play()
    await coin_sound.finished
    queue_free()
```

> [!TIP]
> Un approccio alternativo — più robusto — è usare un secondo Autoload come `GameState` per tenere lo score globale. Per ora il gruppo va benissimo.

---

## Concetti Godot introdotti

- **Animazioni condizionali**: cambiare animazione in base allo stato del personaggio
- **`flip_h`**: specchiare uno sprite senza duplicare i frame
- **AudioStreamPlayer2D**: riproduce suoni ancorati a una posizione nel mondo
- **`await` + segnale**: aspetta che qualcosa finisca prima di continuare
- **Autoload / Singleton**: nodo globale che persiste tra i cambi di scena
- **CanvasLayer**: layer di disegno fisso sullo schermo, indipendente dalla camera
- **Label**: nodo di testo per l'interfaccia
