# Lezione 04 – Nemici, Monete, Killzone e Area2D

In questa lezione aggiungiamo i primi elementi di gameplay: un nemico che pattuglia la mappa, monete raccoglibili e una killzone che ricarica la scena quando il player cade.

---

## Cosa costruiamo oggi

- Il **nemico** (`enemy.tscn`) — si muove da solo e inverte la direzione ai bordi
- Le **monete** (`coin.tscn`) — spariscono quando il player le tocca
- La **killzone** (`killzone.tscn`) — fa "morire" il player con effetto slow-motion

<!-- SCREENSHOT: gioco in esecuzione con nemico, monete e killzone visibili -->

---

## 1. Il Nemico

Il nemico è un `Node2D` — non ha la fisica integrata come il player, si muove tramite codice modificando direttamente la sua posizione.

```
Node2D                 ← root
├── AnimatedSprite2D   ← animazione dello slime
├── Area2D             ← rileva il contatto con il player (killzone del nemico)
├── RayCast2D - right_foot  ← controlla se c'è pavimento a destra
├── RayCast2D - left_foot   ← controlla se c'è pavimento a sinistra
├── RayCast2D - right       ← controlla se c'è un muro a destra
└── RayCast2D - left        ← controlla se c'è un muro a sinistra
```

### Script (`enemy.gd`)

```gdscript
extends Node2D

@onready var ray_cast_2d_right_foot: RayCast2D = $"RayCast2D - right_foot"
@onready var ray_cast_2d_left_foot: RayCast2D = $"RayCast2D - left_foot"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d_right: RayCast2D = $"RayCast2D - right"
@onready var ray_cast_2d_left: RayCast2D = $"RayCast2D - left"

const SPEED = 35

func _physics_process(delta: float) -> void:
    position.x += SPEED * delta * direction

    if ray_cast_2d_right_foot.is_colliding() == false or ray_cast_2d_right.is_colliding():
        direction = -1
        animated_sprite_2d.flip_h = true

    if ray_cast_2d_left_foot.is_colliding() == false or ray_cast_2d_left.is_colliding():
        direction = 1
        animated_sprite_2d.flip_h = false
```

### I RayCast2D

Un `RayCast2D` è un raggio invisibile che parte da un punto e controlla se colpisce qualcosa nella sua direzione. Il nemico ne usa quattro:

| RayCast | Posizione | Direzione | Scopo |
|---|---|---|---|
| `right_foot` | `(4, 0)` | `(0, 5)` verso il basso | C'è pavimento a destra? |
| `left_foot` | `(-4, 0)` | `(0, 5)` verso il basso | C'è pavimento a sinistra? |
| `right` | `(0, -5)` | `(5, 0)` verso destra | C'è un muro a destra? |
| `left` | `(0, -5)` | `(-5, 0)` verso sinistra | C'è un muro a sinistra? |

**Logica:** il nemico inverte la direzione se sta per cadere dal bordo **oppure** se si scontra con un muro. `flip_h` specchia lo sprite in orizzontale per farlo guardare nella direzione giusta.

<!-- SCREENSHOT: nemico nel viewport con i RayCast2D visibili come linee gialle -->

> [!WARNING]
> I RayCast2D devono avere nella **Collision Mask** il Layer 4 (Tiles). Se la mask è sbagliata, i raggi non vedono le tile e il nemico cammina nel vuoto senza mai invertire.

> [!NOTE]
> → [Come funzionano i layer e le mask di collisione?](../appendice/layer-di-collisione.md)

---

## 2. Le Monete

Ogni moneta è un `Area2D` con un'animazione che gira in loop. Quando il player ci entra sopra, la moneta si distrugge.

```
Area2D                 ← root: rileva sovrapposizioni
├── AnimatedSprite2D   ← animazione della moneta
└── CollisionShape2D   ← area di raccolta (rettangolo 10×10px)
```

```gdscript
extends Area2D

func _on_body_entered(body: Node2D) -> void:
    queue_free()
```

`queue_free()` rimuove il nodo in modo sicuro alla fine del frame corrente — non istantaneamente, per evitare problemi mentre il motore sta ancora processando le collisioni.

<!-- SCREENSHOT: monete distribuite nel livello -->

---

## 3. La Killzone

La killzone è un `Area2D` che copre l'intera parte bassa della mappa. Quando il player ci cade dentro:

1. La forma di collisione del player viene rimossa (così non triggera altre cose mentre muore)
2. Tutto il gioco rallenta a **1/10 della velocità** — effetto slow-motion
3. Un timer aspetta 1.5 secondi (ignorando il rallentamento)
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

| Riga | Cosa fa |
|---|---|
| `Engine.time_scale = 0.1` | Rallenta tutto il gioco al 10% della velocità |
| `timer.ignore_time_scale = true` | Il timer non viene rallentato dallo slow-motion |
| `reload_current_scene()` | Ricarica la scena — equivale a ricominciare |

<!-- SCREENSHOT: killzone visibile nell'editor come area verde sotto il livello -->

---

## 4. Physics Layers

In questa lezione i layer di collisione diventano essenziali per far funzionare tutto correttamente.

<!-- SCREENSHOT: Project Settings → Layer Names con i 5 layer nominati -->

| Layer | Nome | Chi lo usa | Layer | Mask |
|---|---|---|---|---|
| 1 | `Player` | CharacterBody2D del player | 1 | 10 (layer 2+4) |
| 2 | `Moving Platforms` | AnimatableBody2D | 2 | — |
| 3 | `Pickups` | Monete (Area2D) | 4 | — |
| 4 | `Tiles` | TileMapLayer con collisioni | 8 | — |
| 5 | `Killzone` | Killzone e Area2D nemico | 16 | — |

> [!NOTE]
> **Collision Layer** = "su quale layer si trova questo oggetto"
> **Collision Mask** = "con quali layer questo oggetto interagisce"
>
> → [Spiegazione completa dei layer di collisione](../appendice/layer-di-collisione.md)

---

## Concetti Godot introdotti

- **RayCast2D**: raggio che rileva collisioni in una direzione, usato per l'AI del nemico
- **Area2D**: zona che rileva sovrapposizioni senza fisica rigida
- **Segnali** (`body_entered`): modo di Godot per comunicare tra nodi senza dipendenze dirette
- **`Engine.time_scale`**: scala la velocità dell'intero gioco
- **`timer.ignore_time_scale`**: timer indipendente dal time scale globale
- **`@onready`**: ottiene il riferimento a un nodo figlio quando la scena è pronta
- **`queue_free()`**: rimuove un nodo in sicurezza a fine frame
