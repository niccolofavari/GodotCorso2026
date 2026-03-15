# Lezione 02 – Camera, Piattaforme Mobili e Organizzazione del Progetto

In questa lezione aggiungiamo la camera che segue il player, le piattaforme mobili e riorganizziamo gli script in una cartella dedicata.

---

## Cosa abbiamo fatto

- Aggiunta una **Camera2D** che segue il player con limiti legati alla TileMap
- Creata la **piattaforma mobile** (`moving_platform.tscn`)
- Riorganizzati gli script nella cartella `scripts/`
- Ridotto la velocità del player per adattarla alla nuova risoluzione

---

## La Camera2D

La camera è figlia del `CharacterBody2D` del player, così lo segue automaticamente. Ha il **position smoothing** abilitato per un movimento fluido.

I limiti della camera vengono calcolati automaticamente in base alla dimensione della TileMap:

```gdscript
extends Camera2D

func _ready() -> void:
    var tilemap = get_tree().get_first_node_in_group("limits")

    var used_rect = tilemap.get_used_rect()
    var tile_size = tilemap.tile_set.tile_size

    limit_left   = 0
    limit_top    = 0
    limit_right  = used_rect.end.x * tile_size.x
    limit_bottom = used_rect.end.y * tile_size.y
```

**Concetti chiave:**
- `get_first_node_in_group("limits")` → trova il TileMapLayer del background tramite gruppo
- `get_used_rect()` → restituisce il rettangolo in coordinate tile che contiene tutte le celle
- `used_rect.end * tile_size` → converte in pixel per impostare i limiti della camera

> Il TileMapLayer del background deve essere aggiunto al **gruppo** `limits` dall'Inspector.

---

## La piattaforma mobile

La piattaforma è un `AnimatableBody2D` (corpo fisico che può essere mosso tramite animazione senza perdere le collisioni):

- `Sprite2D` → sprite ritagliato dal tileset `platforms.png`
- `CollisionShape2D` → rettangolo con **one-way collision** (si può passarci sopra ma non sotto)

Il movimento è gestito dall'`AnimationPlayer` nella scena `game.tscn`, non dallo script.

### Perché AnimatableBody2D e non StaticBody2D?

`StaticBody2D` non "spinge" il player quando si muove. `AnimatableBody2D` sì: il player viene trascinato con la piattaforma correttamente.

---

## Modifiche al Player

| Proprietà | Lezione 01 | Lezione 02 |
|---|---|---|
| `SPEED` | 300.0 | 100.0 |
| `JUMP_VELOCITY` | -400.0 | -270.0 |
| Collision mask | default | 10 (layer 2 + 4: piattaforme + tile) |
| Camera | nessuna | Camera2D con limiti |

La **collision mask** del player è `10` (binario `1010`), ovvero:
- Layer 2 → Moving Platforms
- Layer 4 → Tiles

---

## Organizzazione del progetto

Gli script sono stati spostati da `scenes/` a `scripts/` per tenere separati i file `.gd` dalle scene `.tscn`.

```
lezione-02/
├── scenes/
│   ├── game.tscn
│   ├── moving_platform.tscn
│   └── player.tscn
└── scripts/
    ├── camera_2d.gd
    ├── game.gd
    └── player.gd
```

---

## Concetti Godot introdotti

- **Camera2D** con `position_smoothing` e limiti (`limit_left/right/top/bottom`)
- **Gruppi**: modo per trovare nodi nell'albero senza riferimenti diretti
- **AnimatableBody2D**: corpo fisico animabile che interagisce correttamente con i CharacterBody
- **One-way collision**: collisione solo da un lato (piattaforme attraversabili)
- **AnimationPlayer**: sistema per animare proprietà di qualsiasi nodo
