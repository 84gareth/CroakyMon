# Handover — CroakyMon Gotta Catch Them All!

**Version:** 0.7.0
**Owner:** Gareth
**Designer:** Gareth's child
**Last updated:** 2026-09-05

## Concept
Pokémon-alike single-file HTML5 canvas game designed by Gareth's child. Player walks around the town of Fundude, finds CroakyMons in tall grass, and battles/catches them. Goal: catch them all. Antagonists (not yet implemented): **Team Evil Soup**, who want to turn CroakyMons into soup.

## Constraints (project-wide)
- **Single-file rule RELAXED as of v0.4.0** — the game now supports real 3D models from Meshy, which need to live as separate files. The project is now `croakymon.html` plus an `assets/` folder of `.glb` files. Everything else (music, VFX, art fallbacks) remains inline. Static single-file distribution is no longer possible; local play needs a tiny HTTP server (see below).
- Mobile-first, portrait, no scrolling anywhere, preserved gameplay viewport (360x640 logical, scaled to fit).
- No emoji in UI — plain text and coloured shapes only.
- `node --check` on the extracted script block before delivery.
- Headless simulation/physics validation before delivery.
- Version numbers bumped every release.
- Read-before-edit; be direct about failures; never ship broken code.

## Files
- `croakymon.html` — the game. Loads Three.js from jsdelivr; loads `.glb` models from `assets/`.
- `assets/` — Meshy `.glb` files, one per species. See `assets/README.md` for the exact filenames.
- `handover.md` — this document.
- (dev-only, not shipped: `script.js` extracted for `node --check`, `sim.js` headless test harness.)

## Running locally
The browser blocks `file://` fetches of `.glb`, so the game needs a real HTTP server locally. From the folder containing `croakymon.html`:

```
python3 -m http.server 8000
```

Then open http://localhost:8000/croakymon.html. On GitHub Pages, no extra setup — everything is served over HTTPS and `.glb` loads fine on iPad.

## Kid's design brief (locked)
| # | Question | Answer |
|---|---|---|
| 1 | Main character | Choose boy or girl |
| 2 | Setting | Fundude — a normal town with houses |
| 3 | Goal | Collect creatures like Pokémon |
| 4 | Controls | Keyboard on desktop, on-screen dpad + A/B on iOS |
| 5 | Enemies | Team Evil Soup — turn your CroakyMons into soup |
| 6 | Moves | HotDiggityDoggyDog (fire), ThunderWay (electric), Tree Stomp (grass), Shark Wave (water) |
| 7 | Collect | CroakyMons themselves + items |
| 8 | Win | Catch them all |
| 9 | Art | Low-poly and colourful |
| 10 | Name | CroakyMon Gotta Catch Them All! |

## New in v0.7.0
**Big visual pass — logo, CroakyDex, kid-friendly UI, brighter 3D.**
- Fixed a long-standing bug: the `VERSION` constant was stuck at "0.2.0" while the header comment said the right number, so the title chip read wrong. All version bumps now stay in sync.
- Meaty logo: chunky outlined `CroakyMon` word-mark with sunset gradient, per-letter tilt, subtle per-letter bob, dark drop-shadow, glossy top-edge shine. Subtitle sits in its own teal pill. Version chip below.
- Title screen mons face the camera head-on (`pose:"portrait"`), with a gentle sway. Previously they were locked to the 3/4 battle angle.
- Mon3D lighting cranked up: key light 1.4→2.4, fill 0.6→1.1, rim 0.5→0.9, ambient 0.35→0.8. Models pop on the OLED tablet.
- New UI kit shared across every screen: `rrect` (rounded rects), `panel` (drop-shadowed cards), `drawTypeBadge` (rounded type chips), `pillButton` (chunky buttons with drop shadow + top-glossy highlight + focus ring).
- Battle menu redone with pillButton: FIGHT/CATCH/RUN are big coloured buttons; move buttons are type-coloured with a type badge on the right; HP bars segmented with tick marks.
- Message box is now a drop-shadowed panel with a bouncing "A ›" prompt.
- **CroakyDex** (was the plain team screen): grid view with numbered cards, model portraits, per-mon type badges, silhouette placeholder for uncaught. Cursor navigation (arrows), A opens detail view — big model, HP bar, up-to-two move pills, type badges, STARTER pill if applicable, L/R to flip through species. B goes back.
- Overworld B now always opens the dex on the grid (dexView reset), not wherever it was left.

## New in v0.6.0
**Data-driven mon roster — one folder, one JSON file, done.**
- Creatures now live in **`assets/mons/`**: their `.glb` model plus an entry in **`assets/mons/mons.json`** keyed by the filename slug.
- The game fetches `mons.json` at startup and merges each entry into the internal species table. Every field is optional; unknown moves silently fall back to `Tackle` so a mistyped entry never crashes battle.
- **Add a creature in ~30 seconds**: drop `flame-cat.glb` into `assets/mons/`. The auto-sync daemon pushes it; a new GitHub Action **`sync-mons-manifest.yml`** appends a default entry (normal type, HP 30, Tackle only, wild-only, blob shape); the existing optimiser Action shrinks the `.glb`. Reload — the mon appears in the wild.
- **Customise later**: edit `mons.json` in a text editor (or ask the assistant). Fields: `name`, `types` (array, 1–2), `hp`, `moves`, `starter` (bool), `shape` (`dragon`/`bird`/`turtle`/`squid`/`crab`/`blob`), `color`, `accent`.
- **Generic polygon fallback** (`drawBlob`) for auto-added mons before you set a proper shape — coloured by the entry's `color`/`accent` so it at least looks distinct.
- **Existing creatures kept**: `mons.json` ships with all 5 current species pre-filled so nothing regresses. `DEFAULT_SPECIES` in the code doubles as an offline fallback if the manifest fetch fails.
- **STARTERS** is now derived at manifest load from entries with `"starter": true` — mark or unmark starters by editing the JSON, no code change needed.
- **Optimiser action** re-scoped to `assets/mons/**.glb` (was `assets/**.glb`).
- New human-facing doc at `assets/mons/README.md` explains the whole workflow.

## New in v0.5.0
**CryptyCrab — first wild-only dual-type creature.**
- New species **CryptyCrab**: dual-type normal/ghost, wild-only (not in the starter list). HP 35, knows *Spooky Pinch* (ghost) and *Tackle* (normal); both get STAB.
- New elemental type **Ghost** added to `EFF`. Deliberately kept child-friendly: normal ↔ ghost is 0.5x both ways (never the classical 0x), so no battle can soft-lock.
- `damage()` extended for **dual-type defence**: effectiveness multiplies through every type on the defender. Single-type mons behave exactly as before.
- STAB now checks either of the attacker's two types, so a normal-move on CryptyCrab or a ghost-move both get the 1.5x boost.
- Polygon fallback **`drawCryptyCrab`** — wispy purple-white crab with stalked eyes, two pincers (one grounded, one floating with a ghost-trail), and a soft aura underneath.
- Added to the **title screen mascot lineup** and the **win-screen ensemble**, both re-laid-out for five creatures.
- **Collection screen** rebuilt as a proper 2×3 grid so the fifth card fits without overflowing the fixed portrait viewport. Cards now show `type / type2` for dual-typed species.
- `Mon3D.CONFIG` gains `CryptyCrab: "assets/crypty-crab.glb"` — as soon as that file is committed, the 3D model renders in place of the polygon art (identical pipeline as Crimson Fungus).

## New in v0.4.0
**Real 3D models for CroakyMons — Meshy `.glb` pipeline.**
- Loads Three.js r160 from jsdelivr via an ES-module importmap and a `GLTFLoader`. No build step; no bundler.
- New `Mon3D` module runs a **hidden 256×256 offscreen WebGL renderer**. Each species with a loaded `.glb` renders to that canvas and gets blitted into the main 2D game canvas as an image via `drawImage`. The rest of the game (battle logic, tiles, VFX, audio, UI) is untouched.
- Species → asset map lives in `Mon3D.CONFIG` at the top of the file. Currently expects `assets/frogniter.glb`; commented-out entries for the other three are ready to uncomment.
- Model auto-fits: on load, the scene is bounding-boxed, uniformly scaled to ~2 units tall, and re-centred so it stands on the ground.
- Three-point lighting (key + fill + rim) tuned for saturated cartoon materials — matches Meshy's textured look.
- Idle bob (subtle vertical sine) so 3D mons feel alive; facing is set from the same ±1 `facing` argument the polygon art already uses, so player vs wild pose works out of the box.
- **Graceful fallback:** if a species has no `.glb` (still loading, missing file, or WebGL init failed), the game silently falls back to the existing polygon `drawFrogniter` / `drawBolttoad` / `drawVinehop` / `drawTidefrog`. This means you can swap creatures in one at a time as their Meshy models are ready.
- `assets/README.md` covers exact filenames, how to export from Meshy, how to run locally, and how to host on GitHub Pages.

## New in v0.3.0
**Proper starter flow — no more mid-battle fallback.**
- The top-left house in Fundude is now **Professor Ribbit's lab**, distinguished by a green roof and a chimney puffing steam.
- In front of it is a **red doormat tile marked "LAB"**. Stepping onto it opens the lab scene automatically.
- Wild encounters in tall grass are now **gated on `hasStarter`** — a starterless player can walk through the tall grass with no risk.
- A blinking yellow HUD banner nudges the player to visit the lab until they have their starter.
- Inside the lab: Professor Ribbit (a frog scientist in a lab coat with round glasses and a clipboard) introduces herself, then hands you a three-card starter picker.
- **Three starters**, one of each requested type: **Frogniter (fire)**, **Vinehop (grass)**, **Tidefrog (water)**. Left/Right cycles, A confirms, B leaves without picking. The Electric starter (Bolttoad) is intentionally *not* offered — it stays a wild-only catch, per the child's brief that fire/grass/water are the choice.
- The intro dialogue on trainer confirm now points the player straight at the lab.
- The old "Professor Ribbit gave you a random starter to fight with" fallback in `startEncounter` is removed; that branch was unreachable now that encounters are gated.
- Returning to the lab after choosing gives a friendly one-liner and puts the player back outside.
- Play-again from the win screen resets `hasStarter` so the choice matters every run.

## New in v0.2.0
**Varied creature designs** — each CroakyMon is now a distinctly different animal, all drawn from primitive polygons for the low-poly look:
- **Frogniter (fire)** — chubby dragon whelp with horns, wing nubs, and a flame belly.
- **Bolttoad (electric)** — round-bodied lightning bird with a jagged bolt crest, sky-blue lightning-shaped wings, and a beak.
- **Vinehop (grass)** — sprout turtle with a green plated shell, a leafy sprout on top, and stubby legs.
- **Tidefrog (water)** — squid/octopus with a spotted mantle, fin flanges, and five wavy tentacles.

**Move VFX (per type)** — every attack now plays a windup animation, an impact tint, a bright ring flash, screen shake, and particles:
- **Fire (HotDiggityDoggyDog)** — a fireball travels from attacker to target trailing orange sparks, orange screen tint on impact.
- **Electric (ThunderWay)** — three jagged white/yellow bolts arc across the screen with sparkle-star particles, bright yellow tint on impact.
- **Grass (Tree Stomp)** — curling vines rise up around the target with drifting leaf particles, green tint on impact.
- **Water (Shark Wave)** — a rolling sine-wave crest sweeps across with cyan spray particles, blue tint on impact.
- **Normal (Tackle)** — quick white flash, minimal particles.
Impact frames apply damage exactly when the visual hit lands, so it always reads right.

**Audio (WebAudio, procedurally generated — no external files):**
- **Music** — light chiptune loop per mood: title, town (overworld), battle, win. Each is a repeating arpeggio + bass over the tonic, tempo and waveform shift with mood (battle is faster/edgier square wave).
- **SFX** — step, menu blip, select, back, encounter sweep, per-type move stings (fire noise sweep + low sub, electric buzz sequence, grass triangle thud, water filtered splash), hit thump (pitch drops on super-effective), faint slide, catch throw/shake/win jingle/fail slide, final "you caught them all" fanfare.
- **Mute** — top-right SOUND button toggles all audio; also unlocks audio on first press for iOS Safari.
- **Autoplay** — audio initialises on first key/tap (browser policy) and starts the appropriate music track for the current screen.

## Retained from v0.1.0
- Title, trainer select, Fundude overworld (15x22 tiles, no scroll), tile-by-tile movement, wild encounters (~28% on tall grass with cooldown), turn-based battles, type chart (fire→grass, water→fire, grass→water, electric→water at 2x; same-type at 0.5x; STAB x1.5), HP bars, catch-chance rising as HP falls, team screen, win screen, child-friendly full-heal on faint (no soft-locks).

## CroakyMon roster
| Species | Type | HP | Signature move | Design |
|---|---|---|---|---|
| Frogniter | Fire | 34 | HotDiggityDoggyDog | Dragon whelp |
| Bolttoad | Electric | 32 | ThunderWay | Lightning bird |
| Vinehop | Grass | 36 | Tree Stomp | Sprout turtle |
| Tidefrog | Water | 36 | Shark Wave | Ink squid |
All also know Tackle (normal) as a backup.

## Controls
- **Desktop:** Arrows / WASD to move. Space / Enter / Z = A (confirm / attack). X / Esc = B (back / team menu). Tap the SOUND button to mute.
- **Touch:** on-screen dpad bottom-left; A (yellow) confirms/attacks, B (teal) goes back / opens team menu on the overworld. SOUND button top-right.

## Validation done for v0.4.0
- `node --check` on extracted game script (~58KB) — passes.
- Sim harness re-run: all previous asserts still hold (type chart, STAB, 500-battle mixed outcomes, catch curve, map walkability, professor door reachable, 1 lab + 1 door).
- 3D pipeline reviewed for safety: Mon3D.render bails cleanly when Three.js isn't ready or the model failed to load, so nothing crashes if the assets folder is empty or WebGL is unavailable. Polygon art still handles every draw path.

## Validation done for v0.3.0
- `node --check` on extracted script (~53KB) — passes.
- Headless sim re-run: type chart, STAB, 500-battle mixed outcomes, catch curve — all still hold.
- Map assertions extended: exactly one 3-tile professor's roof (L), exactly one door tile (D), door reachable from spawn via BFS (322 tiles still reachable).
- Manual review of gating: `updateOverworld` only rolls encounters when the tile is "T", `game.hasStarter` is true, and the cooldown is clear — starterless traversal is safe.

## Validation done for v0.2.0
- `node --check` on extracted script (45KB) — passes.
- Headless sim of 500 randomised battles — all terminate; mixed wins/losses (278/222 in the seeded run).
- Type chart asserted; STAB+super-effective always outdamages Tackle over 200 rolls; catch chance monotonic; map spawn walkability + reachable tall grass confirmed via BFS (322 tiles reachable).
- Manual verification of the new code: audio pipeline gates on user gesture (iOS Safari policy), mute cuts master gain, VFX system routes damage through the impact hook so numbers apply exactly when the visual lands.

## Known limitations (deliberate)
- No Team Evil Soup encounter yet — teased in intro and win screen.
- No items (Froggo Balls unlimited); no shop; no NPCs.
- Party holds multiple CroakyMons but only the first fights (no switching).
- No persistence (refresh resets progress).
- Houses are decoration; you can't enter them.
- Music is a short loop and intentionally low-key so it doesn't fight the move SFX; can be swapped for richer patterns later.

## Roadmap
- **v0.3** — Team Evil Soup grunt encounter scripted near the central grass; adds items (Soup Antidote heals; Big Froggo Ball better catch).
- **v0.4** — Party switching in battle; second-form evolutions.
- **v0.5** — NPC dialogue in houses; `localStorage` save.
- **v1.0** — Full 8–12 species roster the child helps name; boss fight with Team Evil Soup's Chef.

## Changelog
- **0.7.0** (2026-09-05) — Visual pass: chunky animated logo; face-forward + brighter 3D on title; shared UI kit (rrect, panel, drawTypeBadge, pillButton); redesigned battle menu with type-coloured move buttons and segmented HP bars; drop-shadowed message overlay; proper CroakyDex with grid + detail views. Fixed VERSION const drift.
- **0.6.0** (2026-09-05) — Data-driven roster: `assets/mons/` folder holding both `.glb` models and a `mons.json` manifest. Game loads the manifest at boot and merges into `SPECIES`; STARTERS derived from `starter:true` entries. New `sync-mons-manifest.yml` Action auto-adds default entries for new `.glb` files. Generic `drawBlob` polygon fallback. Optimiser Action re-scoped to `assets/mons/`. New `assets/mons/README.md`.
- **0.5.0** (2026-09-05) — Added CryptyCrab (normal/ghost, wild-only) with `Spooky Pinch`; added Ghost elemental type; dual-type defence + dual-type STAB in `damage()`; polygon fallback; title + win + collection screens updated for five species; asset slot for `crypty-crab.glb`. All previous validation still passes, plus new dual-type asserts.
- **0.4.0** (2026-09-05) — Real 3D CroakyMon models via Three.js + GLTFLoader; hidden offscreen WebGL render blitted onto the 2D canvas per draw call; auto-fit / centred / three-point lit / idle-bobbing; graceful fallback to polygon art per species; new `assets/` folder for `.glb` files with README; single-file rule relaxed for this project only.
- **0.3.0** (2026-09-05) — Professor Ribbit's lab (top-left house, green roof, "LAB" doormat); wild encounters gated on picking a starter; three-card starter picker (Frogniter / Vinehop / Tidefrog); blinking HUD nudge until picked. Removed the old random-starter mid-battle fallback. All previous validation still passes; new map-shape assertions added.
- **0.2.0** (2026-09-05) — Varied creature silhouettes (dragon whelp, lightning bird, sprout turtle, ink squid); per-type move VFX with windup, impact tint, ring flash, screen shake and particles; WebAudio SFX for every action and a mood-aware chiptune music loop; SOUND mute button. All previous validation still passes.
- **0.1.0** (2026-09-05) — Full playable slice: title, trainer select, Fundude overworld, wild encounters, turn-based battles with type chart + STAB, catching, team screen, win state. Validated with `node --check` and 500-battle headless sim.
- **0.0.1** (2026-09-05) — Project kicked off with 10-question design brief.
