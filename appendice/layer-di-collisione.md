# Layer di collisione

## Il problema

Immagina di avere nel gioco: il player, un nemico, delle monete e il pavimento. Tutti questi oggetti esistono nello stesso mondo. Ma non tutti devono "scontrarsi" con tutti:

- Il player deve scontrarsi con il **pavimento** (altrimenti cade giù per sempre)
- Il player deve scontrarsi con i **nemici** (per subire danno)
- Il player deve scontrarsi con le **monete** (per raccoglierle)
- Il nemico **non** deve scontrarsi con le monete
- Le monete **non** devono scontrarsi tra di loro

Come facciamo a dire a Godot chi collide con chi?

## La soluzione: i layer

Godot usa un sistema a **layer** (strati). Puoi pensarli come delle categorie:

| Layer | Nome nel nostro gioco |
|---|---|
| 1 | Player |
| 2 | Moving Platforms |
| 3 | Pickups (monete, frutti...) |
| 4 | Tiles (il pavimento) |
| 5 | Killzone |

Ogni oggetto ha due impostazioni:

- **Collision Layer** — *"Io sono su questo layer"* (la mia categoria)
- **Collision Mask** — *"Io interagisco con questi layer"* (chi voglio rilevare)

## Un esempio

Il **player** è sul layer 1 (Player), e ha la mask sui layer 2 e 4 (Piattaforme + Tiles). Questo significa: il player cammina sul pavimento e sulle piattaforme, ma ignora le monete e la killzone (che vengono gestite in altro modo tramite le `Area2D`).

## Perché li configuriamo subito?

I layer vanno configurati **prima** di costruire le scene, perché ogni nodo fisico che aggiungiamo dovrà sapere su quale layer stare. Se li cambiamo dopo, dobbiamo andare a correggere tutti i nodi uno per uno.
