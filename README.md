# CroakyMon Gotta Catch Them All!

A Pokémon-alike single-file HTML5 canvas game designed by my son. Built iteratively in Claude Cowork sessions.

Live: **https://84gareth.github.io/croakymon/**

## Play locally
```
python3 -m http.server 8000
```
Then open http://localhost:8000/croakymon.html.

An HTTP server is required (not `file://`) because Three.js loads `.glb` models from `assets/` at runtime.

## Structure
```
croakymon.html          # the game
assets/                 # 3D CroakyMon models exported from Meshy (.glb)
.github/workflows/      # auto-optimizer for GLB assets
handover.md             # running project spec + changelog
```

## Adding a new CroakyMon model
1. Export the textured model from Meshy as `.glb`.
2. Rename to the species name (e.g. `frogniter.glb`) — see `assets/README.md` for the list.
3. Commit and push. The GLB auto-optimizer workflow shrinks it in place; GitHub Pages redeploys within ~30 seconds.

## Credits
Design: Gareth's son. Code: Gareth, iterating with Claude.
