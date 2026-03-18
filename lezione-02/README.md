# Lezione 02 – Camera, Velocità e Piattaforme Mobili

Nella lezione precedente abbiamo costruito il livello, creato il player e scritto il primo script di movimento. Oggi partiamo da lì e miglioriamo il gioco: aggiungiamo una camera che segue il personaggio, sistemiamo la velocità e costruiamo piattaforme mobili su cui saltare.

---

## Cosa abbiamo adesso

Apri la cartella `lezione-02` in Godot (come hai fatto nella lezione precedente: **Import** → seleziona il file `project.godot` dentro `lezione-02/`).

Premi **▶** (o `F5`) per avviare il gioco. Ecco cosa trovi:

- Un **livello** costruito con le tile (lo sfondo, le piattaforme, il primo piano)
- Il **player** che si muove con le frecce e salta con Spazio
- Il tasto **Esc** chiude il gioco

Prova a muoverti un po'. Dovresti notare **tre problemi**:

1. **Il player è troppo veloce** — si muove così rapidamente che è difficile da controllare
2. **La camera non segue il player** — quando esci dallo schermo, non vedi più il personaggio
3. **Non ci sono ostacoli interessanti** — il livello è piatto, mancano piattaforme su cui saltare

In questa lezione risolviamo tutti e tre questi problemi.

<!-- 📸 SCREENSHOT: il gioco in esecuzione allo stato iniziale di lezione-02 — il player sul livello, senza camera che segue -->

---

## Cosa costruiamo oggi

- ✏️ **Rallentiamo il player** — cambiamo i valori di velocità e salto nello script
- 📷 **Aggiungiamo la Camera2D** — segue il player e non mostra il vuoto fuori dalla mappa
- 🟫 **Creiamo una piattaforma mobile** — una nuova scena con un corpo fisico che si muove
- 🎬 **Animiamo la piattaforma** — usiamo l'AnimationPlayer per farla muovere avanti e indietro
- 🗂️ **Mettiamo ordine** — riorganizziamo l'albero della scena con nodi contenitore

---

## 1. Rallentiamo il player

Il player attuale si muove a `SPEED = 300` e salta con `JUMP_VELOCITY = -400`. Per il nostro gioco in pixel art (la finestra è larga solo 432 pixel!) sono valori troppo alti: il personaggio attraversa lo schermo in un lampo.

### Come fare

1. Nel pannello **FileSystem** in basso a sinistra, naviga nella cartella `scripts/`
2. Fai doppio click su `player.gd` — si apre l'editor di script

<!-- 📸 SCREENSHOT: pannello FileSystem con la cartella scripts/ aperta e player.gd evidenziato -->

3. Trova queste due righe in alto:

```gdscript
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
```

4. Cambiale in:

```gdscript
const SPEED = 100.0
const JUMP_VELOCITY = -270.0
```

5. Salva con **Ctrl+S**

> [!IMPORTANT]
> **Cosa sono queste righe?** Sono due **costanti** — dei valori con un nome. `const` significa che non cambieranno mai durante il gioco. Scrivere `const SPEED = 100.0` è come dire: "ogni volta che nel codice leggi SPEED, intendo il numero 100". Dare un nome ai numeri rende il codice leggibile: `direction * SPEED` si capisce, `direction * 100.0` un po' meno, e tra una settimana non ricorderesti perché avevi messo proprio 100.

> [!IMPORTANT]
> **Perché il salto è un numero negativo?** In Godot (e in quasi tutti i motori di gioco 2D), l'asse Y è **capovolto** rispetto a quello di matematica: Y cresce verso il **basso**, non verso l'alto. Quindi per andare verso l'alto, la velocità deve essere negativa. `-270` significa "vai verso l'alto a velocità 270".

### Prova

Premi **▶**. Il player ora dovrebbe muoversi più lentamente e fare salti più corti. Giocaci un po': il feeling è molto diverso.

---

## 2. Aggiungiamo la Camera2D

Adesso il gioco ha un problema evidente: se il player si muove a destra, esce dallo schermo e non lo vedi più. Ci serve una **camera** che lo segua.

### Perché la camera è figlia del player?

In Godot, quando un nodo è **figlio** di un altro nodo, lo segue. Se metti la Camera2D dentro il player, la camera si muove automaticamente con lui — senza scrivere nemmeno una riga di codice.

> [!IMPORTANT]
> **Perché non mettere la camera nella scena principale?** Se la camera fosse figlia di `Game` (la scena principale), starebbe ferma. Dovresti scrivere uno script per farla seguire il player a ogni frame. Mettendola come figlia del player, Godot fa tutto da solo. In Godot si ragiona spesso così: **la posizione nell'albero dei nodi determina il comportamento**.

### Come fare

1. Apri la scena del player: nel **FileSystem**, vai nella cartella `scenes/` e fai doppio click su `player.tscn`
2. Nel pannello **Scene** (in alto a sinistra) vedrai l'albero dei nodi del player:

```
CharacterBody2D
├── AnimatedSprite2D
└── CollisionShape2D
```

3. Fai **click destro** su `CharacterBody2D` (il nodo radice) → **Add Child Node...**

<!-- 📸 SCREENSHOT: click destro su CharacterBody2D con il menu contestuale aperto, "Add Child Node" evidenziato -->

4. Si apre una finestra di ricerca. Scrivi `Camera2D` nella barra di ricerca in alto
5. Seleziona **Camera2D** e clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Create New Node" con "Camera2D" nella barra di ricerca e il nodo selezionato -->

Ora l'albero del player è:

```
CharacterBody2D
├── AnimatedSprite2D
├── CollisionShape2D
└── Camera2D            ← nuova!
```

### Prova

Premi **▶**. Adesso la camera segue il player! Muoviti a destra e a sinistra — il personaggio resta sempre visibile.

Ma c'è un problema: se arrivi ai **bordi della mappa**, la camera mostra il **vuoto grigio** oltre le tile. Lo sistemiamo ora.

<!-- 📸 SCREENSHOT: gioco in esecuzione con la camera che mostra il vuoto grigio oltre il bordo della mappa -->

---

## 3. I limiti della camera

Vogliamo che la camera non vada mai oltre i bordi della mappa. Per farlo dobbiamo dire alla camera: "il tuo bordo sinistro non può andare sotto X=0, il tuo bordo destro non può andare oltre la fine delle tile", e così via.

Potremmo scrivere questi numeri a mano, ma se poi cambiamo la dimensione del livello dovremmo ricordare di aggiornarli. Meglio scrivere uno **script** che li calcoli automaticamente leggendo la dimensione del TileMap.

### Passo 1: Aggiungere il gruppo "limits" al TileMap

Lo script della camera ha bisogno di trovare il TileMap per leggerne le dimensioni. In Godot, un **gruppo** è un'etichetta che puoi attaccare a qualsiasi nodo per ritrovarlo facilmente dal codice.

1. Apri la scena `game.tscn` (doppio click nel FileSystem)
2. Nel pannello **Scene**, seleziona il nodo `TileMapLayer platforms`
3. Nel pannello a destra, clicca sulla tab **Node** (accanto a Inspector)
4. Clicca sulla sezione **Groups**
5. Scrivi `limits` nel campo di testo e clicca **Add**

<!-- 📸 SCREENSHOT: pannello Node → Groups con il campo "limits" scritto e il bottone Add visibile. Il nodo selezionato è "TileMapLayer platforms" -->

> [!IMPORTANT]
> **Perché usiamo un gruppo e non il nome del nodo?** Potremmo cercare il nodo per nome (`get_node("TileMapLayer platforms")`), ma il nome è fragile: se lo rinomini, il codice smette di funzionare. Un gruppo è un'etichetta separata dal nome — puoi rinominare il nodo quanto vuoi, finché ha il gruppo `limits` lo script lo trova.

### Passo 2: Creare lo script della camera

1. Torna nella scena `player.tscn` (doppio click su `player.tscn` nel FileSystem)
2. Seleziona il nodo `Camera2D` nell'albero della scena
3. Clicca sull'icona **📜** (Attach Script) in alto nel pannello Scene — è il bottone con la pergamena

<!-- 📸 SCREENSHOT: pannello Scene con Camera2D selezionato e il bottone "Attach Script" (icona pergamena) evidenziato -->

4. Si apre la finestra di creazione script:
   - **Path**: cambia il percorso in `res://scripts/camera_2d.gd` (così lo salviamo nella cartella scripts, non in scenes)
   - **Template**: scegli **Empty** (non ci serve il template predefinito)
   - Clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Attach Node Script" con il path impostato su res://scripts/camera_2d.gd e Template su Empty -->

5. Si apre l'editor di script con un file quasi vuoto. Scrivi questo codice:

```gdscript
extends Camera2D
```

Questa prima riga dice: "questo script controlla un nodo di tipo Camera2D". Ogni script in Godot inizia con `extends` seguito dal tipo di nodo a cui è attaccato.

6. Adesso aggiungi la funzione che calcola i limiti. Scrivi sotto (lascia una riga vuota dopo `extends Camera2D`):

```gdscript
func _ready() -> void:
    var tilemap = get_tree().get_first_node_in_group("limits")
```

> [!NOTE]
> **Cosa significa?**
> - `func _ready()` — è una funzione speciale di Godot. Viene eseguita **una sola volta**, nel momento in cui il nodo appare nel gioco. Perfetto per configurare cose all'inizio.
> - `var tilemap` — crea una **variabile** (un contenitore con un nome). La chiamiamo `tilemap` perché conterrà il riferimento al nostro TileMap.
> - `get_tree().get_first_node_in_group("limits")` — cerca nell'intera scena il primo nodo che ha il gruppo `limits`. È il TileMapLayer delle piattaforme a cui abbiamo aggiunto il gruppo prima.

7. Aggiungi le righe successive che leggono la dimensione della mappa:

```gdscript
    var used_rect = tilemap.get_used_rect()
    var tile_size = tilemap.tile_set.tile_size
```

> [!NOTE]
> - `get_used_rect()` restituisce il **rettangolo** che contiene tutte le tile che hai disegnato. Non è in pixel, è in "numero di tile" (es. 100 tile di larghezza × 15 di altezza).
> - `tile_set.tile_size` è la dimensione di una singola tile in pixel (nel nostro caso 16×16).

8. Infine, imposta i limiti della camera:

```gdscript
    limit_left   = 0
    limit_top    = 0
    limit_right  = used_rect.end.x * tile_size.x
    limit_bottom = used_rect.end.y * tile_size.y
```

> [!NOTE]
> Qui facciamo una moltiplicazione: "quante tile ci sono in orizzontale" × "quanto è larga una tile in pixel" = "quanti pixel è larga la mappa". Stessa cosa in verticale. Così la camera sa dove finisce il mondo.

### Il codice completo

Controlla che il tuo `camera_2d.gd` sia così:

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

Salva con **Ctrl+S**.

### Prova

Premi **▶**. Muoviti fino ai bordi della mappa: la camera ora **si ferma** e non mostra più il vuoto grigio. Se torni al centro, la camera riprende a seguirti normalmente.

<!-- 📸 SCREENSHOT: gioco in esecuzione con il player vicino al bordo sinistro — la camera si ferma e non mostra il vuoto -->

---

## 4. Il player davanti a tutto

Se provi a camminare nel gioco, potresti notare che il player finisce **dietro** ad alcune tile decorative del primo piano (il layer `foreground`). In un platform game, di solito vogliamo che il personaggio sia visibile sopra tutto il resto del livello.

### Come fare

1. Apri `game.tscn`
2. Nel pannello **Scene**, seleziona il nodo `player`
3. Nell'**Inspector**, cerca la proprietà **Z Index** (nella sezione **CanvasItem → Ordering**)
4. Cambia il valore da `0` a `1`

<!-- 📸 SCREENSHOT: Inspector del nodo player in game.tscn con Z Index impostato a 1, nella sezione CanvasItem → Ordering -->

> [!IMPORTANT]
> **Cos'è lo Z Index?** In un gioco 2D, gli oggetti vengono disegnati nell'ordine in cui appaiono nell'albero della scena: prima lo sfondo, poi le piattaforme, poi il player, poi il primo piano. Ma a volte quest'ordine non basta. Lo Z Index è un numero che dice "disegnami più avanti" (valori alti) o "più indietro" (valori bassi). Con Z Index = 1, il player viene disegnato **dopo** (= sopra) i nodi con Z Index = 0 (il default).

---

*Fin qui abbiamo: un player con velocità giusta, una camera che lo segue senza mostrare il vuoto, e il player che appare davanti a tutto. Nella prossima sezione costruiamo le piattaforme mobili.*

---

## 5. La piattaforma mobile — creare la scena

Adesso il livello ha solo piattaforme fisse (le tile). Vogliamo aggiungere una **piattaforma che si muove** — il classico elemento dei platform game dove devi cronometrare il salto per salirci sopra.

La piattaforma sarà una **scena separata**, come il player. Così potremo riutilizzarla: metterne una, due, dieci nel livello, senza rifare tutto ogni volta.

### Crea la scena

1. Nel menu in alto, clicca **Scene** → **New Scene**
2. Nel pannello **Scene** clicca **Other Node** (non scegliere i nodi suggeriti)
3. Cerca `AnimatableBody2D` e clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Create New Node" con "AnimatableBody2D" nella barra di ricerca -->

> [!IMPORTANT]
> **Perché AnimatableBody2D e non StaticBody2D?** Entrambi sono corpi "solidi" su cui il player può camminare. La differenza è: quando un `StaticBody2D` si muove, il player **non viene trascinato** — resta fermo mentre la piattaforma gli scivola sotto i piedi. `AnimatableBody2D` invece **trascina il player con sé**. Per una piattaforma mobile è esattamente quello che vogliamo.

### Aggiungi lo sprite

1. Fai **click destro** su `AnimatableBody2D` → **Add Child Node...**
2. Cerca `Sprite2D` e clicca **Create**
3. Seleziona il nodo `Sprite2D`. Nell'**Inspector**, trascina il file `assets/sprites/platforms.png` dal FileSystem alla proprietà **Texture**

<!-- 📸 SCREENSHOT: Inspector dello Sprite2D con la texture platforms.png assegnata -->

4. L'immagine `platforms.png` contiene più piattaforme diverse. Dobbiamo ritagliare solo quella che ci interessa:
   - Nell'Inspector, attiva **Region → Enabled** (metti la spunta)
   - In **Region → Rect**, imposta: `x = 16`, `y = 0`, `w = 32`, `h = 9`

<!-- 📸 SCREENSHOT: Inspector dello Sprite2D con Region Enabled spuntato e i valori Rect impostati (16, 0, 32, 9) -->

> [!NOTE]
> La proprietà Region dice a Godot: "non mostrare tutta l'immagine, mostra solo questo rettangolo". È lo stesso principio delle animazioni dello spritesheet del player — da un'immagine grande, ritagliamo la parte che ci serve.

### Aggiungi la forma di collisione

1. Fai **click destro** su `AnimatableBody2D` → **Add Child Node...**
2. Cerca `CollisionShape2D` e clicca **Create**
3. Seleziona `CollisionShape2D`. Nell'**Inspector**, nella proprietà **Shape**, clicca `<empty>` e scegli **New RectangleShape2D**
4. Espandi **Shape** e imposta **Size**: `x = 32`, `y = 8`

<!-- 📸 SCREENSHOT: Inspector del CollisionShape2D con RectangleShape2D e size 32×8 -->

5. **Attiva One Way Collision**: nell'Inspector del `CollisionShape2D`, cerca **One Way Collision** e metti la spunta

<!-- 📸 SCREENSHOT: Inspector del CollisionShape2D con One Way Collision abilitato -->

> [!IMPORTANT]
> **Cosa fa One Way Collision?** Normalmente, una collisione blocca il player da **tutti i lati** — non può passarci né da sopra, né da sotto, né dai lati. Con One Way Collision, la collisione funziona **solo da un lato** (dall'alto). Questo significa che il player può **saltare dal basso** e attraversare la piattaforma, ma una volta sopra ci **cammina** normalmente. È il comportamento classico delle piattaforme nei giochi.

### L'albero della scena

A questo punto dovresti avere:

```
AnimatableBody2D
├── Sprite2D
└── CollisionShape2D
```

### Salva la scena

Premi **Ctrl+S** e salva come `res://scenes/moving_platform.tscn`.

---

## 6. Mettere le piattaforme nel livello

Ora che la scena della piattaforma esiste, dobbiamo **istanziarla** dentro la scena principale del gioco — esattamente come il player è già istanziato in `game.tscn`.

Prima di tutto, creiamo un **nodo contenitore** per tenere le piattaforme organizzate:

1. Apri `game.tscn`
2. Seleziona il nodo radice `Game` nel pannello Scene
3. Fai **click destro** → **Add Child Node...**
4. Cerca `Node` (il tipo base, senza 2D o 3D) e clicca **Create**
5. Rinominalo in `Piattaforme` (click destro → **Rename**, oppure `F2`)

> [!TIP]
> Usare nodi contenitore vuoti per raggruppare le cose è una buona abitudine. Quando il livello diventa complesso, avere tutto dentro `Game` diventa caotico. Con un nodo `Piattaforme` sai subito dove sono.

### La prima piattaforma (statica)

1. Seleziona il nodo `Piattaforme` nel pannello Scene
2. Clicca l'icona **🔗** (Link / Instantiate Child Scene) in alto nel pannello Scene — è il bottone con la catena

<!-- 📸 SCREENSHOT: pannello Scene con il nodo Piattaforme selezionato e il bottone "Instantiate Child Scene" (icona catena) evidenziato -->

3. Seleziona `scenes/moving_platform.tscn` e clicca **Open**

La piattaforma appare nel viewport. Rinominala in `Piattaforma 1` e **spostala** dove vuoi nel livello trascinandola col mouse, o imposta la posizione nell'Inspector (es. `x = 201`, `y = 179`).

<!-- 📸 SCREENSHOT: game.tscn nel viewport con la piattaforma posizionata nel livello -->

### La seconda piattaforma (quella che si muoverà)

Ripeti gli stessi passaggi per aggiungere una **seconda** piattaforma:

1. Seleziona `Piattaforme` → icona **🔗** → seleziona `moving_platform.tscn` → **Open**
2. Posizionala in un punto diverso del livello (es. `x = 391`, `y = 147`)
3. Nel pannello Scene, rinomina questa seconda istanza in `Piattaforma Animata` (click destro → **Rename**, oppure `F2`)

<!-- 📸 SCREENSHOT: pannello Scene di game.tscn con il nodo Piattaforme e le due piattaforme istanziate visibili -->

> [!TIP]
> Perché rinominarla? Perché tra poco ne animeremo solo una. Avere nomi diversi aiuta a capire quale è quale nel pannello Scene.

### Prova

Premi **▶**. Le due piattaforme sono nel livello e puoi saltarci sopra! Prova anche a saltarci **da sotto**: dovresti passarci attraverso grazie alla one-way collision. Per ora stanno ferme — le animiamo nel prossimo passo.

---

## 7. Animare la piattaforma con l'AnimationPlayer

Vogliamo che `Piattaforma Animata` si muova avanti e indietro in orizzontale. Per farlo usiamo l'**AnimationPlayer** — un nodo di Godot che può animare **qualsiasi proprietà** di qualsiasi nodo nel tempo (posizione, colore, trasparenza, scala...).

### Aggiungi l'AnimationPlayer

1. In `game.tscn`, seleziona il nodo `Piattaforma Animata` nel pannello Scene
2. Fai **click destro** → **Add Child Node...**
3. Cerca `AnimationPlayer` e clicca **Create**

<!-- 📸 SCREENSHOT: pannello Scene con AnimationPlayer come figlio di Piattaforma Animata -->

> [!IMPORTANT]
> **Perché l'AnimationPlayer è figlio della piattaforma e non di Game?** Perché l'animazione riguarda la piattaforma. In Godot è buona pratica tenere ogni cosa vicino a ciò che controlla. Se domani cancelli la piattaforma, l'animazione se ne va insieme a lei — non restano pezzi orfani in giro.

### Crea l'animazione

1. Seleziona il nodo `AnimationPlayer` che hai appena aggiunto
2. In basso si apre il **pannello Animation**. Clicca su **Animation** (il menu a tendina) → **New...**

<!-- 📸 SCREENSHOT: pannello Animation in basso con il bottone "Animation → New" evidenziato -->

3. Scrivi il nome `moving` e clicca **OK**
4. L'animazione è stata creata. Ora devi impostare due cose:
   - **Durata**: in alto a destra nel pannello Animation, cambia il numero da `1` a `3` (l'animazione durerà 3 secondi)
   - **Loop**: clicca l'icona del **loop** 🔁 (il bottone con la freccia circolare) — così l'animazione si ripete all'infinito

<!-- 📸 SCREENSHOT: pannello Animation con la durata impostata a 3 e il bottone loop attivato -->

### Aggiungi la traccia di posizione

Ora diciamo all'AnimationPlayer **cosa** animare: la posizione della piattaforma.

1. Assicurati che nel pannello Scene sia selezionato il nodo `Piattaforma Animata` (il **genitore** dell'AnimationPlayer, non l'AnimationPlayer stesso)
2. Nell'**Inspector**, trova la proprietà **Position** (dentro la sezione **Node2D → Transform**)
3. Clicca sull'icona della **chiave** 🔑 accanto a Position

<!-- 📸 SCREENSHOT: Inspector di Piattaforma Animata con la proprietà Position e l'icona chiave evidenziata -->

4. Godot chiede se vuoi creare una nuova traccia — clicca **Create**
5. Nella timeline in basso appare un **rombo** (un keyframe) al secondo 0 — è la posizione iniziale della piattaforma

### Aggiungi il keyframe finale

1. Nella timeline in basso, **sposta la testina blu** (la linea verticale blu) alla fine: trascinala fino al secondo `3`

<!-- 📸 SCREENSHOT: pannello Animation con la testina blu spostata al secondo 3 -->

2. Nel **viewport**, seleziona `Piattaforma Animata` e **spostala** nella posizione dove vuoi che arrivi alla fine dell'animazione (es. spostandola di circa 55 pixel a destra, posizione `x = 446`, `y = 147`)
3. Clicca di nuovo sull'icona **chiave** 🔑 accanto a Position nell'Inspector
4. Un nuovo keyframe appare al secondo 3

Ora hai due keyframe: uno all'inizio (posizione di partenza) e uno alla fine (posizione di arrivo). L'AnimationPlayer interpola automaticamente tra i due — la piattaforma si muoverà da un punto all'altro in 3 secondi, poi ripartirà dall'inizio (grazie al loop).

<!-- 📸 SCREENSHOT: pannello Animation con i due keyframe visibili sulla traccia position, uno a 0s e uno a 3s -->

### Imposta l'autoplay

Vogliamo che l'animazione parta da sola quando il gioco inizia:

1. Seleziona il nodo `AnimationPlayer`
2. Nel pannello Animation in basso, clicca sull'icona **Autoplay on Load** (il bottone con il triangolo ▶ e la "A") accanto al nome dell'animazione `moving`

<!-- 📸 SCREENSHOT: pannello Animation con il bottone Autoplay evidenziato accanto all'animazione "moving" -->

### Prova

Premi **▶**. La `Piattaforma Animata` dovrebbe muoversi avanti e indietro! Prova a saltarci sopra: il player viene **trascinato** insieme alla piattaforma.

Se il player non viene trascinato, controlla di aver usato `AnimatableBody2D` e non `StaticBody2D` come root della scena `moving_platform.tscn`.

---

## 8. Mettiamo ordine nella scena

Il gioco funziona, ma se guardiamo il pannello **Scene** di `game.tscn`, l'albero sta diventando disordinato: i TileMapLayer hanno nomi lunghi e sono tutti allo stesso livello, mescolati con il player e le piattaforme. Prendiamoci un minuto per riorganizzare.

### Raggruppa i TileMapLayer

Creiamo un nodo contenitore per le tile, come abbiamo fatto per le piattaforme:

1. In `game.tscn`, seleziona il nodo `Game`
2. Fai **click destro** → **Add Child Node...** → cerca `Node` → **Create**
3. Rinominalo in `Tiles`

Ora trascina i tre TileMapLayer **dentro** il nodo `Tiles`:

4. Nel pannello Scene, clicca su `TileMapLayer background` e **trascinalo** sopra il nodo `Tiles` — diventa suo figlio
5. Fai lo stesso con `TileMapLayer platforms` e `TileMapLayer foreground`

<!-- 📸 SCREENSHOT: pannello Scene con i tre TileMapLayer trascinati dentro il nodo Tiles -->

> [!TIP]
> Per trascinare un nodo dentro un altro nel pannello Scene, tienilo premuto col mouse e muovilo sopra il nodo destinazione. Quando vedi la **linea di inserimento** apparire *dentro* il nodo (non sopra o sotto), rilascia.

### Rinomina i TileMapLayer

I nomi `TileMapLayer background`, `TileMapLayer platforms` ecc. sono lunghi e ripetitivi. Ora che sono dentro il contenitore `Tiles`, possiamo accorciarli:

1. Seleziona `TileMapLayer background` → **F2** → rinomina in `Background`
2. Seleziona `TileMapLayer platforms` → **F2** → rinomina in `Platforms`
3. Seleziona `TileMapLayer foreground` → **F2** → rinomina in `Foreground`

### L'albero finale

Controlla che `game.tscn` abbia questa struttura:

```
Game
├── player
├── Tiles
│   ├── Background
│   ├── Platforms
│   └── Foreground
└── Piattaforme
    ├── Piattaforma 1
    └── Piattaforma Animata
        └── AnimationPlayer
```

Molto più pulito! Ogni gruppo di cose ha il suo contenitore, e i nomi sono corti e chiari.

> [!IMPORTANT]
> **Rinominare i nodi non rompe niente?** In questo caso no, perché nessuno script cerca i TileMapLayer per nome. Lo script della camera usa il **gruppo** `limits`, che resta attaccato al nodo indipendentemente da come lo chiami. Ecco un altro motivo per cui i gruppi sono utili.

Salva con **Ctrl+S**.

---

## Cosa abbiamo ottenuto

Riassumiamo quello che abbiamo costruito in questa lezione:

- ✅ Il player si muove a una **velocità controllata** (SPEED = 100, JUMP = -270)
- ✅ La **Camera2D** segue il player e non mostra il vuoto ai bordi
- ✅ Il player appare **davanti** a tutti gli elementi decorativi (Z Index)
- ✅ Abbiamo una **piattaforma mobile** che si muove avanti e indietro
- ✅ Il player viene **trascinato** dalla piattaforma quando ci sta sopra
- ✅ Si può saltare **dal basso** attraverso la piattaforma (one-way collision)
- ✅ La scena `game.tscn` è **ordinata** con nodi contenitore (`Tiles`, `Piattaforme`)

<!-- 📸 SCREENSHOT: il gioco in esecuzione con il risultato finale della lezione — player su una piattaforma mobile, camera centrata -->

---

## Prova tu 🎮

Ecco alcune cose che puoi provare a fare da solo:

1. **Cambia la velocità della piattaforma**: apri l'animazione `moving` e cambia la durata da 3 a 5 secondi. Come cambia il feeling?

2. **Aggiungi un'altra piattaforma**: istanzia un'altra `moving_platform.tscn` in `game.tscn` e posizionala in un punto diverso del livello. Questa volta prova a farla muovere **in verticale** invece che in orizzontale.

3. **Sperimenta con la velocità del player**: cosa succede se metti `SPEED = 50`? E `JUMP_VELOCITY = -350`? Gioca con i numeri e trova i valori che ti piacciono di più.

---

## Prossima lezione

Il gioco inizia a funzionare: ci si muove, si salta, la camera segue l'azione e ci sono piattaforme mobili. Ma il player ha un problema evidente: mostra sempre la stessa animazione. Che stia fermo, che corra o che salti, l'immagine è identica — sembra un pupazzo che scivola sul pavimento.

Nella prossima lezione daremo **vita** al personaggio: aggiungeremo le animazioni di **corsa**, **salto** e **capriola**, e riscriveremo lo script di movimento con una **macchina a stati** — un modo elegante per organizzare il codice quando il personaggio ha tanti comportamenti diversi.
