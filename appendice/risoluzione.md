# Risoluzione, Viewport e Finestra

## La risoluzione di un gioco

Quando fai un gioco, devi decidere **quanto è grande il "campo da gioco"** — cioè quanti pixel vedi sullo schermo. Questa si chiama **risoluzione**.

Nel nostro gioco usiamo una risoluzione di **432 × 240 pixel**. Sembra pochissimo, vero? È intenzionale: è la risoluzione tipica dei giochi retrò in **pixel art**. Ogni pixel è grande e visibile — è l'estetica che vogliamo.

## Viewport

Il **viewport** è la "finestra sul mondo di gioco". Puoi immaginarlo come la telecamera: tutto quello che sta dentro il viewport viene mostrato al giocatore.

Nel nostro caso il viewport misura 432 × 240 pixel — esattamente la nostra risoluzione di gioco.

## La finestra sul desktop

432 × 240 pixel su un monitor moderno sarebbe minuscolo! Quindi Godot **ingrandisce** la finestra automaticamente.

Noi la mostriamo a **1296 × 720 pixel** — esattamente 3 volte più grande (432 × 3 = 1296, 240 × 3 = 720). Questo ingrandimento mantiene i pixel nitidi e squadrati, perfetti per la pixel art.

```
Viewport (gioco interno):  432 × 240
Finestra (schermo):       1296 × 720  (3×)
```

## Stretch mode: Viewport

La **stretch mode** dice a Godot come adattare il viewport alla finestra. Con la modalità `viewport`, il gioco viene renderizzato alla risoluzione bassa e poi ingrandito — esattamente quello che vogliamo per la pixel art.

## Filtro texture: Nearest

Di default Godot sfuma le immagini quando le ingrandisce (per renderle più morbide). Per la pixel art è il contrario di quello che vogliamo! Impostando il filtro su **Nearest**, ogni pixel resta un quadratino netto e preciso.
