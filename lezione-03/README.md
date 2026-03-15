# Lezione 03 – Camera, Piattaforme Mobili e Organizzazione del Progetto

In questa lezione aggiungiamo la camera che segue il player, le piattaforme mobili e riorganizziamo gli script in una cartella dedicata.

---

## Cosa costruiamo oggi

- La **Camera2D** che segue il player con limiti legati alla mappa
- La **piattaforma mobile** (`moving_platform.tscn`)
- Una struttura di cartelle più ordinata per gli script

<!-- SCREENSHOT: gioco in esecuzione con la camera che segue il player e una piattaforma mobile visibile -->

---

## 1. La Camera2D

La camera è figlia del `CharacterBody2D` del player — così lo segue automaticamente senza scrivere codice.

<!-- SCREENSHOT: pannello Scene con Camera2D come figlia di CharacterBody2D -->

Nell'Inspector, abilita **Position Smoothing** → `On`: la camera non si muove in modo secco ma segue il player con un piccolo ritardo fluido.

### Limiti della camera

Senza limiti, la camera mostrerebbe il vuoto oltre il bordo della mappa. Lo script calcola i limiti automaticamente in base alla dimensione del TileMapLayer:

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

**Come funziona:**

| Riga | Significato |
|---|---|
| `get_first_node_in_group("limits")` | Trova il TileMapLayer del background tramite gruppo |
| `get_used_rect()` | Restituisce il rettangolo (in coordinate tile) che contiene tutte le celle disegnate |
| `used_rect.end * tile_size` | Converte le coordinate tile in pixel |

> [!IMPORTANT]
> Il `TileMapLayer background` deve essere aggiunto al **gruppo** `limits` dall'Inspector (tab **Node** → **Groups**). Se dimentichi questo passaggio, lo script non trova la mappa e i limiti non funzionano.

<!-- SCREENSHOT: Inspector del TileMapLayer background con il gruppo "limits" aggiunto -->

---

## 2. La piattaforma mobile

La piattaforma è una scena separata (`moving_platform.tscn`) basata su **AnimatableBody2D**.

```
AnimatableBody2D       ← root: corpo fisico animabile
├── Sprite2D           ← l'immagine della piattaforma
└── CollisionShape2D   ← rettangolo con one-way collision
```

### Perché AnimatableBody2D e non StaticBody2D?

`StaticBody2D` non "spinge" il player quando si muove: il player rimane fermo mentre la piattaforma gli passa sotto. `AnimatableBody2D` invece lo trascina correttamente.

### One-way collision

Il `CollisionShape2D` ha **One Way Collision** attivato: si può atterrare sopra la piattaforma, ma ci si può passare attraverso dal basso. Così si può saltare per salirci.

<!-- SCREENSHOT: Inspector del CollisionShape2D con One Way Collision abilitato -->

### Animazione del movimento

Il movimento non è scritto in uno script ma gestito dall'**AnimationPlayer** nella scena `game.tscn`. L'AnimationPlayer sposta la posizione della piattaforma nel tempo creando un'animazione loopata.

<!-- SCREENSHOT: pannello AnimationPlayer con la traccia position della piattaforma -->

> [!TIP]
> → [Approfondimento sull'AnimationPlayer](../appendice/layer-di-collisione.md)

<!-- ??? Hai una pagina in appendice sull'AnimationPlayer? Se no rimuovo il rimando -->

---

## 3. Organizzazione del progetto

In questa lezione spostiamo gli script da `scenes/` a una cartella dedicata `scripts/`. È una buona abitudine tenere i file `.gd` separati dalle scene `.tscn`.

```
lezione-03/
├── scenes/
│   ├── game.tscn
│   ├── moving_platform.tscn
│   └── player.tscn
└── scripts/
    ├── camera_2d.gd
    ├── game.gd
    └── player.gd
```

Quando sposti uno script, Godot aggiorna automaticamente i riferimenti nelle scene — non devi modificare nulla a mano.

---

## Modifiche rispetto alla Lezione 02

| Cosa | Lezione 02 | Lezione 03 |
|---|---|---|
| `SPEED` del player | 300.0 | 100.0 |
| `JUMP_VELOCITY` | -400.0 | -270.0 |
| Collision mask del player | default | `10` (layer 2 + 4) |
| Camera | nessuna | Camera2D con limiti |

La **collision mask** `10` in binario è `1010`, cioè il player reagisce a:
- Layer 2 → Moving Platforms
- Layer 4 → Tiles

> [!NOTE]
> → [Come funzionano i layer e le mask di collisione?](../appendice/layer-di-collisione.md)

---

## Concetti Godot introdotti

- **Camera2D** con `position_smoothing` e limiti (`limit_left/right/top/bottom`)
- **Gruppi**: modo per trovare nodi nell'albero senza riferimenti diretti
- **AnimatableBody2D**: corpo fisico animabile che interagisce correttamente con i CharacterBody
- **One-way collision**: collisione solo da un lato
- **AnimationPlayer**: anima qualsiasi proprietà di qualsiasi nodo nel tempo
