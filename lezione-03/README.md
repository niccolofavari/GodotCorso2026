# Lezione 03 – Nemici, Monete, Killzone e Area2D

In questa lezione aggiungiamo i primi elementi di gameplay: un nemico che pattuglia la mappa, monete raccoglibili e una killzone che ricarica la scena.

---

## Cosa abbiamo fatto

- Creato il **nemico** (`enemy.tscn`) con movimento automatico e RayCast2D
- Creato le **monete** (`coin.tscn`) raccoglibili tramite `Area2D`
- Creata la **killzone** (`killzone.tscn`) che fa morire il player con effetto slow-motion
- Introdotto il concetto di **Physics Layers** per gestire le collisioni selettive

---

## Il Nemico

Il nemico è un `Node2D` (non un CharacterBody, non ha la fisica integrata) che si muove orizzontalmente a velocità costante e inverte la direzione quando sta per cadere dal bordo.

### Script (`enemy.gd`)

```gdscript
extends Node2D

@onready var ray_cast_2d_right: RayCast2D = $"RayCast2D - right"
@onready var ray_cast_2d_left: RayCast2D = $"RayCast2D - left"
@onready var direction = 1

const SPEED = 35

func _physics_process(delta: float) -> void:
    position.x += SPEED * delta * direction

    if ray_cast_2d_right.is_colliding() == false:
        direction = -1

    if ray_cast_2d_left.is_colliding() == false:
        direction = 1
```

### I RayCast2D

Il nemico ha due `RayCast2D`, uno per lato, posizionati ai piedi e puntati verso il basso:

| RayCast | Posizione | Target |
|---|---|---|
| `RayCast2D - right` | `(8, 0)` | `(0, 5)` verso il basso |
| `RayCast2D - left` | `(-8, 0)` | `(0, 5)` verso il basso |

**Logica:** se il raycast destro non colpisce nulla (bordo a destra), inverti verso sinistra. Se il sinistro non colpisce nulla, inverti verso destra.

> ⚠️ **Attenzione al Collision Mask!** I RayCast2D devono avere nella loro maschera di collisione lo stesso layer del TileMap (Layer 4 – Tiles). Se la mask è sbagliata, i raggi non vedono le tile e il nemico non cambia mai direzione.

---

## La Killzone

La killzone è un `Area2D` che copre l'intera parte bassa della mappa. Quando il player ci cade dentro:

1. Viene rimosso il `CollisionShape2D` del player (per evitare altre collisioni)
2. Si attiva uno **slow-motion** (`Engine.time_scale = 0.1`)
3. Un `Timer` (ignorando il time scale) aspetta 1.5 secondi
4. La scena viene ricaricata

```gdscript
extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
    timer.ignore_time_scale = true
    body.get_node("CollisionShape2D").queue_free()
    Engine.time_scale = 0.1
    timer.start()

func _on_timer_timeout() -> void:
    Engine.time_scale = 1
    get_tree().reload_current_scene()
```

**Concetti chiave:**
- `Engine.time_scale` → scala la velocità di tutto il gioco (0.1 = 10% della velocità)
- `timer.ignore_time_scale = true` → il timer non viene rallentato dallo slow-motion
- `queue_free()` → rimuove il nodo in sicurezza a fine frame
- `reload_current_scene()` → ricarica la scena corrente (equivale a morire e ricominciare)

---

## Le Monete

Ogni moneta è un `Area2D` con animazione. Quando un corpo fisico la tocca, si distrugge:

```gdscript
extends Area2D

func _on_body_entered(body: Node2D) -> void:
    queue_free()
```

---

## Physics Layers

In questa lezione i layer di collisione diventano importanti. Ecco la mappa completa:

| Layer | Nome | Bitmask | Chi lo usa |
|---|---|---|---|
| 1 | Player | `1` | CharacterBody2D del player |
| 2 | Moving Platforms | `2` | AnimatableBody2D |
| 3 | Pickups | `4` | Monete (Area2D) |
| 4 | Tiles | `8` | TileMapLayer con collisioni |
| 5 | Killzone | `16` | Killzone (Area2D) |

> **Collision Layer** = "su quale layer si trova questo oggetto"  
> **Collision Mask** = "con quali layer questo oggetto interagisce"

---

## Concetti Godot introdotti

- **RayCast2D**: raggio che rileva collisioni in una direzione, utile per AI e detection
- **Area2D**: zona che rileva sovrapposizioni senza avere fisica rigida
- **Engine.time_scale**: slow-motion globale
- **Timer con ignore_time_scale**: timer indipendente dal time scale
- **Physics Layers e Mask**: sistema per controllare selettivamente quali oggetti collidono tra loro
- **`@onready`**: shortcut per ottenere riferimenti ai nodi figli quando la scena è pronta
