# Lezione 04 – Nemici, monete e killzone

Nella lezione precedente abbiamo dato vita al personaggio con le animazioni e la macchina a stati. Oggi aggiungiamo gli **elementi di gioco**: monete da raccogliere, nemici che pattugliano le piattaforme e una killzone che fa ricominciare il livello quando il player muore.

---

## Cosa abbiamo adesso

Apri la cartella `lezione-04` in Godot (come nelle lezioni precedenti: **Import** → seleziona il file `project.godot` dentro `lezione-04/`).

Premi **▶** (o `F5`) per avviare il gioco. Ecco cosa trovi:

- Il **player** con tutte le animazioni (idle, run, jump, roll) e la macchina a stati
- La **capriola** (Shift) che rende il player veloce per un istante
- La **camera** che segue il player senza mostrare il vuoto
- Le **piattaforme mobili** e il livello costruito con le tile

Il gioco funziona, ma il livello è vuoto — non c'è niente da fare. Non ci sono oggetti da raccogliere, nessun pericolo, nessuna sfida. Oggi cambiamo tutto.

<!-- 📸 SCREENSHOT: il gioco in esecuzione allo stato iniziale di lezione-04 — il player sul livello, con animazioni funzionanti ma nessun nemico/moneta/killzone -->

---

## Cosa costruiamo oggi

- 🪙 **Creiamo le monete** — oggetti che il player raccoglie passandoci attraverso
- 💀 **Creiamo la killzone** — un'area invisibile che uccide il player con un effetto slow-motion
- 🐛 **Creiamo i nemici** — slime che pattugliano le piattaforme avanti e indietro
- 🛡️ **Aggiungiamo l'invulnerabilità** — durante la capriola il player non può morire
- 🗺️ **Popoliamo il livello** — mettiamo monete, nemici e killzone nella scena principale

---

## 1. Crea la scena della moneta

La moneta è il primo oggetto interattivo del gioco. Quando il player la tocca, la moneta scompare (e in futuro aggiungeremo un suono e un punteggio).

### Crea una nuova scena

1. Nel menu in alto, clicca **Scene** → **New Scene**
2. Nel pannello **Scene** clicca **Other Node**
3. Cerca `Area2D` e clicca **Create**

<!-- 📸 SCREENSHOT: finestra "Create New Node" con "Area2D" cercato e selezionato -->

> [!IMPORTANT]
> **Perché Area2D e non CharacterBody2D?** Il player è un `CharacterBody2D` perché deve muoversi, saltare e scontrarsi con il mondo. La moneta invece non si muove e non blocca il player — deve solo **rilevare** quando qualcuno la tocca. `Area2D` è pensato proprio per questo: rileva le sovrapposizioni con altri corpi senza bloccarli. Il player ci cammina attraverso, e noi riceviamo una notifica.

### Aggiungi lo sprite animato

La moneta ha un'animazione di rotazione. L'immagine `coin.png` è uno **spritesheet**: una striscia orizzontale di frame da 16×16 pixel.

1. Fai **click destro** su `Area2D` → **Add Child Node...**
2. Cerca `AnimatedSprite2D` e clicca **Create**
3. Seleziona `AnimatedSprite2D`. Nell'**Inspector**, trova **Sprite Frames** e clicca su `<empty>` → **New SpriteFrames**
4. In basso si apre il **pannello SpriteFrames**

<!-- 📸 SCREENSHOT: pannello SpriteFrames aperto con l'animazione "default" -->

5. Clicca il bottone **Add Frames from Sprite Sheet** (l'icona con la griglia)
6. Seleziona il file `assets/sprites/coin.png`
7. Nella finestra che si apre, imposta la griglia. Il file `coin.png` contiene 12 frame disposti in una riga orizzontale, ognuno da 16×16 pixel:
   - **Horizontal**: `12`
   - **Vertical**: `1`

<!-- 📸 SCREENSHOT: finestra "Select Frames" con la griglia 12×1 impostata e coin.png visibile -->

8. Seleziona **tutti i 12 frame**: clicca sul primo, poi **Ctrl+A** (o Cmd+A su Mac) per selezionarli tutti
9. Clicca **Add 12 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con tutti i 12 frame selezionati -->

10. Torna nel pannello SpriteFrames. Imposta la **velocità** (Speed): clicca sul campo numerico accanto a "FPS" e scrivi `9`

<!-- 📸 SCREENSHOT: pannello SpriteFrames con i 12 frame caricati e FPS impostato a 9 -->

11. Imposta l'**Autoplay** sull'animazione `default`: clicca l'icona **▶** accanto al nome dell'animazione

12. Seleziona il nodo `AnimatedSprite2D` nell'Inspector. Nella sezione **CanvasItem → Ordering**, imposta **Z Index** a `10`

> [!NOTE]
> **Perché Z Index 10?** Vogliamo che le monete siano sempre visibili sopra lo sfondo e le piattaforme. Con un valore alto come 10, la moneta appare davanti a quasi tutto il resto del livello.

### Imposta il collision layer

Il nodo radice `Area2D` ha bisogno di sapere **su quale layer di collisione** sta. Nella lezione 01 abbiamo configurato i layer fisici del progetto:

| Layer | Nome | Chi ci sta |
|---|---|---|
| 1 | Player | Il personaggio |
| 2 | Moving Platforms | Le piattaforme mobili |
| 3 | Pickups | Oggetti raccoglibili |
| 4 | Tiles | Le tile del livello |
| 5 | Killzone | Zone mortali |

La moneta va sul layer **Pickups** (layer 3).

1. Seleziona il nodo `Area2D` (il nodo radice della scena)
2. Nell'**Inspector**, cerca la sezione **Collision**
3. In **Layer**, **deseleziona** il layer 1 (che è attivo per default) e **seleziona** il layer 3 (Pickups)
4. In **Mask**, deseleziona tutto — la moneta non ha bisogno di rilevare altri oggetti, è lei che viene rilevata

<!-- 📸 SCREENSHOT: Inspector dell'Area2D con collision layer 3 (Pickups) selezionato e mask vuota -->

> [!IMPORTANT]
> **Come funzionano layer e mask?** Ogni corpo fisico ha due impostazioni: il **layer** (su quale strato si trova) e la **mask** (quali strati può "vedere"). Due oggetti interagiscono solo se il layer di uno corrisponde alla mask dell'altro. Il player ha mask che include Pickups, quindi rileva le monete. La moneta non ha bisogno di una mask perché non deve rilevare nessuno — è passiva.

### Aggiungi la forma di collisione

1. Fai **click destro** su `Area2D` → **Add Child Node...**
2. Cerca `CollisionShape2D` e clicca **Create**
3. Seleziona `CollisionShape2D`. Nell'**Inspector**, alla proprietà **Shape**, clicca `<empty>` → **New RectangleShape2D**
4. Espandi **Shape** e imposta **Size**: `x = 10`, `y = 10`

<!-- 📸 SCREENSHOT: viewport con la moneta animata e la forma di collisione rettangolare visibile -->

### L'albero della moneta

Controlla che la scena sia così:

```
Area2D
├── AnimatedSprite2D
└── CollisionShape2D
```

### Salva la scena

Premi **Ctrl+S**. Salva come `res://scenes/coin.tscn`.

---

## 2. Lo script della moneta

La moneta esiste ma non fa niente quando il player la tocca. Per farla reagire usiamo un **segnale** — il modo in cui Godot notifica che qualcosa è successo.

### Crea lo script

1. Seleziona il nodo `Area2D` (il nodo radice)
2. Clicca sull'icona **📜** (Attach Script)
3. Imposta il **Path** a `res://scripts/coin.gd`, **Template** su **Empty**, e clicca **Create**
4. Scrivi la prima riga:

```gdscript
extends Area2D
```

Salva con **Ctrl+S**. Non aggiungere altro per ora.

### Collega il segnale body_entered

I segnali sono il modo in cui i nodi comunicano tra loro in Godot. L'Area2D ha un segnale chiamato `body_entered` che scatta quando un corpo fisico (come il player) entra nell'area.

1. Seleziona il nodo `Area2D` nel pannello Scene
2. Nel pannello a destra, clicca sulla tab **Node** (accanto a Inspector)
3. Nella lista dei segnali, trova **body_entered(body: Node2D)**
4. Fai **doppio click** su `body_entered`

<!-- 📸 SCREENSHOT: pannello Node → Signals con body_entered evidenziato e la finestra di connessione aperta -->

5. Si apre una finestra di connessione. Il **Receiver Method** dovrebbe già dire `_on_body_entered`. Clicca **Connect**

Godot aggiunge automaticamente una funzione vuota nello script. Apri `coin.gd` — ora contiene:

```gdscript
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
```

> [!NOTE]
> **Cosa fa `body_entered`?** Ogni volta che un corpo fisico (un `CharacterBody2D`, un `StaticBody2D`...) entra nell'area di collisione dell'Area2D, Godot chiama questa funzione e le passa il corpo che è entrato come parametro `body`. Nel nostro caso, `body` sarà il player.

### Scrivi la logica della moneta

Sostituisci il contenuto della funzione `_on_body_entered`. Lo script completo diventa:

```gdscript
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Coin collision with " + body.name)
	queue_free()
```

Vediamolo riga per riga:

- `print("Coin collision with " + body.name)` — stampa un messaggio nel pannello Output. Utile per verificare che tutto funzioni. `body.name` è il nome del nodo che ha toccato la moneta (sarà "player")
- `queue_free()` — **distrugge** la moneta. La rimuove dalla scena. Scompare!

Salva con **Ctrl+S**.

### Prova con una moneta nel livello

Prima di continuare, verifichiamo che la moneta funzioni:

1. Apri `game.tscn`
2. Seleziona il nodo `Game`
3. Clicca l'icona **🔗** (Instantiate Child Scene)
4. Seleziona `scenes/coin.tscn` e clicca **Open**
5. Posiziona la moneta su una piattaforma vicino al player

Premi **▶**. Cammina verso la moneta: quando la tocchi, deve **scomparire**. Controlla il pannello **Output** in basso — dovresti vedere il messaggio "Coin collision with player".

<!-- 📸 SCREENSHOT: gioco in esecuzione con una moneta visibile vicino al player — e il pannello Output con il messaggio "Coin collision with player" -->

Se la moneta non scompare, controlla che:
- Il collision layer dell'Area2D sia **3** (Pickups)
- Il collision mask del player includa il layer **3** (Pickups)
- Il segnale `body_entered` sia collegato

Dopo il test, **cancella** la moneta che hai messo nel livello (selezionala nel pannello Scene e premi **Canc**) — la rimetteremo dopo in modo ordinato.

---

## 3. Crea la scena killzone

La killzone è un'area invisibile che uccide il player. La useremo in due modi: come pavimento sotto il livello (se il player cade nel vuoto, muore) e come hitbox dei nemici (se il player tocca un nemico, muore).

### Crea la scena

1. **Scene** → **New Scene** → **Other Node**
2. Cerca `Area2D` e clicca **Create**

### Imposta il collision layer

1. Seleziona il nodo `Area2D`
2. Nell'**Inspector**, sezione **Collision**:
   - **Layer**: deseleziona tutto e seleziona il layer **5** (Killzone)
   - **Mask**: deseleziona tutto

<!-- 📸 SCREENSHOT: Inspector dell'Area2D della killzone con collision layer 5 (Killzone) selezionato -->

### Aggiungi il Timer

La killzone non uccide il player immediatamente — prima rallenta il tempo (effetto **slow-motion**), aspetta un attimo, e poi ricarica la scena. Per gestire l'attesa usiamo un **Timer**.

1. Fai **click destro** su `Area2D` → **Add Child Node...**
2. Cerca `Timer` e clicca **Create**
3. Seleziona il nodo `Timer`. Nell'**Inspector**, imposta:
   - **Wait Time**: `1.5` (aspetta 1.5 secondi)
   - **One Shot**: **attivo** (il timer scatta una volta sola, non si ripete)

<!-- 📸 SCREENSHOT: Inspector del Timer con Wait Time 1.5 e One Shot attivato -->

> [!NOTE]
> **Cos'è un Timer?** È un nodo che conta alla rovescia. Quando lo avvii con `timer.start()`, aspetta il tempo impostato (1.5 secondi) e poi emette un segnale `timeout`. Lo usiamo per controllare quanto dura l'effetto slow-motion prima di ricaricare il livello.

### L'albero della killzone

```
Area2D
└── Timer
```

### Salva la scena

Premi **Ctrl+S** e salva come `res://scenes/killzone.tscn`.

---

## 4. Lo script della killzone

Lo script della killzone è il più interessante di questa lezione: gestisce la morte del player con un effetto rallentato.

### Crea lo script

1. Seleziona il nodo `Area2D`
2. Clicca **📜** (Attach Script)
3. Path: `res://scripts/killzone.gd`, Template: **Empty**, clicca **Create**
4. Scrivi:

```gdscript
extends Area2D

@onready var timer = $Timer
```

La prima riga collega lo script all'Area2D. La seconda crea un **riferimento** al nodo Timer — `$Timer` è una scorciatoia per "il nodo figlio che si chiama Timer". `@onready` significa "cercalo quando la scena è pronta, non prima".

Salva con **Ctrl+S**.

### Collega i segnali

La killzone ha bisogno di **due** segnali:

**Primo segnale — body_entered:**

1. Seleziona `Area2D` nel pannello Scene
2. Tab **Node** → **Signals** → doppio click su **body_entered** → **Connect**

**Secondo segnale — timeout del Timer:**

1. Seleziona il nodo **Timer** nel pannello Scene
2. Tab **Node** → **Signals** → doppio click su **timeout** → **Connect**

<!-- 📸 SCREENSHOT: pannello Node del Timer con il segnale timeout e la finestra di connessione aperta, receiver method: _on_timer_timeout -->

Adesso lo script ha due funzioni vuote generate da Godot. Riempiamole.

### La funzione _on_body_entered

Quando il player entra nella killzone, vogliamo:
1. Controllare se sta facendo la capriola (in quel caso è invulnerabile)
2. Disattivare la collisione del player (così non vengono generati altri segnali)
3. Avviare il timer
4. Rallentare il tempo

Sostituisci la funzione `_on_body_entered` con:

```gdscript
func _on_body_entered(body: Node2D) -> void:
	# Se il player sta rollando, è invulnerabile
	if body.has_method("is_rolling") and body.is_rolling():
		return
```

Queste prime righe controllano se il corpo che è entrato ha una funzione `is_rolling()` e se quella funzione restituisce `true`. In quel caso, usciamo dalla funzione con `return` — il player non muore.

> [!IMPORTANT]
> **Perché `has_method` prima di `is_rolling`?** Non tutti i corpi che possono entrare nella killzone sono il player. Potrebbe essere un nemico o qualsiasi altro oggetto. Se chiamassimo `body.is_rolling()` su un nodo che non ha quella funzione, Godot darebbe errore. Con `has_method("is_rolling")` controlliamo prima che la funzione esista.

Ora aggiungi il resto della funzione, subito dopo il blocco `if/return`:

```gdscript
	timer.ignore_time_scale = true
	body.get_node("CollisionShape2D").queue_free()
	print("Timer started!")
	timer.start()
	Engine.time_scale = 0.1
```

Vediamo ogni riga:

- `timer.ignore_time_scale = true` — dice al timer di **ignorare il rallentamento**. Senza questa riga, anche il timer andrebbe al rallentatore e i 1.5 secondi diventerebbero 15!
- `body.get_node("CollisionShape2D").queue_free()` — **distrugge** la forma di collisione del player. Così il player non può più scontrarsi con niente e cade attraverso il pavimento
- `print("Timer started!")` — messaggio di debug
- `timer.start()` — avvia il conto alla rovescia di 1.5 secondi
- `Engine.time_scale = 0.1` — **rallenta il tempo** al 10% della velocità normale. Tutto si muove lentissimo — è l'effetto slow-motion

### La funzione _on_timer_timeout

Quando il timer scade, il tempo di attesa è finito. Dobbiamo:
1. Rimettere il tempo alla velocità normale
2. Ricaricare la scena (ricominciare il livello)

Sostituisci la funzione `_on_timer_timeout` con:

```gdscript
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
```

- `Engine.time_scale = 1` — riporta il tempo alla velocità normale
- `get_tree().reload_current_scene()` — ricarica la scena corrente da zero. Il livello riparte dall'inizio, con il player nella posizione originale e tutte le monete di nuovo al loro posto

### Il codice completo

Controlla che `killzone.gd` sia così:

```gdscript
extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	# Se il player sta rollando, è invulnerabile
	if body.has_method("is_rolling") and body.is_rolling():
		return
	timer.ignore_time_scale = true
	body.get_node("CollisionShape2D").queue_free()
	print("Timer started!")
	timer.start()
	Engine.time_scale = 0.1

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
```

Salva con **Ctrl+S**.

### Prova la killzone

Testiamo la killzone mettendola temporaneamente nel livello:

1. Apri `game.tscn`
2. Seleziona `Game` → icona **🔗** → seleziona `killzone.tscn` → **Open**
3. Aggiungi una **CollisionShape2D** come figlia della killzone appena istanziata:
   - Click destro sulla killzone → **Add Child Node...** → `CollisionShape2D` → **Create**
   - Shape: **New RectangleShape2D**, Size: `x = 50`, `y = 10`
4. Posiziona la killzone su una piattaforma dove puoi camminarci sopra facilmente

Premi **▶** e cammina dentro la killzone. Dovresti vedere:
- Il tempo che **rallenta** drasticamente
- Il player che **cade** attraverso il pavimento (la collisione è stata distrutta)
- Dopo circa 1.5 secondi, il livello che **ricomincia**

Se funziona, **cancella** la killzone di test dal livello — la rimetteremo dopo nel posto giusto.

<!-- 📸 SCREENSHOT: gioco in esecuzione con l'effetto slow-motion attivo — il player che cade lentamente attraverso il pavimento -->

---

## 5. Crea la scena del nemico

Il nemico è uno slime verde che **pattuglia** le piattaforme: cammina in una direzione, e quando arriva al bordo o incontra un muro, si gira e torna indietro.

### Crea la scena

1. **Scene** → **New Scene** → **Other Node**
2. Cerca `Node2D` e clicca **Create**

> [!IMPORTANT]
> **Perché Node2D e non CharacterBody2D?** Il nemico non ha bisogno di gravità, salti o collisioni complesse. Si muove semplicemente a destra e sinistra cambiando la sua posizione. `Node2D` è il nodo base che ha una posizione nel mondo — è tutto quello che ci serve. Usare un nodo più semplice quando basta rende il progetto più leggero.

### Aggiungi lo sprite animato

Lo sprite dello slime è nell'immagine `slime_green.png` — uno spritesheet con più animazioni. Noi usiamo la **seconda riga** (4 frame da 24×24 pixel).

1. Fai **click destro** su `Node2D` → **Add Child Node...** → `AnimatedSprite2D` → **Create**
2. Seleziona `AnimatedSprite2D`. Nell'Inspector, **Sprite Frames** → `<empty>` → **New SpriteFrames**
3. Nel pannello SpriteFrames in basso, clicca **Add Frames from Sprite Sheet** (icona griglia)
4. Seleziona `assets/sprites/slime_green.png`
5. Nella finestra di selezione, imposta la griglia:
   - **Horizontal**: `4`
   - **Vertical**: `2`

<!-- 📸 SCREENSHOT: finestra "Select Frames" con slime_green.png e griglia 4×2 -->

6. Seleziona i **4 frame della seconda riga** (la riga in basso). Clicca sul primo frame della seconda riga, poi sugli altri tre tenendo premuto **Ctrl** (o **Cmd**)
7. Clicca **Add 4 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con i 4 frame della seconda riga selezionati -->

8. Imposta la velocità (**Speed/FPS**) a `5`
9. Attiva l'**Autoplay** sull'animazione `default`

10. Seleziona `AnimatedSprite2D` nell'Inspector. Trova la proprietà **Offset** e imposta:
    - `x = 0`
    - `y = -12`

> [!NOTE]
> L'offset Y = -12 alza l'immagine dello slime verso l'alto, così i "piedi" dello slime coincidono con la posizione del nodo (il punto dove cammina sulla piattaforma). È lo stesso principio che abbiamo usato per il player nella lezione 01.

### Aggiungi la killzone come hitbox

Il nemico deve uccidere il player al contatto. Invece di riscrivere la logica della morte da zero, **istanziamo la killzone** come figlio del nemico. Così riutilizziamo tutto il codice che abbiamo già scritto (slow-motion, timer, reload).

1. Seleziona il nodo `Node2D` (il nodo radice del nemico)
2. Clicca l'icona **🔗** (Instantiate Child Scene)
3. Seleziona `scenes/killzone.tscn` e clicca **Open**

La killzone appare come figlio del nemico. Ora aggiungi una forma di collisione **alla killzone istanziata**:

4. Fai **click destro** sul nodo `Area2D` (la killzone) → **Add Child Node...** → `CollisionShape2D` → **Create**
5. Seleziona `CollisionShape2D`. Shape: **New RectangleShape2D**, Size: `x = 7`, `y = 11`
6. Imposta la **Position** del CollisionShape2D:
   - `x = 0.5`
   - `y = -5.5`

<!-- 📸 SCREENSHOT: viewport con lo slime e la forma di collisione della killzone visibile attorno al corpo dello slime -->

> [!IMPORTANT]
> **Perché istanziare la killzone invece di ricrearla?** È lo stesso principio del player e delle piattaforme: le scene in Godot sono **riutilizzabili**. La killzone ha già lo script con il slow-motion, il timer e il reload. Istanziandola dentro il nemico, funziona subito senza scrivere altro codice. Se domani cambieremo la logica di morte (suono, animazione...), basterà modificare `killzone.gd` e il cambiamento si applicherà sia ai nemici che alla killzone del pavimento.

### Aggiungi i RayCast2D per il pattugliamento

Il nemico deve sapere quando arriva al **bordo** di una piattaforma o quando incontra un **muro**. Per questo usiamo i **RayCast2D** — raggi invisibili che controllano se c'è qualcosa in una direzione.

Servono 4 raycast:

| Nome | Cosa controlla | Posizione | Direzione (Target) |
|---|---|---|---|
| `RayCast2D - right_foot` | C'è pavimento a destra? | `(4, 0)` | `(0, 5)` — verso il basso |
| `RayCast2D - left_foot` | C'è pavimento a sinistra? | `(-4, 0)` | `(0, 5)` — verso il basso |
| `RayCast2D - right` | C'è un muro a destra? | `(0, -5)` | `(5, 0)` — verso destra |
| `RayCast2D - left` | C'è un muro a sinistra? | `(0, -5)` | `(-5, 0)` — verso sinistra |

**I raycast "piede" (foot):**

1. Fai **click destro** su `Node2D` → **Add Child Node...** → cerca `RayCast2D` → **Create**
2. Rinominalo in `RayCast2D - right_foot` (click destro → **Rename**)
3. Nell'**Inspector**, imposta:
   - **Position**: `x = 4`, `y = 0`
   - **Target Position**: `x = 0`, `y = 5`

<!-- 📸 SCREENSHOT: Inspector del RayCast2D - right_foot con position (4,0) e target (0,5) -->

4. Ripeti i passaggi per creare `RayCast2D - left_foot`:
   - **Position**: `x = -4`, `y = 0`
   - **Target Position**: `x = 0`, `y = 5`

> [!IMPORTANT]
> **Come funzionano i raycast "piede"?** Immagina il nemico che cammina verso destra. Il raycast `right_foot` parte leggermente a destra del centro dello slime e punta verso il basso. Se trova qualcosa (pavimento), tutto bene. Se **non** trova niente, significa che davanti allo slime c'è il vuoto — il bordo della piattaforma. A quel punto lo slime si gira.

**I raycast "muro":**

5. Crea un altro `RayCast2D` e rinominalo `RayCast2D - right`:
   - **Position**: `x = 0`, `y = -5`
   - **Target Position**: `x = 5`, `y = 0`

6. Crea l'ultimo `RayCast2D` e rinominalo `RayCast2D - left`:
   - **Position**: `x = 0`, `y = -5`
   - **Target Position**: `x = -5`, `y = 0`

### Imposta la collision mask dei raycast

I raycast devono cercare solo le **tile** (non il player, non le monete). Per ognuno dei 4 raycast:

1. Seleziona il RayCast2D
2. Nell'**Inspector**, sezione **Collision**, imposta la **Mask**:
   - Deseleziona tutto
   - Seleziona solo il layer **4** (Tiles)

<!-- 📸 SCREENSHOT: Inspector di un RayCast2D con collision mask impostata solo sul layer 4 (Tiles) -->

Per i due raycast "piede" (`right_foot` e `left_foot`), attiva anche un'opzione extra:

3. Nell'Inspector, trova **Hit From Inside** e mettici la spunta

> [!NOTE]
> **Cos'è Hit From Inside?** Normalmente un raycast ignora le collisioni se il suo punto di partenza è già dentro un oggetto solido. Con Hit From Inside attivo, il raycast rileva le collisioni anche se parte dall'interno di una tile. Questo serve per i piedi dello slime, che possono trovarsi leggermente dentro la piattaforma.

### L'albero del nemico

Controlla che la scena sia così:

```
Node2D
├── AnimatedSprite2D
├── Area2D (killzone.tscn)
│   ├── Timer
│   └── CollisionShape2D
├── RayCast2D - right_foot
├── RayCast2D - left_foot
├── RayCast2D - right
└── RayCast2D - left
```

### Salva la scena

Premi **Ctrl+S** e salva come `res://scenes/enemy.tscn`.

---

## 6. Lo script del nemico

Lo script del nemico è sorprendentemente corto: muove lo slime in una direzione e usa i raycast per decidere quando girarsi.

### Crea lo script

1. Seleziona il nodo `Node2D` (il nodo radice)
2. Clicca **📜** (Attach Script)
3. Path: `res://scripts/enemy.gd`, Template: **Empty**, clicca **Create**

### I riferimenti ai nodi

Per prima cosa, dichiariamo i riferimenti a tutti i nodi di cui abbiamo bisogno. Scrivi:

```gdscript
extends Node2D

@onready var ray_cast_2d_right_foot: RayCast2D = $"RayCast2D - right_foot"
@onready var ray_cast_2d_left_foot: RayCast2D = $"RayCast2D - left_foot"
@onready var direction = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d_right: RayCast2D = $"RayCast2D - right"
@onready var ray_cast_2d_left: RayCast2D = $"RayCast2D - left"
```

> [!NOTE]
> I nomi con gli spazi (come `RayCast2D - right_foot`) vanno tra **virgolette** nel percorso del nodo: `$"RayCast2D - right_foot"`. Senza virgolette, Godot penserebbe che il trattino è un'operazione di sottrazione.
>
> La variabile `direction` parte da `1` (destra). Quando lo slime si gira, diventa `-1` (sinistra).

### La velocità

Sotto i riferimenti, aggiungi la costante di velocità:

```gdscript
const SPEED = 35
```

35 pixel al secondo è una velocità lenta — lo slime passeggia tranquillo.

### La funzione di movimento

Ora aggiungi la funzione che muove il nemico. Scrivi sotto la costante:

```gdscript
func _physics_process(delta: float) -> void:
	position.x += SPEED * delta * direction
```

Questa riga sposta il nemico orizzontalmente. `SPEED * delta` è la distanza in pixel per questo frame, e `direction` determina la direzione: `1` va a destra, `-1` va a sinistra.

> [!IMPORTANT]
> **Perché `position.x +=` e non `velocity` come per il player?** Il player usa `velocity` e `move_and_slide()` perché è un `CharacterBody2D` — Godot gestisce le collisioni per lui. Il nemico è un semplice `Node2D`, non ha un sistema fisico. Lo muoviamo direttamente modificando la sua posizione. Più semplice, ma non gestisce collisioni automatiche — per quello usiamo i raycast.

### Il controllo dei bordi e dei muri

Aggiungi il resto dentro `_physics_process`, subito dopo la riga del movimento:

```gdscript
	if ray_cast_2d_right_foot.is_colliding() == false or ray_cast_2d_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
```

Questa condizione dice: "se il piede destro **non** trova pavimento (bordo!) **oppure** il raycast destro trova un muro, girati a sinistra". Cambiamo `direction` a `-1` e **specchiamo** lo sprite orizzontalmente così lo slime guarda a sinistra.

Subito sotto, aggiungi il controllo opposto:

```gdscript
	if ray_cast_2d_left_foot.is_colliding() == false or ray_cast_2d_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
```

Stessa logica, ma al contrario: se il piede sinistro non trova pavimento o c'è un muro a sinistra, lo slime si gira a destra.

### Il codice completo

Controlla che `enemy.gd` sia così:

```gdscript
extends Node2D

@onready var ray_cast_2d_right_foot: RayCast2D = $"RayCast2D - right_foot"
@onready var ray_cast_2d_left_foot: RayCast2D = $"RayCast2D - left_foot"
@onready var direction = 1
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

Salva con **Ctrl+S**.

---

## 7. Popola il livello

Abbiamo creato tutte le scene: moneta, killzone, nemico. Ora le mettiamo dentro `game.tscn` per creare un livello vero.

### La killzone del pavimento

Se il player cade giù dal livello, deve morire. Mettiamo una killzone che copre **tutto il fondo** della mappa.

1. Apri `game.tscn`
2. Seleziona il nodo `Game`
3. Clicca **🔗** (Instantiate Child Scene) → seleziona `killzone.tscn` → **Open**
4. Rinomina il nodo in `Killzone`

Questa killzone ha bisogno di una forma di collisione che copra tutta la larghezza del livello:

5. Fai **click destro** sulla `Killzone` → **Add Child Node...** → `CollisionShape2D` → **Create**
6. Shape: **New WorldBoundaryShape2D**

<!-- 📸 SCREENSHOT: Inspector del CollisionShape2D con WorldBoundaryShape2D selezionato -->

> [!NOTE]
> **Cos'è WorldBoundaryShape2D?** È una forma di collisione che si estende **all'infinito** in orizzontale. Perfetta per un pavimento invisibile: non importa quanto è largo il livello, la killzone copre tutto.

7. Imposta la **Position** del CollisionShape2D: `x = 0`, `y = 242` (sotto il livello, dove il player non dovrebbe mai arrivare)

### I nemici

Creiamo un nodo contenitore per i nemici, come abbiamo fatto per le piattaforme:

1. Seleziona `Game` → **click destro** → **Add Child Node...** → `Node` → **Create**
2. Rinominalo in `Enemies`

Ora istanzia i nemici:

3. Seleziona `Enemies` → **🔗** → seleziona `enemy.tscn` → **Open**
4. Rinomina in `Enemy 1` e posizionalo su una piattaforma (es. `x = 56`, `y = 160`)

<!-- 📸 SCREENSHOT: viewport con il primo nemico posizionato su una piattaforma -->

5. Ripeti per aggiungere altri nemici:
   - `Enemy 2` in posizione `x = 271`, `y = 192`
   - `Enemy 3` in posizione `x = 680`, `y = 144`

> [!TIP]
> Posiziona i nemici su piattaforme abbastanza lunghe da permettere il pattugliamento. Se la piattaforma è troppo corta, lo slime si girerà continuamente senza muoversi.

### Le monete

Stesso procedimento per le monete:

1. Seleziona `Game` → **click destro** → **Add Child Node...** → `Node` → **Create**
2. Rinominalo in `Coins`

3. Seleziona `Coins` → **🔗** → seleziona `coin.tscn` → **Open**
4. Posiziona la prima moneta nel livello

5. Ripeti per aggiungere altre monete. Mettine **almeno 5-7** in punti interessanti: sopra piattaforme, lungo percorsi, in posti che richiedono di saltare.

<!-- 📸 SCREENSHOT: viewport con diverse monete posizionate nel livello — alcune sulle piattaforme, alcune in aria da raggiungere con un salto -->

> [!TIP]
> Le monete sono più divertenti quando sono in posti che richiedono un piccolo sforzo per essere raggiunte: in cima a un salto, su una piattaforma lontana, lungo un percorso con nemici.

### L'albero finale di game.tscn

Controlla che la struttura della scena sia simile a questa:

```
Game
├── player
├── Killzone
│   └── CollisionShape2D
├── Enemies
│   ├── Enemy 1
│   ├── Enemy 2
│   └── Enemy 3
├── Tiles
│   ├── Background
│   ├── Background Elements
│   ├── Platforms
│   └── Foreground
├── Piattaforme
│   ├── Piattaforma 1
│   └── Piattaforma Animata
│       └── AnimationPlayer
└── Coins
    ├── Coin
    ├── Coin2
    ├── ...
    └── Coin7
```

### Prova tutto

Premi **▶**. Verifica che:

- Le **monete** scompaiono quando le tocchi
- I **nemici** camminano avanti e indietro sulle piattaforme e si girano al bordo
- Toccare un **nemico** attiva lo slow-motion e poi ricarica il livello
- **Cadere** sotto il livello attiva la stessa killzone
- Il pannello **Output** mostra i messaggi di debug

<!-- 📸 SCREENSHOT: gioco in esecuzione con nemici che pattugliano, monete visibili e il player nel livello -->

---

## 8. L'invulnerabilità durante la capriola

Se hai provato a fare la capriola (Shift) contro un nemico, potresti aver notato che il player **non muore**. Questo è il comportamento che abbiamo scritto nello script della killzone:

```gdscript
if body.has_method("is_rolling") and body.is_rolling():
    return
```

Questa riga controlla se il player sta facendo la capriola. Se sì, la killzone non fa niente — il player è **invulnerabile**.

La funzione `is_rolling()` l'abbiamo creata nella lezione precedente nello script del player:

```gdscript
func is_rolling() -> bool:
    return state == State.ROLL
```

Restituisce `true` quando il player è nello stato ROLL (capriola), `false` in tutti gli altri casi.

### Prova

Premi **▶** e avvicinati a un nemico. Prova a:

1. **Camminarci dentro** normalmente — dovresti morire (slow-motion + reload)
2. **Fare la capriola** (Shift) e passarci attraverso — dovresti sopravvivere!

La capriola diventa così una mossa tattica: ti serve per schivare i nemici, ma dura poco e devi cronometrarla bene.

<!-- 📸 SCREENSHOT: gioco in esecuzione con il player durante la capriola (animazione roll) che attraversa un nemico senza morire -->

---

## Cosa abbiamo ottenuto

Riassumiamo quello che abbiamo costruito in questa lezione:

- ✅ Le **monete** (Area2D) appaiono animate nel livello e **scompaiono** quando il player le tocca
- ✅ La **killzone** (Area2D) rallenta il tempo con un effetto **slow-motion** e poi **ricarica** il livello
- ✅ I **nemici** (Node2D con killzone istanziata) **pattugliano** le piattaforme e si girano al bordo
- ✅ La killzone del **pavimento** uccide il player se cade nel vuoto
- ✅ Il player è **invulnerabile** durante la capriola — può attraversare i nemici
- ✅ Il livello ha **elementi di gioco** veri: raccolta, pericolo, tattica

<!-- 📸 SCREENSHOT: il gioco in esecuzione con il risultato finale della lezione — monete, nemici che pattugliano, player nel livello -->

---

## Prova tu 🎮

Ecco alcune cose che puoi provare a fare da solo:

1. **Aggiungi più nemici e monete**: popola il livello con almeno 5 nemici e 10 monete. Prova a creare zone dove devi cronometrare la capriola per passare tra due nemici.

2. **Cambia la velocità dei nemici**: apri `enemy.gd` e modifica `SPEED = 35`. Cosa succede con 15? E con 80? Trova la velocità che ti sembra più giusta per il tuo livello.

3. **Sperimenta con il slow-motion**: in `killzone.gd`, prova a cambiare `Engine.time_scale = 0.1` con valori diversi. Con `0.01` il tempo quasi si ferma. Con `0.5` il rallentamento è appena percettibile. Prova anche a cambiare il `wait_time` del Timer.

---

## Prossima lezione

Il gioco ha tutti gli elementi fondamentali: un player con animazioni, un livello con piattaforme mobili, monete da raccogliere, nemici da evitare e la possibilità di ricominciare. Ma manca qualcosa che fa una differenza enorme nel "feeling" di un gioco: il **suono**.

Nella prossima lezione aggiungeremo **effetti sonori** (salto, raccolta monete, morte), una **musica di sottofondo** che continua anche quando il livello ricomincia, e un **punteggio** che conta le monete raccolte.
