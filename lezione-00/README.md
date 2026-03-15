# Lezione 00 – Setup del progetto

Benvenuto al corso! In questa lezione prepariamo l'ambiente di lavoro e scarichiamo il progetto base da cui partiremo in ogni lezione.

---

## Cosa trovi in questa cartella

- Progetto Godot 4 già configurato con:
  - Impostazioni di finestra e viewport corrette
  - Physics layers già nominati
  - Tutti gli asset (sprite, font, suoni, musica) già importati

---

## Come aprire il progetto

1. Scarica e installa **Godot 4** da [godotengine.org](https://godotengine.org/)
2. Scarica questa cartella (o l'intera repo con il bottone **Code → Download ZIP**)
3. Apri Godot → **Import** → seleziona il file `project.godot` dentro `lezione-00/`

---

## Struttura degli asset

```
lezione-00/
├── assets/
│   ├── fonts/         # Font pixel art
│   ├── music/         # Musica di sottofondo
│   ├── sounds/        # Effetti sonori
│   └── sprites/       # Sprite e tileset
├── icon.svg
└── project.godot
```

---

## Impostazioni già configurate

| Impostazione | Valore |
|---|---|
| Risoluzione viewport | 432 × 240 |
| Finestra di gioco | 1296 × 720 (3×) |
| Stretch mode | Viewport |
| FPS massimi | 120 |
| Filtro texture | Nearest (pixel art) |

### Physics Layers (2D)

| Layer | Nome |
|---|---|
| 1 | Player |
| 2 | Moving Platforms |
| 3 | Pickups |
| 4 | Tiles |
| 5 | Killzone |
