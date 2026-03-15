# Asset

## Cosa sono gli asset?

Nel mondo dei videogiochi, si chiamano **asset** tutti i file "di contenuto" che compongono il gioco:

- 🖼️ **Immagini** — i personaggi, i nemici, i fondali, le tile
- 🔊 **Suoni** — effetti sonori (salto, esplosione, moneta raccolta...)
- 🎵 **Musica** — la colonna sonora
- 🔤 **Font** — i caratteri usati per testi e punteggi
- 🎬 **Animazioni**, **video**, **3D models**...

In pratica: tutto tranne il codice.

## Sprite e Spritesheet

Le immagini dei personaggi si chiamano **sprite**. Spesso tutti i frame di un personaggio (fermo, che cammina, che salta...) sono raggruppati in una singola immagine grande chiamata **spritesheet**. Godot sa come ritagliare i singoli frame da uno spritesheet.

## Come Godot gestisce gli asset

Quando aggiungi un file nella cartella del progetto, Godot lo **importa** automaticamente — cioè lo converte in un formato ottimizzato per il gioco. Per ogni file trovi un file `.import` accanto: non toccarlo, lo gestisce Godot.

## Pixel art e font

Nel nostro gioco usiamo la **pixel art** — uno stile grafico in cui ogni pixel è visibile e conta. I font che usiamo (`PixelOperator8`) sono anch'essi in stile pixel art, con caratteri netti e squadrati.
