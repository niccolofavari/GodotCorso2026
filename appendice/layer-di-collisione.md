# Layer di collisione

---

## Il problema

In un gioco ci sono molti oggetti che esistono nello stesso mondo: il player, i nemici, le monete, il pavimento, le zone di morte. Ma non tutti devono interagire con tutti:

- Il player deve **camminare** sul pavimento
- Il player deve **toccare** le monete per raccoglierle
- Il player deve **scontrarsi** con i nemici
- I nemici **non** devono raccogliere le monete
- Le monete **non** devono scontrarsi tra di loro
- Il pavimento **non** deve interagire con le zone di morte

Senza un sistema per controllare tutto questo, Godot farebbe scontrare **tutto con tutto** — e il gioco diventerebbe ingestibile.

---

## Come funziona: Layer e Mask

Ogni nodo fisico in Godot (CharacterBody2D, StaticBody2D, Area2D, ecc.) ha due impostazioni:

### Collision Layer — "Io chi sono"

Il **Collision Layer** dice: *"io appartengo a questa categoria"*. È l'identità dell'oggetto nel sistema di collisione.

### Collision Mask — "Io con chi interagisco"

La **Collision Mask** dice: *"io reagisco agli oggetti di queste categorie"*. È il filtro che determina cosa l'oggetto "vede".

La regola è: **due oggetti collidono solo se almeno uno dei due ha nella propria mask il layer dell'altro**.

---

## I layer del nostro gioco

Abbiamo configurato 5 physics layer nei Project Settings:

| # | Nome | Chi ci sta |
|---|---|---|
| 1 | **Player** | Il personaggio giocabile |
| 2 | **Moving Platforms** | Le piattaforme che si muovono |
| 3 | **Pickups** | Monete, frutti, collezionabili |
| 4 | **Tiles** | Il pavimento e le piattaforme fisse (TileMap) |
| 5 | **Killzone** | Zone di morte (cadere nel vuoto, lava, spine) |

---

## Chi collide con chi: la tabella completa

Ecco come sono configurati i layer e le mask di ogni oggetto nel nostro gioco:

| Oggetto | Collision Layer (chi sono) | Collision Mask (con chi interagisco) | Perché |
|---|---|---|---|
| **Player** | 1 (Player) | 2, 4 (Moving Platforms + Tiles) | Cammina sulle piattaforme e sul pavimento |
| **Piattaforme mobili** | 2 (Moving Platforms) | — | Le piattaforme non devono "cercare" nessuno — è il player che le trova |
| **Monete** | 3 (Pickups) | — | Le monete non cercano nessuno — il player le rileva con un'Area2D |
| **Tile (pavimento)** | 4 (Tiles) | — | Il pavimento è passivo — il player ci collide ma il pavimento non deve cercare nessuno |
| **Killzone** | 5 (Killzone) | — | Come le monete, vengono rilevate dall'Area2D del player |

> [!IMPORTANT]
> **Perché il player ha nella mask solo 2 e 4, non 3 e 5?** Le monete e le killzone sono gestite con le **Area2D**, un tipo di nodo diverso che rileva le sovrapposizioni (overlap) ma non causa collisioni fisiche. Il player non "sbatte" contro una moneta — ci passa attraverso e la raccoglie. Per questo monete e killzone non servono nella collision mask del player.

---

## Layer e Mask nell'Inspector

Quando selezioni un nodo fisico, nell'Inspector trovi la sezione **Collision**:

- **Layer**: una griglia di quadratini. Ogni quadratino è un layer (1, 2, 3...). Quelli accesi sono i layer a cui l'oggetto appartiene
- **Mask**: stessa griglia. Quelli accesi sono i layer a cui l'oggetto reagisce

<!-- 📸 SCREENSHOT: Inspector di un CharacterBody2D con la sezione Collision aperta, Layer e Mask visibili con i quadratini -->

Se passi il mouse su un quadratino, Godot mostra il **nome** del layer (quelli che abbiamo impostato nei Project Settings). Così non devi ricordare i numeri a memoria.

> [!TIP]
> Se hai dei dubbi su un oggetto, chiediti: **"Io chi sono?"** (→ imposta il layer) e **"Con chi devo interagire?"** (→ imposta la mask). Spesso gli oggetti passivi (pavimento, monete, killzone) hanno la mask vuota — aspettano che siano gli altri a trovarli.

---

## Un esempio concreto

Prendiamo il **player**:

1. **Collision Layer** = 1 (Player). Questo significa: "io sono un Player"
2. **Collision Mask** = 2, 4 (Moving Platforms + Tiles). Questo significa: "io reagisco alle piattaforme mobili e alle tile"

Quando il player cade, Godot controlla: "il player ha nella mask il layer 4 (Tiles)? Sì → quindi il player collide con il pavimento e non lo attraversa".

Quando il player tocca una moneta, Godot controlla: "il player ha nella mask il layer 3 (Pickups)? No → il player non collide fisicamente con la moneta". La moneta viene rilevata in un altro modo (Area2D), non con la collision mask.

---

## Collision Layer nel TileSet

Le tile hanno una particolarità: il loro collision layer non si imposta sul TileMapLayer, ma nel **TileSet** stesso.

Quando crei un TileSet, puoi aggiungere **Physics Layer** al suo interno. Ogni physics layer del TileSet corrisponde a un layer dei Project Settings. Le tile a cui disegni una forma di collisione useranno quel layer.

Nel nostro caso, il TileSet delle piattaforme usa il layer 4 (Tiles).

> [!NOTE]
> Questo è il motivo per cui nominiamo i layer **prima** di creare il TileSet — così quando configuriamo il physics layer nel TileSet, sappiamo già cosa significa ogni numero.

---

## Dove si configurano i nomi dei layer

**Project** → **Project Settings** → **Layer Names** → **2D Physics**

Per i passaggi pratici su come impostare tutto questo, vedi → [Creare il progetto da zero](progetto-da-zero.md).
