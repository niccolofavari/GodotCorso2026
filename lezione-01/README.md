# Lezione 01 – Scena, Player e TileMap

In questa lezione partiamo da zero e costruiamo la struttura base del gioco: la scena principale, il personaggio giocabile e il livello fatto con le tile.

---

## Cosa abbiamo fatto

- Creato la **scena principale** (`game.tscn`) con tre layer di TileMap
- Creato la **scena Player** (`player.tscn`) con sprite animato e collisione
- Scritto il primo script di movimento del player
- Importato e configurato il **TileSet**

---

## La scena principale

La scena `Game` è un `Node2D` con tre `TileMapLayer` figli:

| Layer | Scopo |
|---|---|
| `background` | Sfondo decorativo (non solido) |
| `platforms` | Piattaforme su cui il player cammina (con collisione) |
| `foreground` | Elementi davanti al player (decorativi) |

Tutti e tre usano lo stesso TileSet (`world_tileset_resource.tres`).

---

## Il Player

Il player è un `CharacterBody2D` con:
- `AnimatedSprite2D` → animazione idle con 4 frame dal spritesheet `knight.png`
- `CollisionShape2D` → forma circolare (radius 5px) centrata sui piedi

### Script di movimento (`player.gd`)

```gdscript
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
    # Gravità
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Salto
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
- `_physics_process(delta)` → viene chiamato ogni frame fisico (60fps di default)
- `get_gravity()` → legge la gravità dai Project Settings
- `move_and_slide()` → muove il corpo gestendo automaticamente le collisioni
- `is_on_floor()` → true se il player è appoggiato su una superficie
- `move_toward(x, 0, SPEED)` → decelera gradualmente fino a fermarsi

### Controlli

| Tasto | Azione |
|---|---|
| ← → (frecce) | Movimento orizzontale |
| Spazio / Enter | Salto |
| Esc | Esci dal gioco |

---

## Concetti Godot introdotti

- **Scene e nodi**: ogni scena è un albero di nodi
- **Istanze**: il player è una scena separata istanziata dentro `game.tscn`
- **CharacterBody2D**: corpo fisico pensato per i personaggi controllati dal codice
- **TileMapLayer**: sistema per disegnare livelli con tile ripetute
- **AtlasTexture**: ritaglio di una porzione da uno spritesheet
- **SpriteFrames**: raccolta di frame per le animazioni
