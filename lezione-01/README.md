# Lezione 01 – Il primo livello e il primo personaggio

In questa prima lezione installiamo Godot, apriamo il progetto e costruiamo le basi del gioco: un livello disegnato con le tile e un personaggio che si muove e salta.

---

## Cosa abbiamo adesso

Non abbiamo ancora nulla — il progetto è preparato con gli asset e le configurazioni, ma il gioco è vuoto. Partiamo da zero.

---

## Cosa costruiamo oggi

- 🔧 **Installiamo Godot** e apriamo il progetto del corso
- 🗺️ **Costruiamo il livello** con tre layer di tile (sfondo, piattaforme, primo piano)
- 🧑 **Creiamo il player** — il personaggio giocabile, con la sua animazione e la sua forma di collisione
- 📝 **Scriviamo il primo script** — il codice che fa muovere e saltare il player
- ▶️ **Mettiamo tutto insieme** e vediamo il gioco funzionare

---

## 1. Scarica Godot

Vai su **[godotengine.org](https://godotengine.org/)** e clicca su **Download**.

Scarica **Godot Engine 4** — la versione normale, **non** quella ".NET".

> [!NOTE]
> Godot non richiede installazione: è un singolo file eseguibile. Puoi tenerlo sul desktop, in una cartella, o su una chiavetta USB — aprilo e funziona.

---

## 2. Scarica i file del corso

1. Vai su **[github.com/niccolofavari/GodotCorso2026](https://github.com/niccolofavari/GodotCorso2026)**
2. Clicca sul bottone verde **Code** → poi **Download ZIP**
3. Decomprimi lo ZIP e metti la cartella in un posto che ricordi (es. il Desktop)

Dentro troverai una cartella per ogni lezione (`lezione-01`, `lezione-02`, `lezione-03`...). Ogni cartella è un **progetto Godot completo e autonomo**.

> [!IMPORTANT]
> **Come funziona la struttura del corso?** Ogni lezione ha la sua cartella con un progetto Godot. Tu apri la cartella della lezione corrente e lavori lì dentro. La cartella della **lezione successiva** contiene il **risultato** della lezione che stai facendo — se ti perdi o qualcosa non funziona, puoi sempre aprire la lezione successiva per vedere com'è il progetto finito.

---

## 3. Apri il progetto in Godot

1. Avvia Godot — si apre il **Project Manager** (la schermata con la lista dei progetti)
2. Clicca su **Import**

![Il Project Manager di Godot con il bottone Import evidenziato](screenshots/01-bottone-import.png)

3. Clicca su **Browse** e naviga fino alla cartella `lezione-01`
4. Seleziona il file `project.godot` dentro `lezione-01/`
5. Clicca **Import & Edit**

Il progetto si apre e vedrai l'editor di Godot.

> [!WARNING]
> Attenzione a non aprire la cartella sbagliata! Il file `project.godot` è l'indicatore: deve stare dentro `lezione-01/`, non nella cartella principale del corso.

---

## 4. Orientati nell'interfaccia

L'editor di Godot è diviso in alcune aree principali:

![L'interfaccia di Godot con le aree numerate](screenshots/02-tour-interfaccia.png)

| # | Area | Dove si trova | A cosa serve |
|---|---|---|---|
| 1 | **FileSystem** | In basso a sinistra | Tutti i file del progetto (immagini, suoni, script...) |
| 2 | **Scene** | In alto a sinistra | L'albero dei nodi della scena aperta |
| 3 | **Viewport** | Al centro | L'anteprima visiva del gioco |
| 4 | **Inspector** | A destra | Le proprietà del nodo selezionato |
| 5 | **Output** | In basso al centro | Messaggi ed errori quando il gioco gira |

Non devi memorizzare tutto — ci torneremo continuamente durante le lezioni.

---

## 5. Cosa c'è già nel progetto

Il progetto che hai aperto non è completamente vuoto. Abbiamo già preparato alcune cose per te:

- ✅ La **risoluzione** della finestra è già configurata per il nostro gioco in pixel art (432×240 pixel, ingrandita 3 volte)
- ✅ Le **immagini**, i **font** e i **suoni** sono già importati nella cartella `assets/`
- ✅ I **layer di collisione** sono già nominati (servono per dire a Godot chi si scontra con chi)
- ✅ Una **scena principale** (`game.tscn`) è già creata, ma è vuota

> [!IMPORTANT]
> **Perché queste cose sono già fatte?** Normalmente, quando si crea un gioco da zero, si configurano tutte queste impostazioni a mano. Le abbiamo preparate prima per non perdere tempo in classe con i dettagli tecnici e passare subito alla parte creativa. Se vuoi capire cosa fanno, le spieghiamo nell'appendice:
> - → [Cos'è la risoluzione e il viewport?](../appendice/risoluzione.md)
> - → [Cosa sono i layer di collisione?](../appendice/layer-di-collisione.md)
> - → [Cosa sono gli asset?](../appendice/asset.md)

---

## 6. La scena principale e il TileMap

Partiamo dalla scena `game.tscn` — è la scena principale del gioco, il contenitore di tutto. Per ora contiene solo un nodo `Game` di tipo `Node2D`.

Il primo passo è costruire il **livello** — il mondo in cui il player si muoverà. Per farlo usiamo le **tile**: piccoli pezzi di immagine (16×16 pixel nel nostro caso) che vengono ripetuti e combinati come un mosaico per costruire il livello.

> [!IMPORTANT]
> **Perché le tile e non un disegno unico?** Potresti disegnare il livello come un'unica immagine grande. Ma le tile hanno tre vantaggi: (1) sono **leggere** — un tileset piccolo può creare livelli enormi; (2) sono **modificabili** — puoi cambiare il livello spostando tile senza ridisegnare tutto; (3) puoi aggiungere **collisioni** a singole tile — così il player cammina sul pavimento automaticamente.

### I tre layer

Il nostro livello è fatto di tre strati sovrapposti, ognuno con uno scopo preciso:

| Layer | Cosa contiene | Esempio |
|---|---|---|
| **background** | Lo sfondo decorativo — non si può toccare, è solo visivo | Cielo, muri lontani, decorazioni |
| **platforms** | Le piattaforme solide su cui il player cammina | Pavimento, muri, piattaforme |
| **foreground** | Elementi davanti al player — puramente decorativi | Cespugli, colonne in primo piano |

### Aggiungi i tre TileMapLayer

1. Fai doppio click su `game.tscn` nel **FileSystem** per aprire la scena (potrebbe essere già aperta)
2. Nel pannello **Scene** (in alto a sinistra) vedrai il nodo `Game`
3. Fai **click destro** su `Game` → **Add Child Node...**

<!-- 📸 SCREENSHOT: click destro su Game con il menu contestuale, "Add Child Node" evidenziato -->

4. Si apre una finestra di ricerca. Scrivi `TileMapLayer` nella barra di ricerca in alto
5. Seleziona **TileMapLayer** e clicca **Create**
6. Il nuovo nodo appare nell'albero come figlio di `Game`. **Rinominalo**: click destro → **Rename** (o seleziona e premi `F2`), scrivi `TileMapLayer background`

<!-- 📸 SCREENSHOT: pannello Scene con il nodo rinominato "TileMapLayer background" -->

7. Ripeti i passaggi 3-6 altre **due volte**, creando:
   - `TileMapLayer platforms`
   - `TileMapLayer foreground`

Ora l'albero della scena è:

```
Game
├── TileMapLayer background
├── TileMapLayer platforms
└── TileMapLayer foreground
```

### Assegna il TileSet a ogni layer

Ogni TileMapLayer ha bisogno di sapere **quali tile usare**. Questo si imposta con un **TileSet** — una risorsa che contiene l'immagine delle tile e le loro proprietà.

1. Seleziona `TileMapLayer background` nel pannello Scene
2. Nel pannello **Inspector** a destra, cerca la proprietà **Tile Set**
3. Clicca su `<empty>` e scegli **Load...**
4. Naviga in `assets/sprites/` e seleziona `world_tileset_resource.tres`
5. Clicca **Open**

<!-- 📸 SCREENSHOT: Inspector del TileMapLayer background con la proprietà Tile Set e il file world_tileset_resource.tres caricato -->

6. Ripeti i passaggi 1-5 per `TileMapLayer platforms` e `TileMapLayer foreground` — tutti e tre usano lo **stesso** TileSet

> [!NOTE]
> Il file `world_tileset_resource.tres` è una risorsa di Godot che abbiamo preparato. Contiene il riferimento all'immagine `world_tileset.png` (la griglia con tutte le tile) e sa come ritagliarla in pezzi da 16×16 pixel.

### Disegna il livello

Ora puoi disegnare! Seleziona uno dei TileMapLayer e in basso si apre il **pannello TileMap**.

1. Seleziona `TileMapLayer background` nel pannello Scene
2. In basso appare il pannello **TileMap** con tutte le tile disponibili
3. **Clicca su una tile** nel pannello per selezionarla
4. **Clicca nel viewport** per posizionarla — ogni click piazza una tile

<!-- 📸 SCREENSHOT: pannello TileMap in basso con le tile disponibili e una tile selezionata. Nel viewport si vedono alcune tile piazzate -->

5. Per **cancellare** una tile: tieni premuto il **tasto destro** del mouse e clicca sulla tile da rimuovere
6. Per **riempire un'area**: seleziona lo strumento **Rettangolo** nella barra degli strumenti del TileMap (l'icona con il rettangolo) e trascina nel viewport

<!-- 📸 SCREENSHOT: barra strumenti del pannello TileMap con lo strumento Rettangolo evidenziato -->

**Cosa disegnare su ogni layer:**

- Su `TileMapLayer background`: riempi tutto lo sfondo con le tile del cielo o del muro. Questo layer copre tutta l'area visibile
- Su `TileMapLayer platforms`: disegna il pavimento e le piattaforme su cui il player camminerà. Queste sono le superfici solide
- Su `TileMapLayer foreground`: aggiungi decorazioni davanti al player (opzionale per ora)

> [!TIP]
> **Per ora concentrati su background e platforms.** Lo sfondo può essere tutto uguale (riempi con una tile sola usando lo strumento Rettangolo). Le piattaforme sono la parte importante: crea un pavimento in basso e qualche piattaforma a diverse altezze.

### Prova

Premi **▶** (o `F5`). Se è la prima volta, Godot ti chiede quale scena usare come scena principale — seleziona `game.tscn`.

Vedrai il livello che hai disegnato. Per ora non c'è nessun personaggio, solo le tile. Chiudi la finestra di gioco.

<!-- 📸 SCREENSHOT: gioco in esecuzione con solo il TileMap visibile (sfondo + piattaforme), senza player -->

---

## 7. Crea la scena del Player

Il player è il personaggio che controlliamo. Lo creiamo come una **scena separata** — un file a parte che poi "incolleremo" dentro il livello.

> [!IMPORTANT]
> **Perché il player è una scena separata e non un nodo dentro game.tscn?** Perché le scene in Godot sono **riutilizzabili**. Se domani facciamo un secondo livello, non dobbiamo ricreare il player da zero: lo istanziamo nella nuova scena e funziona subito. Separare le cose è un principio fondamentale: ogni "oggetto" del gioco (player, nemico, moneta) ha la sua scena.

### Crea una nuova scena

1. Nel menu in alto, clicca **Scene** → **New Scene**
2. Nel pannello **Scene** in alto a sinistra, clicca **Other Node** (non scegliere i nodi suggeriti)
3. Nella finestra di ricerca, scrivi `CharacterBody2D`
4. Seleziona **CharacterBody2D** e clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Create New Node" con "CharacterBody2D" cercato e selezionato -->

> [!IMPORTANT]
> **Cos'è CharacterBody2D? E perché non un altro tipo?** In Godot esistono diversi tipi di "corpi fisici". I tre principali sono:
> - **StaticBody2D** — un corpo fermo (muri, pavimenti). Non si muove mai.
> - **RigidBody2D** — un corpo controllato dalla fisica (rimbalza, cade, scivola). Realistico ma imprevedibile.
> - **CharacterBody2D** — un corpo controllato dal **codice**. Quando premi "destra", va a destra. Quando premi "salto", salta. Nessuna sorpresa.
>
> Per un platform game vogliamo controllo totale sul personaggio, quindi usiamo CharacterBody2D.

### Aggiungi lo sprite animato

Il player ha bisogno di un'immagine. Usiamo un **AnimatedSprite2D** — un nodo che mostra un'immagine che cambia nel tempo (un'animazione).

1. Fai **click destro** su `CharacterBody2D` → **Add Child Node...**
2. Cerca `AnimatedSprite2D` e clicca **Create**

<!-- 📸 SCREENSHOT: pannello Scene con AnimatedSprite2D come figlio di CharacterBody2D -->

Ora dobbiamo dirgli **quali immagini** mostrare. Le animazioni del nostro cavaliere sono tutte in un'unica immagine (`knight.png`) — uno **spritesheet**: una griglia di frame disposti in righe e colonne.

3. Seleziona `AnimatedSprite2D` nel pannello Scene
4. Nell'**Inspector**, trova la proprietà **Sprite Frames** e clicca su `<empty>` → **New SpriteFrames**
5. In basso si apre il **pannello SpriteFrames** — qui gestiamo le animazioni

<!-- 📸 SCREENSHOT: pannello SpriteFrames aperto in basso, con l'animazione "default" visibile -->

6. L'animazione si chiama `default` — **rinominala** facendo doppio click sul nome e scrivi `idle` (è l'animazione del personaggio fermo)

7. Clicca il bottone **Add Frames from Sprite Sheet** — è l'icona con la **griglia** (sembra una piccola griglia di quadrati)

<!-- 📸 SCREENSHOT: pannello SpriteFrames con il bottone "Add Frames from Sprite Sheet" (icona griglia) evidenziato -->

8. Si apre una finestra di selezione. Seleziona il file `assets/sprites/knight.png`
9. Nella finestra successiva, imposta:
   - **Horizontal**: `8`
   - **Vertical**: `8`

   L'immagine viene tagliata in una griglia 8×8 di frame da 32×32 pixel.

<!-- 📸 SCREENSHOT: finestra "Select Frames" con la griglia 8×8 impostata e l'immagine knight.png visibile -->

10. Seleziona i **primi 4 frame** della prima riga (quelli dell'animazione idle — il cavaliere fermo). Clicca sul primo, poi clicca sugli altri tre tenendo premuto **Ctrl** (o **Cmd** su Mac)
11. Clicca **Add 4 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con i 4 frame idle selezionati (evidenziati) e il bottone "Add 4 Frame(s)" visibile -->

12. Torna nel pannello SpriteFrames. Imposta l'**Autoplay** sull'animazione `idle`: clicca l'icona ▶ accanto al nome `idle`

<!-- 📸 SCREENSHOT: pannello SpriteFrames con i 4 frame caricati e l'Autoplay attivo su idle (icona ▶ evidenziata) -->

13. Infine, dobbiamo **centrare lo sprite** rispetto al nodo. Seleziona `AnimatedSprite2D` nell'Inspector, trova la proprietà **Offset** e imposta:
    - `x = 0`
    - `y = -12`

> [!NOTE]
> **Perché l'offset?** Il nodo CharacterBody2D sta ai "piedi" del personaggio (il punto di contatto col pavimento). Ma l'immagine dello sprite è centrata su se stessa. L'offset Y = -12 alza l'immagine verso l'alto così che i piedi del cavaliere coincidano con la posizione del nodo.

### Aggiungi la forma di collisione

Il player ha bisogno di una **forma di collisione** — un'area invisibile che dice a Godot "questa è la parte del personaggio che tocca il mondo". Senza collisione, il player attraverserebbe tutto.

1. Fai **click destro** su `CharacterBody2D` → **Add Child Node...**
2. Cerca `CollisionShape2D` e clicca **Create**
3. Seleziona `CollisionShape2D`. Nell'**Inspector**, alla proprietà **Shape**, clicca `<empty>` → **New CircleShape2D**
4. Espandi la proprietà **Shape** e imposta **Radius**: `5`
5. Imposta la **Position** del CollisionShape2D (nella sezione **Node2D → Transform**):
   - `x = 0`
   - `y = -5`

<!-- 📸 SCREENSHOT: viewport con il player e la forma di collisione circolare visibile in verde/azzurro, posizionata ai piedi. Inspector visibile con radius 5 e position y=-5 -->

> [!IMPORTANT]
> **Perché un cerchio e non un rettangolo?** Un cerchio ai piedi del personaggio scivola meglio sugli spigoli delle tile. Con un rettangolo, il player si "incastra" negli angoli delle piattaforme — un problema classico dei platform game. Il cerchio arrotonda il contatto e il movimento è più fluido.

### L'albero del player

Controlla che la scena sia così:

```
CharacterBody2D
├── AnimatedSprite2D
└── CollisionShape2D
```

### Salva la scena

Premi **Ctrl+S**. Salva come `res://scenes/player.tscn`.

---

## 8. Lo script di movimento

Il player esiste, ma non si muove. Per farlo muovere dobbiamo scrivere del **codice** — uno **script**. È il nostro primo programma!

### Crea lo script

1. Nel pannello **Scene**, seleziona il nodo `CharacterBody2D` (il nodo radice della scena player)
2. Clicca sull'icona **📜** (Attach Script) in alto nel pannello Scene

<!-- 📸 SCREENSHOT: pannello Scene con CharacterBody2D selezionato e il bottone "Attach Script" (icona pergamena) evidenziato -->

3. Si apre la finestra di creazione script:
   - **Path**: cambia il percorso in `res://scripts/player.gd`
   - **Template**: seleziona **CharacterBody2D: Basic Movement**
   - Clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Attach Node Script" con path res://scripts/player.gd e template "CharacterBody2D: Basic Movement" selezionato -->

> [!TIP]
> I **template** sono script già scritti da Godot per le situazioni più comuni. Il template "Basic Movement" genera il codice base per un personaggio di un platform game: gravità, salto e movimento orizzontale. Noi lo usiamo così com'è, cambiando solo un paio di valori.

Godot genera questo script e lo apre nell'editor. Vediamolo pezzo per pezzo.

### Riga per riga

Il codice completo è questo:

```gdscript
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
```

Non preoccuparti se sembra tanto — è il template che ha scritto Godot per noi. Adesso leggiamolo insieme.

---

**La prima riga:**

```gdscript
extends CharacterBody2D
```

Ogni script inizia con `extends` seguito dal tipo di nodo. Significa: "questo script controlla un CharacterBody2D". È il collegamento tra il codice e il nodo.

---

**Le costanti:**

```gdscript
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
```

Due numeri con un nome. `SPEED` è la velocità di movimento, `JUMP_VELOCITY` è la forza del salto (negativa perché in Godot l'asse Y punta verso il basso — per saltare "in alto" devi andare in negativo).

---

**La funzione principale:**

```gdscript
func _physics_process(delta: float) -> void:
```

Questa riga definisce una **funzione** — un blocco di codice con un nome. `_physics_process` è una funzione speciale di Godot: viene **eseguita 60 volte al secondo**, ogni frame. Tutto quello che sta dentro questa funzione succede continuamente, in loop, per tutta la durata del gioco.

Il `delta` è il tempo trascorso dall'ultimo frame (un numero piccolo, tipo 0.016 secondi). Lo usiamo per rendere il movimento fluido indipendentemente dalla velocità del computer.

---

**La gravità:**

```gdscript
	if not is_on_floor():
		velocity += get_gravity() * delta
```

"Se il player **non** è appoggiato su una superficie, aggiungi la gravità." Cioè: se sei in aria, cadi. `is_on_floor()` controlla se c'è qualcosa solido sotto i piedi del player.

---

**Il salto:**

```gdscript
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
```

"Se il giocatore ha appena premuto **Spazio** (o Enter) **e** il player è a terra, impostane la velocità verso l'alto." Il salto funziona solo da terra — non si può saltare in aria.

---

**Il movimento orizzontale:**

```gdscript
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
```

`Input.get_axis("ui_left", "ui_right")` restituisce un numero: `-1` se premi sinistra, `1` se premi destra, `0` se non premi niente.

- Se `direction` non è zero (stai premendo un tasto): la velocità orizzontale diventa `direction * SPEED`
- Se `direction` è zero (non premi niente): la velocità si riduce gradualmente fino a 0 con `move_toward`

---

**La riga finale:**

```gdscript
	move_and_slide()
```

Questa riga è fondamentale: **applica il movimento**. Prende tutta la velocità che abbiamo calcolato (gravità, salto, direzione) e muove effettivamente il player, gestendo le collisioni con il mondo. Senza questa riga, tutto il calcolo che abbiamo fatto non avrebbe effetto.

---

> [!NOTE]
> Non devi memorizzare tutto adesso. L'importante è capire la struttura: c'è la gravità che ti tira giù, il salto che ti porta su, il movimento che ti porta a destra o sinistra, e `move_and_slide()` che fa muovere tutto.

### Salva lo script

Premi **Ctrl+S** per salvare.

---

## 9. Lo script della scena principale

La scena `game.tscn` ha bisogno di un piccolo script per una cosa sola: **chiudere il gioco quando si preme Esc**.

1. Apri `game.tscn` (doppio click nel FileSystem)
2. Seleziona il nodo `Game` nel pannello Scene
3. Clicca l'icona **📜** (Attach Script)
4. Imposta il **Path** a `res://scripts/game.gd`, **Template** su **Empty**, e clicca **Create**
5. Scrivi questo codice:

```gdscript
extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
```

> [!NOTE]
> **Cosa fa?** `_unhandled_input` è una funzione che Godot chiama ogni volta che il giocatore preme un tasto. Noi controlliamo se il tasto è `ui_cancel` (cioè **Esc**): se sì, chiudiamo il gioco con `get_tree().quit()`.

Salva con **Ctrl+S**.

---

## 10. Metti il player nel livello

Adesso abbiamo due scene separate: `game.tscn` (il livello) e `player.tscn` (il personaggio). Dobbiamo mettere il player **dentro** il livello. In Godot questo si chiama **istanziare** una scena.

> [!IMPORTANT]
> **Cosa significa "istanziare"?** La scena `player.tscn` è come un **progetto** — la descrizione del personaggio. Quando la istanzi dentro `game.tscn`, crei una **copia attiva** di quel progetto nel livello. Se domani fai un secondo livello, puoi istanziare lo stesso player senza rifare nulla.

### Come fare

1. Apri `game.tscn`
2. Seleziona il nodo `Game` nel pannello Scene
3. Clicca l'icona **🔗** (Instantiate Child Scene) in alto nel pannello Scene — è il bottone con la catena

<!-- 📸 SCREENSHOT: pannello Scene con il nodo Game selezionato e il bottone "Instantiate Child Scene" (icona catena) evidenziato -->

4. Seleziona `scenes/player.tscn` e clicca **Open**
5. Il player appare nel viewport! **Trascinalo** su una piattaforma del livello così che quando il gioco parte sia appoggiato da qualche parte e non cada nel vuoto

<!-- 📸 SCREENSHOT: game.tscn con il player istanziato e posizionato su una piattaforma nel viewport -->

L'albero della scena `game.tscn` ora è:

```
Game
├── TileMapLayer background
├── TileMapLayer platforms
├── TileMapLayer foreground
└── player
```

> [!NOTE]
> Il nodo `player` nel pannello Scene ha un'icona diversa dagli altri — è un'icona con una **catena** 🔗. Questo indica che non è un nodo singolo, ma un'**istanza** di un'altra scena. Se fai doppio click su di lui, si apre la scena `player.tscn` originale.

---

## 11. Prova il gioco! ▶

Premi **▶** (o `F5`).

Il player dovrebbe:
- **Cadere** verso il basso (gravità) e atterrare sulle piattaforme
- **Muoversi** a destra e sinistra con le **frecce**
- **Saltare** con **Spazio** o **Enter**
- Il gioco si **chiude** premendo **Esc**

<!-- 📸 SCREENSHOT: gioco in esecuzione con il player che cammina sulle piattaforme -->

Se qualcosa non funziona:

| Problema | Cosa controllare |
|---|---|
| Il player cade nel vuoto | Le tile del layer `platforms` non hanno collisione, oppure il player non è sopra una piattaforma |
| Il player non si muove | Lo script `player.gd` non è attaccato al CharacterBody2D |
| Errore nello script | Controlla il pannello **Output** in basso — gli errori appaiono in rosso |
| Lo schermo è nero | La scena principale non è impostata su `game.tscn` (menu **Project** → **Project Settings** → **General** → **Run** → **Main Scene**) |

---

## Cosa abbiamo ottenuto

Riassumiamo quello che abbiamo costruito:

- ✅ Il progetto Godot è aperto e funzionante
- ✅ La scena `game.tscn` contiene **tre layer di tile** (sfondo, piattaforme, primo piano)
- ✅ La scena `player.tscn` contiene il **personaggio** con la sua animazione idle e la forma di collisione
- ✅ Lo script `player.gd` fa **muovere e saltare** il player
- ✅ Lo script `game.gd` chiude il gioco con **Esc**
- ✅ Il player è **istanziato** nel livello e **tutto funziona**

<!-- 📸 SCREENSHOT: il gioco in esecuzione, risultato finale della lezione — player che cammina/salta sul livello con le tile -->

---

## Prova tu 🎮

Ecco alcune cose che puoi provare a fare da solo:

1. **Ridisegna il livello**: cancella le tile che hai messo e creane di nuove. Prova a fare piattaforme a diverse altezze, corridoi, scale.

2. **Sperimenta con i numeri**: apri `player.gd` e prova a cambiare `SPEED` e `JUMP_VELOCITY`. Cosa succede con `SPEED = 50`? E con `SPEED = 500`? E se metti `JUMP_VELOCITY = -100`? Gioca con i valori e osserva come cambia il feeling.

3. **Esplora gli asset**: apri la cartella `assets/sprites/` nel FileSystem e guarda le immagini che contiene. Ci sono sprite per monete, nemici, frutti... li useremo nelle prossime lezioni.

---

## Prossima lezione

Il gioco funziona, ma ci sono problemi evidenti: il player è troppo veloce, la camera non lo segue, e il livello è statico — non ci sono ostacoli che si muovono.

Nella prossima lezione **rallenteremo il player**, aggiungeremo una **camera** che lo segue senza mostrare il vuoto, e costruiremo **piattaforme mobili** su cui saltare.
