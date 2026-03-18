# Lezione 03 – Animazioni e macchina a stati

Nella lezione precedente abbiamo aggiunto la camera, rallentato il player e costruito piattaforme mobili. Il gioco funziona, ma il personaggio ha un difetto evidente: mostra sempre la stessa immagine, che stia fermo, che corra o che salti. Oggi gli diamo vita: aggiungiamo le animazioni e riscriviamo lo script con una **macchina a stati**.

---

## Cosa abbiamo adesso

Apri la cartella `lezione-03` in Godot (come hai fatto nelle lezioni precedenti: **Import** → seleziona il file `project.godot` dentro `lezione-03/`).

Premi **▶** (o `F5`) per avviare il gioco. Ecco cosa trovi:

- Il **livello** con le tile e le piattaforme mobili
- Il **player** che si muove con le frecce e salta con Spazio
- La **camera** che lo segue e si ferma ai bordi della mappa
- Il tasto **Esc** chiude il gioco

Prova a muoverti un po'. Il player ha un'unica animazione — `idle` — che si ripete sempre, anche quando corre o salta. Sembra un pupazzo che scivola sul pavimento. In questa lezione risolviamo questo problema.

<!-- 📸 SCREENSHOT: il gioco in esecuzione — il player che "scivola" sul pavimento con l'animazione idle mentre si muove -->

---

## Cosa costruiamo oggi

- 🎞️ **Aggiungiamo 5 nuove animazioni** al player (corsa, salto, capriola, colpo, morte)
- 🎮 **Creiamo un nuovo input** — il tasto Shift per la capriola
- 🧠 **Riscriviamo lo script del player** con una macchina a stati — un modo ordinato per gestire tanti comportamenti diversi
- 🦘 **Implementiamo il salto variabile** — tocco breve = salto corto, tocco lungo = salto alto
- 🌀 **Aggiungiamo la capriola** — il player si lancia in avanti rotolando

---

## 1. Lo spritesheet del cavaliere

Prima di aggiungere le animazioni, capiamo com'è organizzato lo spritesheet `knight.png`. È una griglia **8 colonne × 8 righe** di frame da **32×32 pixel**. Ogni riga contiene un'animazione diversa:

| Riga | Posizione Y | Cosa contiene | Frame usati |
|---|---|---|---|
| 0 | y = 0 | **idle** — fermo | 4 frame |
| 1 | y = 32 | (non usata in questa lezione) | — |
| 2 | y = 64 | **run** — corsa (prima metà) | 8 frame |
| 3 | y = 96 | **run** — corsa (seconda metà) + **jump** | 8 frame run + 1 frame jump |
| 4 | y = 128 | (non usata in questa lezione) | — |
| 5 | y = 160 | **roll** — capriola | 8 frame |
| 6 | y = 192 | **hit** — colpito | 4 frame |
| 7 | y = 224 | **death** — morte | 4 frame |

> [!NOTE]
> La riga 0 è quella in alto (la prima). La riga 2 è la terza dall'alto. Quando lavoriamo nello SpriteFrames, selezioniamo i frame cliccandoci sopra nella griglia — basta contare le righe dall'alto.

> [!IMPORTANT]
> **Perché la corsa occupa due righe?** Perché l'animazione di corsa ha **16 frame** — troppi per una singola riga di 8. Quindi i primi 8 sono nella riga 2 e gli altri 8 nella riga 3. È una cosa comune negli spritesheet: quando un'animazione è lunga, continua nella riga successiva.

---

## 2. Aggiungere l'animazione "run"

Apri la scena del player: nel **FileSystem** fai doppio click su `scenes/player.tscn`.

### Apri il pannello SpriteFrames

1. Seleziona il nodo `AnimatedSprite2D` nel pannello **Scene**
2. In basso si apre il **pannello SpriteFrames** — lo riconosci perché mostra l'animazione `idle` con i suoi 4 frame

<!-- 📸 SCREENSHOT: pannello SpriteFrames con l'animazione idle selezionata e i 4 frame visibili -->

### Crea l'animazione "run"

3. Nel pannello SpriteFrames, in alto a sinistra, c'è la lista delle animazioni (per ora solo `idle`). Clicca il bottone **Add Animation** (l'icona con il **+**, sopra la lista delle animazioni)
4. Compare una nuova animazione chiamata `new_animation`. **Rinominala**: doppio click sul nome → scrivi `run`

<!-- 📸 SCREENSHOT: pannello SpriteFrames con la nuova animazione "run" nella lista a sinistra, selezionata -->

### Aggiungi i frame dalla spritesheet

5. Con l'animazione `run` selezionata, clicca il bottone **Add Frames from Sprite Sheet** — l'icona con la **griglia** (la stessa che hai usato per idle nella lezione 01)

<!-- 📸 SCREENSHOT: pannello SpriteFrames con il bottone "Add Frames from Sprite Sheet" (icona griglia) evidenziato -->

6. Si apre una finestra. Seleziona il file `assets/sprites/knight.png`
7. Nella finestra successiva, controlla che la griglia sia **8 × 8** (Horizontal: `8`, Vertical: `8`). Se la griglia è già impostata dalla volta scorsa, non serve cambiarla

<!-- 📸 SCREENSHOT: finestra "Select Frames" con la griglia 8×8 e lo spritesheet knight.png visibile -->

8. L'animazione di corsa occupa **due righe intere**: la riga 2 (terza dall'alto) e la riga 3 (quarta dall'alto). Seleziona tutti e **8 i frame della riga 2** — clicca sul primo, poi sugli altri sette tenendo premuto **Ctrl** (o **Cmd** su Mac)
9. Poi seleziona anche tutti e **8 i frame della riga 3** (stessa cosa, tenendo premuto Ctrl)
10. Hai selezionato **16 frame** in totale. Clicca **Add 16 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con i 16 frame delle righe 2 e 3 selezionati (evidenziati in blu) -->

### Imposta la velocità

11. Torna nel pannello SpriteFrames. L'animazione `run` ora mostra i 16 frame. Imposta la **velocità** (il campo **FPS** in alto): scrivi `10`
12. Verifica che il **loop** sia attivo — l'icona con le frecce circolari accanto agli FPS deve essere accesa (di default lo è)

<!-- 📸 SCREENSHOT: pannello SpriteFrames con l'animazione run, i 16 frame caricati, FPS impostato a 10, loop attivo -->

### Prova rapida

Clicca il bottone **▶** nel pannello SpriteFrames (non quello del gioco — quello piccolo dentro il pannello in basso) per vedere l'anteprima dell'animazione. Il cavaliere dovrebbe correre!

> [!TIP]
> Se l'ordine dei frame ti sembra sbagliato (il cavaliere si muove in modo strano), controlla di aver selezionato i frame nell'ordine giusto: prima tutta la riga 2 da sinistra a destra, poi tutta la riga 3 da sinistra a destra.

---

## 3. Aggiungere l'animazione "jump"

L'animazione di salto è semplice: un singolo frame statico. Il cavaliere assume una posa "in aria" e la mantiene per tutta la durata del salto.

### Crea l'animazione

1. Nel pannello SpriteFrames, clicca **Add Animation** (il **+**)
2. Rinomina la nuova animazione in `jump`

### Aggiungi il frame

3. Clicca **Add Frames from Sprite Sheet** (icona griglia)
4. Seleziona `assets/sprites/knight.png` → verifica la griglia 8×8
5. Seleziona **un solo frame**: il **primo frame della riga 3** (quarta riga dall'alto, primo quadrato a sinistra). È il frame in posizione y=96, x=0
6. Clicca **Add 1 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con il singolo frame di jump selezionato (primo frame della riga 3) -->

### Imposta la velocità

7. Imposta gli **FPS** a `0` — con un solo frame, la velocità non conta, ma mettiamo 0 per chiarezza
8. Lascia il **loop** attivo (anche con un frame solo non fa differenza, ma per coerenza lo teniamo acceso)

> [!NOTE]
> **Perché un solo frame per il salto?** In molti giochi 2D, specialmente in pixel art, il salto usa un singolo frame perché dura poco e il giocatore è concentrato sulla traiettoria, non sull'animazione. Un frame statico con la posa giusta funziona bene. Se avessimo un'animazione lunga, dovremmo sincronizzarla con la durata del salto — complicazione inutile.

---

## 4. Aggiungere l'animazione "roll"

La capriola (roll) è un'animazione veloce: il cavaliere si avvolge su se stesso e rotola in avanti.

### Crea l'animazione

1. Clicca **Add Animation** (il **+**) nel pannello SpriteFrames
2. Rinomina in `roll`

### Aggiungi i frame

3. Clicca **Add Frames from Sprite Sheet** → seleziona `knight.png` → griglia 8×8
4. Seleziona tutti e **8 i frame della riga 5** (sesta riga dall'alto, y=160)
5. Clicca **Add 8 Frame(s)**

<!-- 📸 SCREENSHOT: finestra "Select Frames" con gli 8 frame della riga 5 selezionati -->

### Imposta la velocità

6. Imposta gli **FPS** a `21`
7. Verifica che il **loop** sia attivo

> [!IMPORTANT]
> **Perché la velocità è così alta (21 FPS)?** Perché la capriola dura solo 0.33 secondi (un terzo di secondo). Con 8 frame in 0.33 secondi, servono circa 24 frame al secondo per completare l'animazione in tempo. Con 21 FPS ci siamo quasi — il risultato è un rotolamento rapido e convincente.

---

## 5. Aggiungere le animazioni "hit" e "death"

Queste due animazioni servono per quando il player viene colpito e quando muore. Non le useremo in questa lezione, ma le creiamo ora così sono pronte per la prossima.

### Animazione "hit"

1. Clicca **Add Animation** → rinomina in `hit`
2. Clicca **Add Frames from Sprite Sheet** → seleziona `knight.png` → griglia 8×8
3. Seleziona i **primi 4 frame della riga 6** (settima riga dall'alto, y=192)
4. Clicca **Add 4 Frame(s)**
5. Imposta gli **FPS** a `8`
6. **Disattiva il loop**: clicca sull'icona delle frecce circolari accanto agli FPS — deve essere spenta

<!-- 📸 SCREENSHOT: pannello SpriteFrames con l'animazione hit, loop disattivato -->

### Animazione "death"

7. Clicca **Add Animation** → rinomina in `death`
8. **Add Frames from Sprite Sheet** → `knight.png` → griglia 8×8
9. Seleziona i **primi 4 frame della riga 7** (ultima riga, y=224)
10. Clicca **Add 4 Frame(s)**
11. Imposta gli **FPS** a `5`
12. **Disattiva il loop** (come per hit)

> [!IMPORTANT]
> **Perché hit e death non hanno il loop?** Perché sono animazioni che devono succedere **una volta sola**: il player viene colpito, l'animazione parte, arriva all'ultimo frame e si ferma lì. Se avessero il loop, il cavaliere continuerebbe a ripetere l'animazione di morte all'infinito — non è quello che vogliamo.

### Controlla tutte le animazioni

A questo punto la lista delle animazioni nel pannello SpriteFrames dovrebbe contenere **6 voci**:

| Animazione | Frame | FPS | Loop |
|---|---|---|---|
| idle | 4 | 3 | sì |
| run | 16 | 10 | sì |
| jump | 1 | 0 | sì |
| roll | 8 | 21 | sì |
| hit | 4 | 8 | no |
| death | 4 | 5 | no |

Salva con **Ctrl+S**.

<!-- 📸 SCREENSHOT: pannello SpriteFrames con la lista di tutte e 6 le animazioni visibile a sinistra -->

---

## 6. Aggiungere l'input "roll"

Per la capriola serve un tasto dedicato. Usiamo **Shift**. Dobbiamo dire a Godot che esiste un'azione chiamata `roll` collegata al tasto Shift.

### Come fare

1. Vai nel menu in alto: **Project** → **Project Settings...**
2. Clicca sulla tab **Input Map** (in alto nella finestra)
3. Nel campo di testo **Add New Action** in alto, scrivi `roll`
4. Clicca il bottone **Add** (o premi Invio)

<!-- 📸 SCREENSHOT: Project Settings → Input Map con il campo "Add New Action" e "roll" scritto -->

5. L'azione `roll` appare nella lista. Ora devi assegnarle un tasto: clicca il bottone **+** accanto a `roll`
6. Si apre una finestra che aspetta che tu prema un tasto. Premi **Shift** sulla tastiera
7. La finestra mostra il tasto riconosciuto. Clicca **OK**

<!-- 📸 SCREENSHOT: Input Map con l'azione "roll" e il tasto Shift assegnato -->

8. Chiudi le Project Settings

> [!IMPORTANT]
> **Perché creare un'azione e non leggere il tasto direttamente?** In Godot, gli input si gestiscono con le **azioni** (actions). Invece di scrivere nel codice "se il giocatore preme Shift", scriviamo "se il giocatore preme il tasto dell'azione roll". Il vantaggio è che puoi cambiare il tasto in qualsiasi momento (es. da Shift a Ctrl) senza toccare il codice — cambi solo la mappa nell'Input Map.

---

## 7. Il problema dello script attuale

Apriamo `player.gd` nel FileSystem (doppio click su `scripts/player.gd`). Ecco lo script attuale:

```gdscript
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -270.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
```

Questo script funziona, ma non sa niente delle animazioni. Se volessimo aggiungere le animazioni senza una struttura, dovremmo scrivere qualcosa del tipo:

```
se il player è a terra e non si muove → avvia "idle"
se il player è a terra e si muove → avvia "run"
se il player è in aria → avvia "jump"
se il player sta rollando → avvia "roll"
se il player sta rollando e vuole saltare → NON saltare
se il player è in aria e vuole rollare → NON rollare
...
```

Con 6 animazioni e tutte le combinazioni possibili, il codice diventa un groviglio di `if` dentro `if` dentro `if`. Aggiungi un'animazione nuova e devi toccare tutto. C'è un modo migliore.

---

## 8. La macchina a stati

L'idea è semplice: il player si trova sempre in **uno stato alla volta**. In ogni momento sa se sta fermo (IDLE), se corre (RUN), se è in aria (JUMP) o se sta rotolando (ROLL).

Ogni stato ha le sue regole:
- **IDLE**: il player decelera, può iniziare a correre, può saltare, può rollare
- **RUN**: il player si muove, può fermarsi, può saltare, può rollare
- **JUMP**: il player è in aria, quando atterra passa a IDLE o RUN
- **ROLL**: il player rotola per un tempo fisso, non può fare altro finché la capriola non finisce

In questo modo il codice di ogni stato è indipendente dagli altri. Quando aggiungi un nuovo stato, scrivi solo le sue regole senza toccare il resto.

> [!IMPORTANT]
> **Perché non semplicemente aggiungere degli if?** Perché gli if controllano *condizioni*, non *stati*. Con gli if devi ricordarti tutte le combinazioni: "se è a terra E si muove E non sta rollando E non è stato appena colpito, allora...". Con una macchina a stati, ogni stato gestisce solo se stesso. È un modo per tenere il codice organizzato quando il personaggio ha tanti comportamenti.

---

## 9. Riscriviamo player.gd — passo per passo

Adesso riscriviamo lo script del player da zero. **Cancella tutto** il contenuto di `player.gd` — lo ricostruiamo pezzo per pezzo.

### Passo 1: Le costanti

Scrivi queste righe:

```gdscript
extends CharacterBody2D

# === Costanti di movimento ===
const SPEED = 100.0
const JUMP_VELOCITY = -270.0
const JUMP_CUT_FACTOR = 0.4
const ROLL_SPEED = 180.0
const ROLL_DURATION = 0.33
```

Le prime due costanti le conosci già. Le nuove sono:

- `JUMP_CUT_FACTOR` — serve per il **salto variabile**: se rilasci il tasto salto mentre stai salendo, la velocità viene moltiplicata per 0.4 (cioè ridotta al 40%). Risultato: tocco breve = salto corto, tocco lungo = salto alto.
- `ROLL_SPEED` — la velocità durante la capriola (180, più alta di SPEED perché la capriola è uno scatto rapido)
- `ROLL_DURATION` — quanto dura la capriola in secondi (0.33 = un terzo di secondo)

---

### Passo 2: Gli stati

Aggiungi sotto le costanti (lascia una riga vuota):

```gdscript
# === Stati possibili ===
enum State { IDLE, RUN, JUMP, ROLL }
```

`enum` è un modo per definire una lista di nomi. Dopo questa riga, `State.IDLE`, `State.RUN`, `State.JUMP` e `State.ROLL` sono valori che puoi usare nel codice. Dietro le quinte sono numeri (0, 1, 2, 3), ma scrivere `State.IDLE` è molto più leggibile di scrivere `0`.

---

### Passo 3: Le variabili

Aggiungi sotto l'enum:

```gdscript
# === Variabili ===
var state: State = State.IDLE
var roll_timer: float = 0.0
var roll_direction: float = 0.0
```

Queste sono **variabili** — contenitori con un nome che possono cambiare durante il gioco.

- `state` — lo stato attuale del player. All'inizio è `IDLE` (fermo)
- `roll_timer` — un contatore che tiene traccia di quanto tempo manca alla fine della capriola
- `roll_direction` — la direzione della capriola (-1 per sinistra, 1 per destra)

> [!IMPORTANT]
> **Qual è la differenza tra `const` e `var`?** Una `const` (costante) ha un valore fisso che non cambia mai durante il gioco — la velocità è sempre 100, il salto è sempre -270. Una `var` (variabile) cambia: lo stato parte da IDLE ma diventa RUN, JUMP, ROLL... Le costanti si scrivono in MAIUSCOLO per convenzione, le variabili in minuscolo.

---

### Passo 4: Il riferimento allo sprite

Aggiungi sotto le variabili:

```gdscript
# Riferimento all'AnimatedSprite2D (lo prendiamo una volta sola)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
```

Questa riga crea una variabile `anim` che punta al nodo `AnimatedSprite2D` del player. `$AnimatedSprite2D` è una scorciatoia di Godot che significa "il nodo figlio che si chiama AnimatedSprite2D". `@onready` significa "assegna questa variabile quando il nodo è pronto" — cioè quando il gioco parte.

Useremo `anim` per cambiare animazione e girare lo sprite quando il player cambia direzione.

---

### Passo 5: La funzione _physics_process

Aggiungi sotto (lascia una riga vuota):

```gdscript
func _physics_process(delta: float) -> void:
	# Gravità — si applica sempre, in ogni stato
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Leggiamo la direzione premuta dal giocatore
	var direction := Input.get_axis("ui_left", "ui_right")

	# Flip della sprite quando si preme una direzione
	if direction != 0:
		anim.flip_h = direction < 0

	# === Macchina a stati ===
	match state:
		State.IDLE:
			_state_idle(direction)
		State.RUN:
			_state_run(direction)
		State.JUMP:
			_state_jump(direction)
		State.ROLL:
			_state_roll(delta)

	# Movimento effettivo
	move_and_slide()
```

Ci sono due cose nuove qui:

**`anim.flip_h = direction < 0`** — quando il giocatore preme sinistra, `direction` è `-1`, quindi `direction < 0` è `true`, e `flip_h = true` ribalta lo sprite orizzontalmente. Quando preme destra, `direction` è `1`, `direction < 0` è `false`, e lo sprite torna normale. Risultato: il cavaliere guarda nella direzione in cui cammina.

**`match state`** — è il cuore della macchina a stati. `match` funziona come un grande "se": controlla il valore di `state` e chiama la funzione corrispondente. Se lo stato è IDLE chiama `_state_idle`, se è RUN chiama `_state_run`, e così via. Ogni stato ha la sua funzione separata.

---

### Passo 6: Lo stato IDLE — fermo a terra

Aggiungi sotto `_physics_process` (lascia una riga vuota):

```gdscript
func _state_idle(direction: float) -> void:
	# Decelerazione fino a fermarsi
	velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction != 0:
		_change_state(State.RUN)
		return
```

Questa funzione viene chiamata ogni frame quando il player è nello stato IDLE (fermo a terra). Fa due cose:

1. **Decelera** — `move_toward` porta la velocità orizzontale gradualmente a 0
2. **Controlla le transizioni** — le condizioni per passare a un altro stato:
   - Se non è a terra → passa a JUMP (sta cadendo da una piattaforma)
   - Se preme Spazio → salta
   - Se preme Shift e si sta muovendo → inizia la capriola
   - Se preme una freccia → passa a RUN

Il `return` dopo ogni transizione serve per fermare la funzione. Se il player ha iniziato a saltare, non ha senso controllare anche se vuole correre.

> [!NOTE]
> **Non preoccuparti se `_change_state`, `_jump` e `_start_roll` non esistono ancora.** Le scriveremo tra poco. Per ora stiamo costruendo la struttura.

---

### Passo 7: Lo stato RUN — corsa a terra

Aggiungi sotto:

```gdscript
func _state_run(direction: float) -> void:
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction == 0 and is_zero_approx(velocity.x):
		_change_state(State.IDLE)
		return
```

Molto simile a IDLE, ma con una differenza: qui il player si **muove**. Se `direction` non è zero, la velocità diventa `direction * SPEED`. Se smette di premere le frecce, decelera — e quando la velocità arriva a zero, torna allo stato IDLE.

`is_zero_approx(velocity.x)` controlla se la velocità è praticamente zero. In programmazione, a volte un numero non arriva mai esattamente a 0 ma a qualcosa tipo 0.00001 — `is_zero_approx` gestisce questo caso.

---

### Passo 8: Lo stato JUMP — in aria

Aggiungi sotto:

```gdscript
func _state_jump(direction: float) -> void:
	# Movimento orizzontale in aria
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Variable jump: se rilasci il tasto mentre sali, tagli la velocità
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_FACTOR

	# Transizione: atterra
	if is_on_floor():
		if direction != 0:
			_change_state(State.RUN)
		else:
			_change_state(State.IDLE)
		return
```

Qui c'è la cosa più interessante di questa lezione: il **salto variabile**.

La riga `if Input.is_action_just_released("ui_accept") and velocity.y < 0` controlla due cose: (1) il giocatore ha **rilasciato** il tasto di salto, e (2) il player sta ancora **salendo** (velocità Y negativa = verso l'alto).

Se entrambe le condizioni sono vere, `velocity.y *= JUMP_CUT_FACTOR` moltiplica la velocità per 0.4 — cioè la riduce drasticamente. Il player smette quasi di salire e inizia a cadere.

Il risultato: se tieni premuto Spazio, fai il salto pieno. Se lo premi e rilasci velocemente, fai un saltino corto. Quasi tutti i platform game moderni usano questo sistema.

> [!TIP]
> Quando atterra, il player controlla se stai premendo una freccia: se sì, passa direttamente a RUN (così non c'è un frame di "fermo" tra l'atterraggio e la corsa); se no, passa a IDLE.

---

### Passo 9: La funzione _change_state

Aggiungi sotto:

```gdscript
func _change_state(new_state: State) -> void:
	# Evitiamo di riavviare la stessa animazione
	if state == new_state:
		return

	state = new_state

	match state:
		State.IDLE:
			anim.play("idle")
		State.RUN:
			anim.play("run")
		State.JUMP:
			anim.play("jump")
		State.ROLL:
			anim.play("roll")
```

Questa funzione viene chiamata ogni volta che il player cambia stato. Fa due cose:

1. **Aggiorna la variabile `state`** al nuovo stato
2. **Avvia l'animazione corrispondente** con `anim.play("nome")`

Il controllo `if state == new_state: return` serve per evitare di riavviare un'animazione che è già in corso. Se il player è già in RUN e chiami `_change_state(State.RUN)`, l'animazione non ricomincia da capo — continua dove era.

> [!IMPORTANT]
> **Perché mettere `anim.play` qui e non dentro ogni stato?** Perché così il cambio di animazione è in **un posto solo**. Se domani vuoi aggiungere un effetto sonoro quando cambia stato, o un effetto visivo, lo aggiungi in `_change_state` e funziona per tutti gli stati. Non devi cercare e modificare 4 funzioni diverse.

---

### Passo 10: La funzione _jump

Aggiungi sotto:

```gdscript
func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	_change_state(State.JUMP)
```

Semplice: imposta la velocità verso l'alto e cambia lo stato a JUMP. Abbiamo messo queste due righe in una funzione separata perché il salto si può fare da IDLE e da RUN — senza una funzione, dovremmo scrivere le stesse righe in due posti diversi.

---

### Passo 11: Lo stato ROLL e la funzione _start_roll

Aggiungi le due funzioni sotto:

```gdscript
func _start_roll(direction: float) -> void:
	roll_direction = sign(direction)
	roll_timer = ROLL_DURATION
	_change_state(State.ROLL)
```

`_start_roll` prepara la capriola: salva la direzione (sinistra o destra) e imposta il timer a 0.33 secondi. `sign(direction)` restituisce `-1` se la direzione è negativa e `1` se è positiva — ci serve solo il verso, non il valore esatto.

```gdscript
func _state_roll(delta: float) -> void:
	roll_timer -= delta
	velocity.x = roll_direction * ROLL_SPEED

	# Transizione: la capriola è finita
	if roll_timer <= 0.0:
		if not is_on_floor():
			_change_state(State.JUMP)
		elif is_zero_approx(Input.get_axis("ui_left", "ui_right")):
			_change_state(State.IDLE)
		else:
			_change_state(State.RUN)
		return
```

Lo stato ROLL è diverso dagli altri: il player **non può fare niente** finché la capriola non finisce. Non può saltare, non può cambiare direzione — va dritto nella direzione scelta a velocità ROLL_SPEED.

`roll_timer -= delta` sottrae il tempo passato dall'ultimo frame. Quando il timer arriva a zero, la capriola è finita e il player torna allo stato appropriato (JUMP se è in aria, IDLE se è fermo, RUN se sta premendo una freccia).

---

### Passo 12: La funzione is_rolling

Aggiungi come ultima funzione:

```gdscript
func is_rolling() -> bool:
	return state == State.ROLL
```

Questa funzione restituisce `true` se il player sta rollando. Non la usiamo in questa lezione, ma ci servirà nella prossima quando aggiungeremo i nemici — durante la capriola, il player sarà invulnerabile.

---

### Il codice completo

Controlla che il tuo `player.gd` sia esattamente così:

```gdscript
extends CharacterBody2D

# === Costanti di movimento ===
const SPEED = 100.0
const JUMP_VELOCITY = -270.0
const JUMP_CUT_FACTOR = 0.4
const ROLL_SPEED = 180.0
const ROLL_DURATION = 0.33

# === Stati possibili ===
enum State { IDLE, RUN, JUMP, ROLL }

# === Variabili ===
var state: State = State.IDLE
var roll_timer: float = 0.0
var roll_direction: float = 0.0

# Riferimento all'AnimatedSprite2D (lo prendiamo una volta sola)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Gravità — si applica sempre, in ogni stato
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Leggiamo la direzione premuta dal giocatore
	var direction := Input.get_axis("ui_left", "ui_right")

	# Flip della sprite quando si preme una direzione
	if direction != 0:
		anim.flip_h = direction < 0

	# === Macchina a stati ===
	match state:
		State.IDLE:
			_state_idle(direction)
		State.RUN:
			_state_run(direction)
		State.JUMP:
			_state_jump(direction)
		State.ROLL:
			_state_roll(delta)

	# Movimento effettivo
	move_and_slide()


func _state_idle(direction: float) -> void:
	# Decelerazione fino a fermarsi
	velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction != 0:
		_change_state(State.RUN)
		return


func _state_run(direction: float) -> void:
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction == 0 and is_zero_approx(velocity.x):
		_change_state(State.IDLE)
		return


func _state_jump(direction: float) -> void:
	# Movimento orizzontale in aria
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Variable jump: se rilasci il tasto mentre sali, tagli la velocità
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_FACTOR

	# Transizione: atterra
	if is_on_floor():
		if direction != 0:
			_change_state(State.RUN)
		else:
			_change_state(State.IDLE)
		return


func _state_roll(delta: float) -> void:
	roll_timer -= delta
	velocity.x = roll_direction * ROLL_SPEED

	# Transizione: la capriola è finita
	if roll_timer <= 0.0:
		if not is_on_floor():
			_change_state(State.JUMP)
		elif is_zero_approx(Input.get_axis("ui_left", "ui_right")):
			_change_state(State.IDLE)
		else:
			_change_state(State.RUN)
		return


func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	_change_state(State.JUMP)


func _start_roll(direction: float) -> void:
	roll_direction = sign(direction)
	roll_timer = ROLL_DURATION
	_change_state(State.ROLL)


func _change_state(new_state: State) -> void:
	# Evitiamo di riavviare la stessa animazione
	if state == new_state:
		return

	state = new_state

	match state:
		State.IDLE:
			anim.play("idle")
		State.RUN:
			anim.play("run")
		State.JUMP:
			anim.play("jump")
		State.ROLL:
			anim.play("roll")


func is_rolling() -> bool:
	return state == State.ROLL
```

Salva con **Ctrl+S**.

---

## 10. Prova il gioco! ▶

Premi **▶** (o `F5`). Ora il player ha le animazioni!

Prova queste cose:

- **Stai fermo** — il cavaliere fa l'animazione idle
- **Muoviti** con le frecce — il cavaliere corre con l'animazione run
- **Salta** con Spazio — il cavaliere mostra la posa di salto
- **Salto variabile** — premi e rilascia Spazio velocemente per un salto corto, tieni premuto per un salto alto
- **Capriola** — premi **Shift** mentre ti muovi per rollare in avanti
- **Cambio direzione** — lo sprite si gira quando cambi verso

<!-- 📸 SCREENSHOT: gioco in esecuzione con il player che mostra l'animazione di corsa -->

<!-- 📸 SCREENSHOT: gioco in esecuzione con il player che mostra l'animazione di capriola -->

Se qualcosa non funziona:

| Problema | Cosa controllare |
|---|---|
| Il player non si muove | Controlla che lo script `player.gd` sia attaccato al CharacterBody2D e che non ci siano errori nel pannello Output |
| Le animazioni non cambiano | Verifica che i nomi delle animazioni nello SpriteFrames corrispondano esattamente a quelli nel codice: `idle`, `run`, `jump`, `roll` (tutto minuscolo) |
| La capriola non funziona | Controlla di aver aggiunto l'azione `roll` nell'Input Map (Project Settings) con il tasto Shift assegnato |
| Lo sprite non si gira | Verifica che la riga `anim.flip_h = direction < 0` sia dentro `_physics_process`, non dentro una delle funzioni di stato |
| Errore "Invalid call" su `anim` | Controlla che la riga `@onready var anim` sia presente e che il nodo si chiami esattamente `AnimatedSprite2D` |

---

## Cosa abbiamo ottenuto

Riassumiamo quello che abbiamo costruito in questa lezione:

- ✅ Il player ha **6 animazioni**: idle, run, jump, roll, hit, death
- ✅ Lo script usa una **macchina a stati** per gestire i comportamenti in modo ordinato
- ✅ Il **salto variabile** permette salti corti e salti alti con lo stesso tasto
- ✅ La **capriola** (Shift) lancia il player in avanti con un'animazione veloce
- ✅ Lo sprite si **gira** nella direzione di movimento
- ✅ L'input `roll` è configurato nelle **Project Settings**

Il personaggio non è più un pupazzo che scivola: corre, salta, rotola e risponde ai comandi in modo fluido.

<!-- 📸 SCREENSHOT: il gioco in esecuzione, risultato finale della lezione — player con diverse animazioni in azione -->

---

## Prova tu 🎮

Ecco alcune cose che puoi provare a fare da solo:

1. **Cambia la velocità della capriola**: apri `player.gd` e prova a cambiare `ROLL_SPEED` da 180 a 250. La capriola diventa uno scatto velocissimo. Prova anche con 100 — diventa una rotolata lenta. Trova il valore che ti piace.

2. **Sperimenta con il salto variabile**: cambia `JUMP_CUT_FACTOR` da 0.4 a 0.1 — il salto corto diventa cortissimo. Prova con 0.8 — quasi non si nota la differenza tra salto corto e lungo. Qual è il valore che dà il feeling migliore?

---

## Prossima lezione

Il player è completo: si muove, salta, rotola, e le animazioni seguono ogni azione. Ma il livello è ancora vuoto — non ci sono ostacoli da evitare, niente da raccogliere, nessun pericolo.

Nella prossima lezione aggiungeremo **nemici** che pattugliano le piattaforme, **monete** da raccogliere e **zone mortali** che fanno ricominciare il livello. Il gioco inizierà ad avere un vero gameplay.
