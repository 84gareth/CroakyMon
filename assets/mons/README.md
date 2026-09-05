# CroakyMon creatures

Every creature the game knows about lives in this folder:
- Its 3D model as `<slug>.glb` (Meshy export, auto-optimised on push)
- Its stats in `mons.json`, keyed by the same slug

## Add a new creature — 30-second workflow
1. Export a `.glb` from Meshy.
2. Rename it to lowercase-with-hyphens, e.g. `flame-cat.glb`.
3. Drop it into this folder.
4. Wait ~30 seconds — the auto-sync daemon commits it, and a GitHub Action:
   - Optimises the GLB (Draco + WebP).
   - Adds a default entry in `mons.json` under the same slug.
5. Reload the game on the tablet — the new creature is there, as a wild-only
   normal-type with `Tackle` and a generic blob shape.

## Customise it
Open `mons.json` in a text editor (or ask the assistant to). Every field on an
entry is optional; missing fields fall back to sensible defaults so a fresh
creature always battles.

```json
"flame-cat": {
  "name": "Flame Cat",
  "types": ["fire"],
  "hp": 32,
  "moves": ["HotDiggityDoggyDog", "Tackle"],
  "starter": false,
  "shape": "blob",
  "color": "#e85a2a",
  "accent": "#ffd05a"
}
```

Field | Default | Notes
---|---|---
`name` | Title-cased slug | Shown in-game.
`types` | `["normal"]` | 1 or 2 types. Known: `fire`, `water`, `grass`, `electric`, `normal`, `ghost`.
`hp` | `30` | Max HP.
`moves` | `["Tackle"]` | Move keys. Known: `HotDiggityDoggyDog`, `ThunderWay`, `TreeStomp`, `SharkWave`, `SpookyPinch`, `Tackle`. Unknown names silently become `Tackle`.
`starter` | `false` | Show in Professor Ribbit's lab as a starter choice.
`shape` | `"blob"` | Polygon fallback used when the `.glb` is still loading or missing. Built-ins: `dragon`, `bird`, `turtle`, `squid`, `crab`, `blob`.
`color` | `"#a8a8a8"` | Primary colour (blob fallback + palette hint).
`accent` | `"#e0e0e0"` | Belly / highlight.

## Remove a creature
Delete both `<slug>.glb` and its entry in `mons.json`. Missing files
gracefully fall back to polygon art rather than crashing.
